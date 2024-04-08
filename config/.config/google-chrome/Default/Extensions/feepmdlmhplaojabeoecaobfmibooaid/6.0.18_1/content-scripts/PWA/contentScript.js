




chrome.runtime.onMessage.addListener(
    function (request, sender, sendResponse) {
        if (sender.id == 'feepmdlmhplaojabeoecaobfmibooaid') {
            console.log('newmess');
            window.postMessage(request, window.location.origin);

        }

    }
);

window.addEventListener("message", (payload) => {
    if (payload.data != null) {
        if (payload.data.sender != null) {
            if (payload.data.sender == "DatadeskTrigger") {
                chrome.runtime.sendMessage(payload.data, function (response) {

                });
            } else if (payload.data.sender == "LOAD_PDF_EXTENSION" &&
                payload.origin == "https://orbit.texthelp.com" ) {
                chrome.runtime.sendMessage({
                    type: "getFile", options: {
                        url: payload.data.url
                    }
                });
            }

        }
    }
});



chrome.runtime.onMessage.addListener(async (request, sender) => {
    if (request.type == "LOADED_PDF_FILE" && sender.id == 'feepmdlmhplaojabeoecaobfmibooaid') {
        const response = await fetch(request.url);
        const blob = await response.blob();


        window.postMessage({ type: "PDF_FILE_LOAD", text: blob }, "*")
    }

});


