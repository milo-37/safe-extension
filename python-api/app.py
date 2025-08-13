from flask import Flask, request, jsonify
import re
import socket
import requests
from urllib.parse import urlparse, urljoin
import tldextract
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor
from bs4 import BeautifulSoup
import pickle
import os
from sklearn.ensemble import RandomForestRegressor
import pandas as pd
from functools import lru_cache

# ========================= Load ML model (nếu có) ========================= #
ML_MODEL_PATH = "ml_model.pkl"
ml_model = None
if os.path.exists(ML_MODEL_PATH):
    with open(ML_MODEL_PATH, "rb") as f:
        ml_model = pickle.load(f)

# ========================= Flask app ====================================== #
app = Flask(__name__)

# ---------- HTTP session pool ---------- #
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"
}
HTTP = requests.Session()
HTTP.headers.update(HEADERS)

# ========================= Static criteria ================================= #
CRITERIA_WEIGHTS = {
    "SCAM_KEYWORDS": 10,
    "ADULT_KEYWORDS": 8,
    "BAD_COUNTRY_TLDS": 7,
    "FAKE_ALERTS": 9,
    "HATE_KEYWORDS": 6,
    "MALICIOUS_ADS": 5,
    "FAKE_MEDICAL_KEYWORDS": 9,
}

criteria_data = {
    "SCAM_KEYWORDS": ["trúng thưởng", "kiếm tiền nhanh", "xác minh tài khoản ngay"],
    "ADULT_KEYWORDS": ["xxx", "sexy", "nude", "lộ hàng", "sex"],
    "BAD_COUNTRY_TLDS": [
        ".ru", ".cn", ".kp", ".ir", ".sy", ".online", ".store", ".xyz", ".tk", ".cc", ".ml", ".ga",
        ".cf", ".gq", ".ru", ".pw", ".to", ".party", ".top", ".buzz", ".club", ".win", ".work",
        ".website", ".click", ".host", ".space", ".fun", ".co", ".party", ".money", ".life",
        ".pro", ".site", ".vip", ".bid", ".icu", ".link",
    ],
    "FAKE_ALERTS": ["máy tính của bạn bị nhiễm virus", "bấm vào đây để sửa lỗi"],
    "HATE_KEYWORDS": ["hate", "kill", "nazi"],
    "FAKE_MEDICAL_KEYWORDS": ["chữa bách bệnh", "thuốc thần kỳ", "trị ung thư"],
    "MALICIOUS_ADS": ["pop-up", "popup", "quảng cáo không thể tắt"],
}

# ========================= I/O helpers ===================================== #
@lru_cache(maxsize=8192)
def fast_resolve(host: str) -> str:
    """Lấy IPv4 của host và cache."""
    return socket.gethostbyname(host)


def fetch_html(url: str, timeout: int = 5):
    """Trả về (html, load_time) với HTTP session pool."""
    resp = HTTP.get(url, timeout=timeout, allow_redirects=True)
    return resp.text, resp.elapsed.total_seconds()

# ========================= HTML utilities ================================== #
def extract_visible_text(html):
    soup = BeautifulSoup(html, "html.parser")

    # Loại bỏ các thẻ không hiển thị với người dùng
    for tag in soup(["script", "style", "meta", "noscript", "iframe"]):
        tag.decompose()

    # Lấy toàn bộ nội dung hiển thị
    visible_texts = soup.stripped_strings
    return " ".join(visible_texts).lower()

# ========================= Feature helpers ================================= #
def apply_blacklist_keywords(html, criteria):
    total_deduction = 0
    matches = []

    # Chỉ trích xuất text hiển thị một lần
    visible_text = extract_visible_text(html)
    html_lower = html.lower()

    for category, keywords in criteria.items():
        if category == "BAD_COUNTRY_TLDS":
            continue

        weight = CRITERIA_WEIGHTS.get(category, 5)

        # Tùy nhóm, kiểm tra ở visible_text hay full HTML
        content_to_check = html_lower if category == "MALICIOUS_ADS" else visible_text

        for keyword in keywords:
            if keyword.lower() in content_to_check:
                total_deduction += weight
                matches.append({
                    "category": category,
                    "keyword": keyword,
                    "deduct": weight
                })
                break  # break để không trừ nhiều lần cho cùng một category 
    return total_deduction, matches


def has_privacy_policy(html):
    return 10 if "privacy policy" in html.lower() or "chính sách bảo mật" in html.lower() else 0

def has_contact_info(html):
    keywords = ["contact us", "about us", "địa chỉ", "liên hệ"]
    return 5 if any(k in html.lower() for k in keywords) else 0

