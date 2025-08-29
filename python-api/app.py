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

ML_MODEL_PATH = "ml_model.pkl"
ml_model = None
if os.path.exists(ML_MODEL_PATH):
    with open(ML_MODEL_PATH, "rb") as f:
        ml_model = pickle.load(f)

app = Flask(__name__)

HEADERS = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)"}
HTTP = requests.Session()
HTTP.headers.update(HEADERS)

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
    "BAD_COUNTRY_TLDS": [".ru",".cn",".kp",".ir",".sy",".online",".store",".xyz",".tk",".cc",".ml",".ga",
                         ".cf",".gq",".ru",".pw",".to",".party",".top",".buzz",".club",".win",".work",
                         ".website",".click",".host",".space",".fun",".co",".party",".money",".life",
                         ".pro",".site",".vip",".bid",".icu",".link"],
    "FAKE_ALERTS": ["máy tính của bạn bị nhiễm virus", "bấm vào đây để sửa lỗi"],
    "HATE_KEYWORDS": ["hate", "kill", "nazi"],
    "FAKE_MEDICAL_KEYWORDS": ["chữa bách bệnh", "thuốc thần kỳ", "trị ung thư"],
    "MALICIOUS_ADS": ["pop-up", "popup", "quảng cáo không thể tắt"],
}

@lru_cache(maxsize=8192)
def fast_resolve(host: str) -> str:
    return socket.gethostbyname(host)

def fetch_html(url: str, timeout: int = 8):
    resp = HTTP.get(url, timeout=timeout, allow_redirects=True)
    return resp.text, resp.elapsed.total_seconds()

def extract_visible_text(html):
    soup = BeautifulSoup(html, "html.parser")
    for tag in soup(["script", "style", "meta", "noscript", "iframe"]):
        tag.decompose()
    return " ".join(soup.stripped_strings).lower()

def apply_blacklist_keywords(html, criteria):
    total_deduction, matches = 0, []
    visible_text = extract_visible_text(html)
    html_lower = html.lower()

    for category, keywords in criteria.items():
        if category == "BAD_COUNTRY_TLDS":
            continue
        weight = CRITERIA_WEIGHTS.get(category, 5)
        content = html_lower if category == "MALICIOUS_ADS" else visible_text
        for keyword in keywords:
            if keyword.lower() in content:
                total_deduction += weight
                matches.append({"category": category, "keyword": keyword, "deduct": weight})
                break
    return total_deduction, matches

def has_privacy_policy(html): return 10 if ("privacy policy" in html.lower() or "chính sách bảo mật" in html.lower()) else 0
def has_contact_info(html):   return 5 if any(k in html.lower() for k in ["contact us","about us","địa chỉ","liên hệ"]) else 0
def has_meta_info(html):      return 5 if any(m in html.lower() for m in ['name="author"',"name='author'",'name="description"',"name='description'"]) else 0

def suspicious_ip(host):
    try:
        ip = fast_resolve(host)
        return ip.startswith("192.") or ip.startswith("10.")
    except Exception:
        return True

def detect_sensitive_form(html):
    sensitive = ["password","credit card","ssn","cccd","stk","sothe","ccv","cvv","cmnd"]
    soup = BeautifulSoup(html, "html.parser")
    for form in soup.find_all("form"):
        for tag in form.find_all(["input","textarea"]):
            for attr_value in tag.attrs.values():
                if isinstance(attr_value, str) and any(k in attr_value.lower() for k in sensitive):
                    return True
    return False

def detect_redirect(html):
    low = html.lower()
    return 'http-equiv="refresh"' in low or "window.location" in low

def dynamic_content(html):
    low = html.lower()
    return "<script>" in low and "innerhtml" in low

def has_valid_https_cert(url: str) -> bool:
    if not url.startswith("https://"): return False
    try:
        HTTP.get(url, timeout=5)
        return True
    except requests.exceptions.RequestException:
        return False

