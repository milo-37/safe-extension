document.addEventListener("DOMContentLoaded", () => {
    const continueBtn = document.getElementById("continueBtn");

    continueBtn.addEventListener("click", () => {
        console.log("0k");

        chrome.runtime.sendMessage({ action: "continueToBlockedSite" });
    });
});