def has_meta_info(html):
    meta_fields = ["name=\"author\"", "name='author'", "name=\"description\"", "name='description'"]
    return 5 if any(m in html.lower() for m in meta_fields) else 0

def suspicious_ip(host):
    try:
        ip = fast_resolve(host)
        return ip.startswith("192.") or ip.startswith("10.")
    except Exception:
        return True

def detect_sensitive_form(html):
    sensitive_keywords = [
        "password", "credit card", "ssn", "cccd", "stk", "sothe", "ccv", "cvv", "cmnd",
    ]
    soup = BeautifulSoup(html, "html.parser")
    for form in soup.find_all("form"):
        for tag in form.find_all(["input", "textarea"]):
            for attr_value in tag.attrs.values():
                if isinstance(attr_value, str) and any(k in attr_value.lower() for k in sensitive_keywords):
                    return True
    return False

def detect_redirect(html):
    return "http-equiv=\"refresh\"" in html.lower() or "window.location" in html.lower()

def dynamic_content(html):
    return "<script>" in html.lower() and "innerhtml" in html.lower()

def log_training_data(url, score, features):
    import csv
    from os.path import exists

    log_file = "training_log.csv"
    header = [
        "url", "score",
        "len_url", "is_https", "is_private_ip",
        "domain_age", "is_sensitive_form", "has_redirect",
        "has_script", "has_privacy", "has_contact",
        "age_of_domain", "is_vietnam"
    ]
    row = [url, int(score)] + features
    file_exists = exists(log_file)

    with open(log_file, mode='a', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        if not file_exists:
            writer.writerow(header)
        writer.writerow(row)

# ---------------- HTTPS cert quick‑check ---------------- #
def has_valid_https_cert(url: str) -> bool:
    if not url.startswith("https://"):
        return False
    try:
        HTTP.get(url, timeout=5)
        return True
    except requests.exceptions.SSLError:
        return False
    except requests.exceptions.RequestException:
        return False

# ========================= API: /analyze =================================== #
@app.route("/analyze", methods=["POST"])
def analyze():
    data = request.json or {}
    url = data.get("url")
    domain_age = data.get("domain_age", 0)
    is_vietnam = data.get("is_vietnam", 0)

    parsed = urlparse(url)
    host = parsed.hostname or ""
    ext = tldextract.extract(url)
    full_domain = f"{ext.domain}.{ext.suffix}"

    # ---------- song song hoá tải HTML + DNS ---------- #
    with ThreadPoolExecutor(max_workers=2) as pool:
        future_html = pool.submit(fetch_html, url)
        future_dns = pool.submit(fast_resolve, host)

        html, load_time = future_html.result()
        ip_addr = future_dns.result()

    score = 100
    deductions = []

    # ------------- kiểm tra tĩnh ------------- #
    if suspicious_ip(host):
        score -= 10
        deductions.append({"reason": "Địa chỉ IP đáng ngờ", "score": -10, "type": "negative"})
    if len(full_domain) > 20:
        score -= 5
        deductions.append({"reason": "Tên miền quá dài", "score": -5, "type": "negative"})
    if re.search(r"[^a-zA-Z0-9.]", full_domain):
        score -= 20
        deductions.append({"reason": "Tên miền chứa ký tự đặc biệt hoặc giả mạo", "score": -20, "type": "negative"})
    if not has_valid_https_cert(url):
        score -= 15
        deductions.append({"reason": "Chứng chỉ HTTPS không hợp lệ hoặc không tồn tại", "score": -15, "type": "negative"})

    # ------------- kiểm tra dựa trên HTML ------------- #
    if load_time > 2:
        score -= 5
        deductions.append({"reason": "Tốc độ tải trang chậm", "score": -5, "type": "negative"})

    if detect_sensitive_form(html):
        score -= 20
        deductions.append({"reason": "Có form yêu cầu thông tin nhạy cảm", "score": -20, "type": "negative"})
    if detect_redirect(html):
        score -= 10
        deductions.append({"reason": "Chuyển hướng liên tục", "score": -10, "type": "negative"})
    if dynamic_content(html):
        score -= 10
        deductions.append({"reason": "Nội dung thay đổi sau khi tải trang", "score": -10, "type": "negative"})

    # ------------- TLD blacklist ------------- #
    for bad_tld in criteria_data["BAD_COUNTRY_TLDS"]:
        if full_domain.endswith(bad_tld):
            score -= CRITERIA_WEIGHTS["BAD_COUNTRY_TLDS"]
            deductions.append({
                "reason": f"Đuôi tên miền đáng ngờ: {bad_tld}",
                "score": -CRITERIA_WEIGHTS["BAD_COUNTRY_TLDS"],
                "type": "negative",
            })
            break

    bl_deduction, bl_matches = apply_blacklist_keywords(html, criteria_data)
    score -= bl_deduction
    for m in bl_matches:
        label = m["category"]
        if label == "ADULT_KEYWORDS":
            label = "Nội dung nhạy cảm"
        elif label == "MALICIOUS_ADS":
            label = "Quảng cáo khó chịu"
        elif label == "FAKE_ALERTS":
            label = "Cảnh báo giả mạo"
        elif label == "FAKE_MEDICAL_KEYWORDS":
            label = "Thông tin y tế giả"
        elif label == "HATE_KEYWORDS":
            label = "Ngôn từ kích động"
        elif label == "SCAM_KEYWORDS":
            label = "Dấu hiệu lừa đảo"
        
        deductions.append({
            "reason": f"{label}: '{m['keyword']}'",
            "score": -m["deduct"],
            "type": "negative",
        })

    # ------------- Server country / domain age ------------- #
    if is_vietnam == 2:
        score -= 30
        deductions.append({"reason": "Máy chủ ở nước ngoài", "score": -30, "type": "negative"})
    elif is_vietnam == 1:
        score += 30
        deductions.append({"reason": "Máy chủ ở Việt Nam", "score": 30, "type": "positive"})

    if domain_age < 30:
        score -= 30
        deductions.append({"reason": "Tên miền mới < 1 tháng", "score": -30, "type": "negative"})
    elif domain_age < 90:
        score -= 20
        deductions.append({"reason": "Tên miền mới < 3 tháng", "score": -20, "type": "negative"})
    elif domain_age < 365:
        score -= 10
        deductions.append({"reason": "Tên miền mới < 1 năm", "score": -10, "type": "negative"})
    else:
        score += 5
        deductions.append({"reason": "Tên miền đã hoạt động > 1 năm", "score": 5, "type": "positive"})

    # ------------- Cộng điểm bổ sung ------------- #
    for fn, label in [
        (has_privacy_policy, "Có chính sách bảo mật"),
        (has_contact_info, "Có thông tin liên hệ"),
        (has_meta_info, "Có thông tin mô tả"),
    ]:
        delta = fn(html)
        if delta:
            score += delta
            deductions.append({"reason": label, "score": delta, "type": "positive"})

    # ------------- ML prediction ------------- #
    features = [
        len(url), int(url.startswith("https://")), int(suspicious_ip(full_domain)), domain_age,
        int(detect_sensitive_form(html)), int(detect_redirect(html)), int(dynamic_content(html)),
        int("privacy policy" in html.lower()), int("contact" in html.lower()), domain_age, is_vietnam,
    ]

    if ml_model:
        try:
            df_feat = pd.DataFrame([
                features],
                columns=[
                    "len_url", "is_https", "is_private_ip", "domain_age",
                    "is_sensitive_form", "has_redirect", "has_script", "has_privacy",
                    "has_contact", "age_of_domain", "is_vietnam",
                ],
            )
            pred = ml_model.predict(df_feat)[0]
            delta_ai = round(pred - score)
            deductions.append({
                "reason": "Dự đoán AI (gợi ý)",
                "score": delta_ai,
                "type": "positive" if delta_ai > 0 else "negative",
            })
            score = (score + pred) / 2
        except Exception as e:
            print("Lỗi ML", e)

    # ------------- Log training data (optional) ------------- #
    if score > 80 or score < 70:
        log_training_data(url, score, features)

    return jsonify({"score": max(score, 0), "deductions": deductions})



# ====== API /train-model ======
@app.route('/train-model', methods=['POST'])
def train_model():
    try:
        df = pd.read_csv("training_log.csv")
        df.replace({'True': 1, 'False': 0, True: 1, False: 0}, inplace=True)

        cols_to_float = [
            "len_url", "is_https", "is_private_ip", "domain_age",
            "is_sensitive_form", "has_redirect", "has_script",
            "has_privacy", "has_contact", "age_of_domain", "is_vietnam"
        ]
        for col in cols_to_float:
            df[col] = pd.to_numeric(df[col], errors='coerce')
        df.dropna(subset=cols_to_float + ["score"], inplace=True)

        X = df[cols_to_float]
        y = df["score"]

        model = RandomForestRegressor(n_estimators=100, random_state=42)
        model.fit(X, y)

        with open(ML_MODEL_PATH, "wb") as f:
            pickle.dump(model, f)

        return jsonify({"message": "Train model thành công."})
    except Exception as e:
        print("❌ Lỗi khi train model:", str(e))
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host="127.0.0.1", port=5000, debug=True)