@app.route("/analyze", methods=["POST"])
def analyze():
    data = request.get_json(silent=True) or {}
    url = data.get("url")
    if not url:
        return jsonify({"error": "url is required"}), 400

    domain_age = int(data.get("domain_age", 0) or 0)
    is_vietnam = int(data.get("is_vietnam", 0) or 0)

    parsed = urlparse(url)
    host = parsed.hostname or ""
    ext = tldextract.extract(url)
    full_domain = f"{ext.domain}.{ext.suffix}"

    with ThreadPoolExecutor(max_workers=2) as pool:
        html, load_time = pool.submit(fetch_html, url).result()
        _ = pool.submit(fast_resolve, host).result()  # có thể dùng sau nếu cần

    score, deductions = 100, []

    if suspicious_ip(host):
        score -= 10; deductions.append({"reason": "Địa chỉ IP đáng ngờ", "score": -10, "type": "negative"})
    if len(full_domain) > 20:
        score -= 5;  deductions.append({"reason": "Tên miền quá dài", "score": -5, "type": "negative"})
    if re.search(r"[^a-zA-Z0-9.]", full_domain):
        score -= 20; deductions.append({"reason": "Tên miền chứa ký tự đặc biệt hoặc giả mạo", "score": -20, "type": "negative"})
    if not has_valid_https_cert(url):
        score -= 15; deductions.append({"reason": "Chứng chỉ HTTPS không hợp lệ hoặc không tồn tại", "score": -15, "type": "negative"})

    if load_time > 2:
        score -= 5;  deductions.append({"reason": "Tốc độ tải trang chậm", "score": -5, "type": "negative"})
    if detect_sensitive_form(html):
        score -= 20; deductions.append({"reason": "Có form yêu cầu thông tin nhạy cảm", "score": -20, "type": "negative"})
    if detect_redirect(html):
        score -= 10; deductions.append({"reason": "Chuyển hướng liên tục", "score": -10, "type": "negative"})
    if dynamic_content(html):
        score -= 10; deductions.append({"reason": "Nội dung thay đổi sau khi tải trang", "score": -10, "type": "negative"})

    for bad_tld in criteria_data["BAD_COUNTRY_TLDS"]:
        if full_domain.endswith(bad_tld):
            score -= CRITERIA_WEIGHTS["BAD_COUNTRY_TLDS"]
            deductions.append({"reason": f"Đuôi tên miền đáng ngờ: {bad_tld}", "score": -CRITERIA_WEIGHTS["BAD_COUNTRY_TLDS"], "type": "negative"})
            break

    bl_deduction, bl_matches = apply_blacklist_keywords(html, criteria_data)
    score -= bl_deduction
    label_map = {
        "ADULT_KEYWORDS":"Nội dung nhạy cảm",
        "MALICIOUS_ADS":"Quảng cáo khó chịu",
        "FAKE_ALERTS":"Cảnh báo giả mạo",
        "FAKE_MEDICAL_KEYWORDS":"Thông tin y tế giả",
        "HATE_KEYWORDS":"Ngôn từ kích động",
        "SCAM_KEYWORDS":"Dấu hiệu lừa đảo",
    }
    for m in bl_matches:
        label = label_map.get(m["category"], m["category"])
        deductions.append({"reason": f"{label}: '{m['keyword']}'", "score": -m["deduct"], "type": "negative"})

    if is_vietnam == 2:
        score -= 30; deductions.append({"reason": "Máy chủ ở nước ngoài", "score": -30, "type": "negative"})
    elif is_vietnam == 1:
        score += 30; deductions.append({"reason": "Máy chủ ở Việt Nam", "score": 30, "type": "positive"})

    if   domain_age < 30:  score -= 30; deductions.append({"reason": "Tên miền mới < 1 tháng", "score": -30, "type": "negative"})
    elif domain_age < 90:  score -= 20; deductions.append({"reason": "Tên miền mới < 3 tháng", "score": -20, "type": "negative"})
    elif domain_age < 365: score -= 10; deductions.append({"reason": "Tên miền mới < 1 năm", "score": -10, "type": "negative"})
    else:                  score += 5;  deductions.append({"reason": "Tên miền đã hoạt động > 1 năm", "score": 5, "type": "positive"})

    for fn, label in [(has_privacy_policy,"Có chính sách bảo mật"),
                      (has_contact_info,"Có thông tin liên hệ"),
                      (has_meta_info,"Có thông tin mô tả")]:
        delta = fn(html)
        if delta:
            score += delta; deductions.append({"reason": label, "score": delta, "type": "positive"})

    features = [
        len(url),
        int(url.startswith("https://")),
        int(suspicious_ip(full_domain)),
        domain_age,
        int(detect_sensitive_form(html)),
        int(detect_redirect(html)),
        int(dynamic_content(html)),
        int("privacy policy" in html.lower()),
        int("contact" in html.lower()),
        domain_age,
        is_vietnam,
    ]

    if ml_model:
        try:
            df_feat = pd.DataFrame([features], columns=[
                "len_url","is_https","is_private_ip","domain_age",
                "is_sensitive_form","has_redirect","has_script","has_privacy",
                "has_contact","age_of_domain","is_vietnam",
            ])
            pred = float(ml_model.predict(df_feat)[0])
            delta_ai = round(pred - score)
            deductions.append({"reason": "Dự đoán AI (gợi ý)", "score": delta_ai, "type": "positive" if delta_ai > 0 else "negative"})
            score = (score + pred) / 2
        except Exception as e:
            print("Lỗi ML", e)

    if score > 80 or score < 70:
        try:
            import csv, os.path
            file_exists = os.path.exists("training_log.csv")
            with open("training_log.csv", "a", newline="", encoding="utf-8") as f:
                w = csv.writer(f)
                if not file_exists:
                    w.writerow(["url","score","len_url","is_https","is_private_ip","domain_age",
                                "is_sensitive_form","has_redirect","has_script","has_privacy",
                                "has_contact","age_of_domain","is_vietnam"])
                w.writerow([url, int(score)] + features)
        except Exception:
            pass

    return jsonify({"score": max(score, 0), "deductions": deductions})

@app.route("/train-model", methods=["POST"])
def train_model():
    try:
        df = pd.read_csv("training_log.csv")
        df.replace({'True': 1, 'False': 0, True: 1, False: 0}, inplace=True)
        cols = ["len_url","is_https","is_private_ip","domain_age","is_sensitive_form","has_redirect",
                "has_script","has_privacy","has_contact","age_of_domain","is_vietnam"]
        for c in cols: df[c] = pd.to_numeric(df[c], errors="coerce")
        df.dropna(subset=cols + ["score"], inplace=True)
        X, y = df[cols], df["score"]
        model = RandomForestRegressor(n_estimators=100, random_state=42).fit(X, y)
        with open(ML_MODEL_PATH, "wb") as f: pickle.dump(model, f)
        return jsonify({"message": "Train model thành công."})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/health", methods=["GET"])
def health():
    return jsonify({"status": "ok"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000, debug=False)