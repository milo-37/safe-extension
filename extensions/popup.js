function renderData(data) {
    const iconTitle = document.getElementById("icon-title");
    const statusElement = document.getElementById("status");
    const scoreElement = document.getElementById("score");
    const criteriaElement = document.getElementById("criteria");

    if (!data || !data.checkResult) {
        statusElement.textContent = "Không có dữ liệu.";
        return;
    }

    const result = data.checkResult;

    scoreElement.textContent = `Điểm: ${parseFloat(result.score.toFixed(1))}/100`;

    if (result.action === "block") {
        statusElement.className = "status-box fraud";
        statusElement.innerHTML = `<div class="status-icon">❌</div><div class="status-text"><div class="status-title">NGUY HIỂM</div></div>`;
        iconTitle.textContent = "❌ BLOCKED";
    } else if (result.action === "warn") {
        statusElement.className = "status-box warn";
        statusElement.innerHTML = `<div class="status-icon">⚠️</div><div class="status-text"><div class="status-title">CẢNH BÁO</div></div>`;
        iconTitle.textContent = "⚠️ WARNING";
    } else {
        statusElement.className = "status-box safe";
        statusElement.innerHTML = `<div class="status-icon">🛡️</div><div class="status-text"><div class="status-title">AN TOÀN</div></div>`;
        iconTitle.textContent = "🛡️ SAFE";
    }

    criteriaElement.innerHTML = "";
    if (result.deductions && result.deductions.length > 0) {
        result.deductions.forEach(criterion => {
            let li = document.createElement("li");
            if (typeof criterion === "object" && criterion.reason) {
                if(criterion.reason=='Dự đoán AI (gợi ý)') li.textContent = `${criterion.reason} (${criterion.score > 0 ? "+" : ""}${criterion.score})`;//(${criterion.score > 0 ? "+" : ""}${criterion.score})
                else li.textContent = `${criterion.reason}`;
                li.className = criterion.type === "positive" ? "score-positive" : "score-negative";
            }
            criteriaElement.appendChild(li);
        });
    } else {
        let li = document.createElement("li");
        li.textContent = "Không có tiêu chí lừa đảo nào được phát hiện.";
        criteriaElement.appendChild(li);
    }
}

document.addEventListener("DOMContentLoaded", function () {
    chrome.tabs.query({ active: true, currentWindow: true }, function (tabs) {
        const currentUrl = tabs[0]?.url || "";

        chrome.storage.local.get(["checkResult", "checkedUrl", "blockedOriginalUrl"], (data) => {
            if (currentUrl.includes("blocked.html")) {
                // Đang ở blocked.html => Hiển thị dữ liệu checkResult hiện tại
                renderData(data);
            } else if (data.checkedUrl === currentUrl) {
                // URL trùng với checkedUrl => Hiển thị luôn
                renderData(data);
            } else {
                // Khác => gọi API mới
                document.getElementById("score").textContent = "Đang kiểm tra...";
                chrome.runtime.sendMessage({ action: "refreshCheck" }, function (newData) {
                    renderData(newData);
                });
            }
        });
    });

    document.getElementById("refreshBtn").addEventListener("click", function () {
        document.getElementById("score").textContent = "Đang tải lại...";
        chrome.runtime.sendMessage({ action: "refreshCheck" }, function (data) {
            renderData(data);
        });
    });

    document.getElementById("toggleBtn").addEventListener("click", function () {
        const criteriaList = document.getElementById("criteria");
        if (criteriaList.style.display === "block") {
            criteriaList.style.display = "none";
            this.textContent = "Xem chi tiết +";
        } else {
            criteriaList.style.display = "block";
            this.textContent = "Ẩn chi tiết -";
        }
    });
});
