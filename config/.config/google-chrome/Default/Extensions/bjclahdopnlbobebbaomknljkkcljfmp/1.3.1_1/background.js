function getPulseHash() {
    var xhr = new XMLHttpRequest();
    var new_hash;
    xhr.open("GET", "https://pulse.zerodha.com/tick.php", true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState == 4) {
            new_hash = xhr.responseText;
            if(new_hash != localStorage.pulse_hash) {
                chrome.browserAction.setBadgeBackgroundColor({ color: [192, 57, 43,255] });
                chrome.browserAction.setBadgeText({text: "NEW"});
                localStorage.pulse_hash = new_hash;
                localStorage.new_flag = "true";
            }
        }
    };
    xhr.send();
}

if (localStorage.pulse_hash === undefined) {
    getPulseHash();
}

window.setInterval(function() {
    if(localStorage.new_flag === "false") {
        getPulseHash();
    }
}, 120000);
