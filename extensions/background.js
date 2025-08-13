const excludedDomains = [
    "google.com",
    "youtube.com",
    "facebook.com",
    "gmail.com",
    "googleusercontent.com",
    "127.0.0.1",
    "localhost",
];

// Tách hàm lấy hostname
function extractHostname(url) {
    try {
        const urlObj = new URL(url);
        return urlObj.hostname.replace(/^www\./, ""); // bỏ www.
    } catch (error) {
        return "";
    }
}

// Tách hàm fetch API check-url
function fetchCheckUrl(url, callback) {
    console.log("==> Gửi fetch API kiểm tra:", url);

    fetch("http://127.0.0.1:8000/api/check-url", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ url }),
    })
        .then((res) => res.json())
        .then((data) => {
            console.log("==> Kết quả API:", data);
            chrome.storage.local.set(
                { checkResult: data, checkedUrl: url },
                () => {
                    callback({ checkResult: data, checkedUrl: url });
                }
            );
        })
        .catch((err) => {
            console.error("==> Lỗi khi fetch API:", err);
            callback(null);
        });
}

// Theo dõi khi tab được cập nhật (mở trang mới)
chrome.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
    if (
        changeInfo.status === "complete" &&
        tab.url &&
        !tab.url.includes("blocked.html") &&
        tab.url.startsWith("http") && // Chỉ http hoặc https
        !tab.url.startsWith("chrome://") && // Bỏ các trang của Chrome
        !tab.url.startsWith("about:") &&
        !tab.url.startsWith("file://")
    ) {
        const hostname = extractHostname(tab.url);

        if (excludedDomains.some((domain) => hostname.endsWith(domain))) {
            console.log("==> Bỏ qua domain:", hostname);
            return; // Không gọi API nếu domain excluded
        }

        chrome.storage.local.get(["skipNextUrl"], (result) => {
            if (result.skipNextUrl === tab.url) {
                chrome.storage.local.remove("skipNextUrl");
                console.log("==> Skip URL sau khi tiếp tục:", tab.url);
                return;
            }

            // Gọi API kiểm tra URL
            fetchCheckUrl(tab.url, (data) => {
                if (!data) return; // lỗi rồi thì bỏ qua

                if (data.checkResult.action === "block") {
                    console.log("==> Phát hiện website cần block:", tab.url);
                    chrome.storage.local.set(
                        { blockedOriginalUrl: tab.url },
                        () => {
                            chrome.tabs.update(tabId, {
                                url: chrome.runtime.getURL("blocked.html"),
                            });
                        }
                    );
                } else if (data.checkResult.action === "warn") {
                    console.log("==> Cảnh báo website:", tab.url);
                    chrome.notifications.create({
                        type: "basic",
                        iconUrl: "icons/icon48.png",
                        title: "Cảnh báo an toàn!",
                        message:
                            "Website này có thể không an toàn. Hãy cẩn trọng khi truy cập.",
                    });
                }
            });
        });
    }
});

// Lắng nghe tin nhắn từ popup
chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
    if (request.action === "getCheckResult") {
        chrome.storage.local.get(["checkResult", "checkedUrl"], (result) => {
            sendResponse({
                checkResult: result.checkResult,
                checkedUrl: result.checkedUrl,
            });
        });
        return true;
    } else if (request.action === "refreshCheck") {
        console.log("==> Nhận yêu cầu refreshCheck từ popup");

        chrome.tabs.query({ active: true, currentWindow: true }, (tabs) => {
            const currentTab = tabs[0];
            let url = "";

            if (
                currentTab &&
                currentTab.url &&
                currentTab.url.startsWith("http")
            ) {
                url = currentTab.url;
                console.log("==> URL lấy từ tab active:", url);
            } else {
                console.warn(
                    "==> Tab hiện tại không có URL hợp lệ, fallback dùng storage"
                );

                // Fallback lấy URL đã lưu
                chrome.storage.local.get(["checkedUrl"], (storage) => {
                    url = storage.checkedUrl || "";

                    if (!url.startsWith("http")) {
                        console.error(
                            "==> Không tìm được URL hợp lệ để refresh"
                        );
                        sendResponse(null);
                        return;
                    }
                    // Kiểm tra nếu URL nằm trong danh sách excludedDomains
                    const hostname = extractHostname(url);
                    if (excludedDomains.includes(hostname)) {
                        console.log(
                            "==> RefreshCheck: Bỏ qua domain:",
                            hostname
                        );
                        sendResponse(null);
                        return;
                    }
                    console.log("==> URL lấy từ storage:", url);
                    fetchCheckUrl(url, sendResponse);
                });

                return true; // Giữ callback mở cho fetch
            }
            // Kiểm tra nếu URL nằm trong danh sách excludedDomains
            const hostname = extractHostname(url);
            if (excludedDomains.includes(hostname)) {
                console.log("==> RefreshCheck: Bỏ qua domain:", hostname);
                sendResponse(null);
                return;
            }

            // Nếu URL từ tab active hợp lệ thì fetch luôn
            fetchCheckUrl(url, sendResponse);
        });

        return true; // Luôn return true để giữ callback
    } else if (request.action === "continueToBlockedSite") {
        chrome.storage.local.get("blockedOriginalUrl", (result) => {
            if (result.blockedOriginalUrl && sender.tab?.id) {
                chrome.storage.local.set(
                    { skipNextUrl: result.blockedOriginalUrl },
                    () => {
                        chrome.tabs.update(sender.tab.id, {
                            url: result.blockedOriginalUrl,
                        });
                    }
                );
            }
        });
        return true;
    }
});
