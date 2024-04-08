/*
Copyright 2012 Mozilla Foundation

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
/* globals chrome, Features, saveReferer */

'use strict';
var fileAccess = false;
var storageArea = chrome.storage.sync || chrome.storage.local;
var OpenWebPagePDF = false;
var requestId = 0;


var VIEWER_URL = 'https://orbit.texthelp.com';

function getViewerURL(pdf_url) {
  return VIEWER_URL + '?file=' + encodeURIComponent(pdf_url);
}
chrome.browserAction.onClicked.addListener(function (tab) {

  var newURL = "https://orbit.texthelp.com/?utm_source=ExtensionClick";
  chrome.tabs.create({ url: newURL });

});


/**
 * @param {Object} details First argument of the webRequest.onHeadersReceived
 *                         event. The property "url" is read.
 * @return {boolean} True if the PDF file should be downloaded.
 */
function isPdfDownloadable(details) {
  if (details.url.indexOf('pdfjs.action=download') >= 0) {
    return true;
  }
  // Display the PDF viewer regardless of the Content-Disposition header if the
  // file is displayed in the main frame, since most often users want to view
  // a PDF, and servers are often misconfigured.
  // If the query string contains "=download", do not unconditionally force the
  // viewer to open the PDF, but first check whether the Content-Disposition
  // header specifies an attachment. This allows sites like Google Drive to
  // operate correctly (#6106).
  if (details.type === 'main_frame' &&
    details.url.indexOf('=download') === -1) {
    return false;
  }
  var cdHeader = (details.responseHeaders &&
    getHeaderFromHeaders(details.responseHeaders, 'content-disposition'));
  return (cdHeader && /^attachment/i.test(cdHeader.value));
}

/**
 * Get the header from the list of headers for a given name.
 * @param {Array} headers responseHeaders of webRequest.onHeadersReceived
 * @return {undefined|{name: string, value: string}} The header, if found.
 */
function getHeaderFromHeaders(headers, headerName) {
  for (var i = 0; i < headers.length; ++i) {
    var header = headers[i];
    if (header.name.toLowerCase() === headerName) {
      return header;
    }
  }
}

/**
 * Check if the request is a PDF file.
 * @param {Object} details First argument of the webRequest.onHeadersReceived
 *                         event. The properties "responseHeaders" and "url"
 *                         are read.
 * @return {boolean} True if the resource is a PDF file.
 */
