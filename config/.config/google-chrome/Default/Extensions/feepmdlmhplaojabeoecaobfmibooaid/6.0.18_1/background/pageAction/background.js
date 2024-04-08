/*
Copyright 2014 Mozilla Foundation

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
/* globals chrome */

'use strict';

(function PageActionClosure() {
  /**
   * @param {number} tabId - ID of tab where the page action will be shown.
   * @param {string} url - URL to be displayed in page action.
   */
  function showPageAction(tabId, displayUrl) {
    // rewriteUrlClosure in viewer.js ensures that the URL looks like
    // chrome-extension://[extensionid]/http://example.com/file.pdf
    var url = /^chrome-extension:\/\/[a-p]{32}\/([^#]+)/.exec(displayUrl);
    if (url) {
      url = url[1];
      chrome.pageAction.setPopup({
        tabId: tabId,
        popup: '/pageAction/popup.html?file=' + encodeURIComponent(url)
      });
      chrome.pageAction.show(tabId);
    } else {
      console.log('Unable to get PDF url from ' + displayUrl);
    }
  }



  chrome.runtime.onInstalled.addListener(function (details) {


    if (details.reason === chrome.runtime.OnInstalledReason.INSTALL) {

      if (chrome.runtime.id == 'feepmdlmhplaojabeoecaobfmibooaid') {
        chrome.windows.getAll({
          populate: true
        }, function (windows) {
          windows.forEach(function (window) {
            window.tabs.forEach(function (tab) {
              //collect all of the urls here, I will just log them instead

              if (tab.url.indexOf("chrome.google.com/webstore/detail/texthelp-pdf-reader/feepmdlmhplaojabeoecaobfmibooaid") > 0) {
                chrome.tabs.create({
                  url: "https://orbit.texthelp.com/?utm_source=ChromeWebstore&utm_medium=WEB&utm_campaign=InstallExtension"
                });
                chrome.runtime.onInstalled.removeListener(listener);
              }
            });
          });
        });
      }


      
    }
  });

})();



//example of using a message handler from the inject scripts
chrome.extension.onMessage.addListener(
  function (request, sender, sendResponse) {

    if (request.func == "getoauth") {
      var oauthHandler = localStorage.getItem('thAuth');

      sendResponse({
        ResponseoAuth: oauthHandler
      });
    }
    if (request.func == "storeOauth") {

      var oauthHandler = localStorage.setItem('thAuth', request.payload);


    }


    if (request === 'showPageAction' && sender.tab) {
      try {
        showPageAction(sender.tab.id, sender.tab.url);
      } catch (e) {

      }

    }

    if (request.command == "startScreenShotReader") {
      chrome.tabs.sendRequest(sender.tab.id, request, null);

    }
    if (request.from == 'mousedown') {

      //storing position
      var coords = request.point;

      //Get ScreenShot
      //chrome.tabs.captureVisibleTab(null, { format: "png", quality: 100 }, function (dataUrl) {

      //Crop the image 
      cropData(request.ImageURL, coords, doOCR);

      // });

      //chrome.tabs.getSelected(null, function (tab) {
      //     chrome.tabs.sendRequest(tab.id, request, function (response) {

      //        });
      //    });

      //sendResponse();
    }



  });

function cropData(str, coords, callback) {

  var _self = this;
  var cropCommand = '{"command":"crop","image":"' + str + '","coords":' + JSON.stringify(coords) + '}';

  chrome.tabs.getSelected(null, function (tab) {
    chrome.tabs.sendRequest(tab.id, JSON.parse(cropCommand), function (croppedDataURL) {

      //console.log(croppedDataURL);

      setTimeout(function () {
        doOCR(croppedDataURL)
      }, 2000);

    });
  });
}

function doOCR(croppedImage) {

  //console.log(croppedImage)
  chrome.tabs.getSelected(null, function (tab) {
    var OCRSettings = {};
    OCRSettings.command = "externalOCR";
    OCRSettings.image = croppedImage;
    OCRSettings.tabId = tab.id;
    //OCRSettings.voice = "Vocalizer Expressive Karen Premium High 22kHz";
    //OCRSettings.speed = "";
    var extensionId = '';

    switch (chrome.runtime.id) {
      case "feepmdlmhplaojabeoecaobfmibooaid":

        extensionId = 'enfolipbjmnmleonhhebhalojdpcpdoo';
        break;
      case "lcdeclfndahfibcjcckkbhhfgcecbaea":

        extensionId = 'aaccmfnikmcnnbfnlomohilcpglfnlch';
        break
    }
    chrome.runtime.sendMessage(extensionId, OCRSettings);

  });

}


// listen to messages from external extensions
// In this case it will be Read&Write for Google Chrome
// passing a do screen read command.
chrome.runtime.onMessageExternal.addListener(
  function (request, sender, sendResponse) {

    console.debug(request);

    console.debug("External Message");

    switch (request.command) {
      case "onocr":
        //console.log("External OCR");

        chrome.tabs.getSelected(null, function (tab) {
          chrome.tabs.sendRequest(tab.id, request, function () {

          });
        });
        break;

    }


    sendResponse("bar");


    chrome.tabs.getSelected(null, function (tab) {
      chrome.tabs.sendRequest(tab.id, request, function (response) {

      });
    });
  });