function isPdfFile(details) {
  var header = getHeaderFromHeaders(details.responseHeaders, 'content-type');
  if (header) {
    var headerValue = header.value.toLowerCase().split(';', 1)[0].trim();
    if (headerValue === 'application/pdf') {
      return true;
    }
    if (headerValue === 'application/octet-stream') {
      if (details.url.toLowerCase().indexOf('.pdf') > 0) {
        return true;
      }
      var cdHeader =
        getHeaderFromHeaders(details.responseHeaders, 'content-disposition');
      if (cdHeader && /\.pdf(["']|$)/i.test(cdHeader.value)) {
        return true;
      }
    }
  }
  return false;
}

/**
 * Takes a set of headers, and set "Content-Disposition: attachment".
 * @param {Object} details First argument of the webRequest.onHeadersReceived
 *                         event. The property "responseHeaders" is read and
 *                         modified if needed.
 * @return {Object|undefined} The return value for the onHeadersReceived event.
 *                            Object with key "responseHeaders" if the headers
 *                            have been modified, undefined otherwise.
 */
function getHeadersWithContentDispositionAttachment(details) {
  var headers = details.responseHeaders;
  var cdHeader = getHeaderFromHeaders(headers, 'content-disposition');
  if (!cdHeader) {
    cdHeader = { name: 'Content-Disposition' };
    headers.push(cdHeader);
  }
  if (!/^attachment/i.test(cdHeader.value)) {
    cdHeader.value = 'attachment' + cdHeader.value.replace(/^[^;]+/i, '');
    return { responseHeaders: headers };
  }
}

function isOrbitDoc(url) {
  if (url.indexOf('schoologyurl') == -1) {    
      if (url.indexOf("https://orbit.texthelp.com") != -1) {
        if (chrome.runtime.id == 'lcdeclfndahfibcjcckkbhhfgcecbaea') {
          //  return false;

        }

        let uri = new URL(url);
        let file = uri.searchParams.get("file");

        //check we are not getting d2l querystring param
        let ref = uri.searchParams.get("ref");
        if (ref) {
          if (ref == "d2l") {
            return false;
          }
        }
        let extension = uri.searchParams.get("waitForExtension");
        if (extension != null || file == null) {
          return false;
        }
        let fileUri = new URL(file);
        if (fileUri.origin.indexOf("https://drive.google.com") == 0) {
          return false;
        } else if (fileUri.origin.indexOf("sharepoint.com") != -1) {
          return false;
        }
  
        return true
      }
  }
  return false;
}

chrome.webRequest.onHeadersReceived.addListener(
  function (details) {
    if (details.method !== 'GET') {
      // Don't intercept POST requests until http://crbug.com/104058 is fixed.
      return;
    }

    //If the url is blank ignore. this can be a call from print process
    if (details.url == "about:blank") {
      //alert('stop');
    }

    

    if (isOrbitDoc(details.url)){

    if (typeof details.initiator =="undefined" ||
      details.initiator.indexOf("classroom.google.com") == -1) {
      let url = details.url + "&waitForExtension=true"
      chrome.tabs.update(details.tabId, {
        url: url
      });
    }
  }

    // do not handle print action
    if (details.url.indexOf('print=true') !== -1) {
      return;
    }
    if (details.url.indexOf("texthelp=true") != -1 || requestId == details.requestId) {
      requestId = details.requestId;
      if (!isPdfFile(details)) {
        return;
      } else {
        let url = getViewerURL(details.url)
        chrome.tabs.update(details.tabId, {
          url: url
        });
        return { cancel: true };
      }
    } else if (!OpenWebPagePDF || !isPdfFile(details)) {
      return;
    }
    if (isPdfDownloadable(details)) {
      // Force download by ensuring that Content-Disposition: attachment is set
      return getHeadersWithContentDispositionAttachment(details);
    }




    if (!OpenWebPagePDF) {
      try {
        if (details.url.indexOf("chrome-extension://e") == -1) {
          return;
        }
      }
      catch (e) {

      }

    }


    // do not handle print action
    if (details.url.indexOf('print=true') !== -1) {
      return;
    }

    // do not handle google calender print action
    if (details.url.indexOf('calendar.google.com/calendar/printevent') !== -1) {
      return;
    }



    // do not handle google docs print action
    if (details.url.indexOf('docs.google.com/') !== -1) {
      return;
    }


    var viewerUrl = getViewerURL(details.url);

    // Aww.. redirectUrl is not yet supported, so we have to use a different
    // method as fallback (Chromium <35).



    if (details.frameId === 0) {
      // Main frame. Just replace the tab and be done!
      chrome.tabs.update(details.tabId, {
        url: viewerUrl
      });
      return { cancel: true };
    } else {
      console.warn('Child frames are not supported in ancient Chrome builds!');
    }
  },
  {
    urls: [
      '<all_urls>'
    ],
    types: ['main_frame', 'sub_frame']
  },
  ['blocking', 'responseHeaders']);

chrome.webRequest.onBeforeRequest.addListener(
  function onBeforeRequestForFTP(details) {
    if (!Features.extensionSupportsFTP) {
      chrome.webRequest.onBeforeRequest.removeListener(onBeforeRequestForFTP);
      return;
    }
    if (isPdfDownloadable(details)) {
      return;
    }
    var viewerUrl = getViewerURL(details.url);

    return { redirectUrl: viewerUrl };
  },
  {
    urls: [
      'ftp://*/*.pdf',
      'ftp://*/*.PDF'
    ],
    types: ['main_frame', 'sub_frame']
  },
  ['blocking']);

chrome.webRequest.onBeforeRequest.addListener(
  function (details) {
    if (isPdfDownloadable(details)) {
      return;
    }

    // NOTE: The manifest file has declared an empty content script
    // at file://*/* to make sure that the viewer can load the PDF file
    // through XMLHttpRequest. Necessary to deal with http://crbug.com/302548
    var viewerUrl = getViewerURL(details.url);
    if (fileAccess) {
      return { redirectUrl: viewerUrl };
    }
  },
  {
    urls: [
      'file://*/*.pdf',
      'file://*/*.PDF'
    ],
    types: ['main_frame', 'sub_frame']
  },
  ['blocking']);

chrome.extension.isAllowedFileSchemeAccess(function (isAllowedAccess) {
  fileAccess = isAllowedAccess;
  if (isAllowedAccess) {
    return;
  }
  // If the user has not granted access to file:-URLs, then the webRequest API
  // will not catch the request. It is still visible through the webNavigation
  // API though, and we can replace the tab with the viewer.
  // The viewer will detect that it has no access to file:-URLs, and prompt the
  // user to activate file permissions.
  chrome.webNavigation.onBeforeNavigate.addListener(function (details) {
    if (details.frameId === 0 && !isPdfDownloadable(details)) {
      if (fileAccess) {
        chrome.tabs.update(details.tabId, {
          url: getViewerURL(details.url)
        });
      }
    }
  }, {
    url: [{
      urlPrefix: 'file://',
      pathSuffix: '.pdf'
    }, {
      urlPrefix: 'file://',
      pathSuffix: '.PDF'
    }]
  });
});

chrome.runtime.onMessage.addListener(function (message, sender, sendResponse) {

  if (message && message.action === 'getParentOrigin') {
    // getParentOrigin is used to determine whether it is safe to embed a
    // sensitive (local) file in a frame.
    if (!sender.tab) {
      sendResponse('');
      return;
    }
    // TODO: This should be the URL of the parent frame, not the tab. But
    // chrome-extension:-URLs are not visible in the webNavigation API
    // (https://crbug.com/326768), so the next best thing is using the tab's URL
    // for making security decisions.
    var parentUrl = sender.tab.url;
    if (!parentUrl) {
      sendResponse('');
      return;
    }
    if (parentUrl.lastIndexOf('file:', 0) === 0) {
      sendResponse('file://');
      return;
    }
    // The regexp should always match for valid URLs, but in case it doesn't,
    // just give the full URL (e.g. data URLs).
    var origin = /^[^:]+:\/\/[^/]+/.exec(parentUrl);
    sendResponse(origin ? origin[1] : parentUrl);
    return true;
  }
  if (message && message.action === 'isAllowedFileSchemeAccess') {
    chrome.extension.isAllowedFileSchemeAccess(sendResponse);
    return true;
  }
  if (message && message.action === 'openExtensionsPageForFileAccess') {
    var url = 'chrome://extensions/?id=' + chrome.runtime.id;
    if (message.data.newTab) {
      chrome.tabs.create({
        windowId: sender.tab.windowId,
        index: sender.tab.index + 1,
        url: url,
        openerTabId: sender.tab.id
      });
    } else {
      chrome.tabs.update(sender.tab.id, {
        url: url
      });
    }
  }
});

chrome.runtime.onMessageExternal.addListener(
  function (request, sender, sendResponse) {
    if (request) {
      if (request.message) {
        if (request.message == "showOptions") {
          var extId = chrome.runtime.id;

          var optionsUrl = "chrome://extensions/?options=" + "feepmdlmhplaojabeoecaobfmibooaid";
          if (extId == "lcdeclfndahfibcjcckkbhhfgcecbaea") {
            optionsUrl = "edge://extensions/?options=" + "lcdeclfndahfibcjcckkbhhfgcecbaea";
          }




          chrome.tabs.create({ url: optionsUrl });
        }

        if (request.message == "version") {
          sendResponse({ version: 1.0 });
        }
        if (request.message == "EnableClassroom") {
          chrome.storage.sync.set({ 'EnableClassroom': true });
          sendResponse({ Update: 1.0 });
        }
        if (request.message == "DisableClassroom") {
          chrome.storage.sync.set({ 'EnableClassroom': false });
          sendResponse({ Update: 1.0 });
        }

        if (request.message == "EnabledefaultOpenWebPagePDF") {
          chrome.storage.sync.set({ 'defaultOpenWebPagePDF': true });
          sendResponse({ Update: 1.0 });
        }

        if (request.message == "DisabledefaultOpenWebPagePDF") {
          chrome.storage.sync.set({ 'defaultOpenWebPagePDF': false });
          sendResponse({ Update: 1.0 });
        }
        //defaultOpenWebPagePDF
      }
    }
    return true;
  });

var redirectUrl = "";
chrome.webRequest.onBeforeRequest.addListener(
  function (details) {
    redirectUrl = details.url;
    var asyncCancel = new Promise((resolve, reject) => {
      /*
            storageArea.get({ defaultOpenWebPagePDF: false }, function (readPrefs) {
              OpenWebPagePDF = readPrefs.defaultOpenWebPagePDF;
              resolve({ redirectUrl });
            }); */

      chrome.storage.managed.get(null, function (results) {
        if (Object.keys(results).length == 0) {
          console.log('using standard Extension options');
          // Managed Settings Failed go to standard
          var storageArea = chrome.storage.sync || chrome.storage.local;

          storageArea.get({ defaultOpenWebPagePDF: false }, function (readPrefs) {

            if (readPrefs != undefined) {

              OpenWebPagePDF = readPrefs.defaultOpenWebPagePDF;
              resolve({ redirectUrl });

            }
          });
        }
        else {

          console.log('using Managed Extension options');
          if (results != undefined) {
            classroomIntegration = results.defaultOpenWebPagePDF;
            resolve({ redirectUrl });
          }
        }


      });

    });

    return asyncCancel;


  },
  { urls: ["<all_urls>"] },
  ["blocking"]);

chrome.runtime.onMessage.addListener(async (request, sender) => {
  if (request.type == "getFile") {
    if (request.options.url.indexOf("file://")!=-1){
      var oReq = new XMLHttpRequest();
      
      oReq.onload = function(e) {
        var blob = oReq.response; // not responseText
        let url = URL.createObjectURL(blob)
        chrome.tabs.sendMessage(sender.tab.id, { type: "LOADED_PDF_FILE", url: url });
      }
      oReq.open("GET", request.options.url);
      oReq.responseType = "blob";
      oReq.send();
      return
    }else {
      let response = await fetch(request.options.url);
      let blob = await response.blob()
      let url = URL.createObjectURL(blob)

      chrome.tabs.sendMessage(sender.tab.id, { type: "LOADED_PDF_FILE", url: url });
    }
  }
});