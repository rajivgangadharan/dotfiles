

var storageArea = chrome.storage.sync || chrome.storage.local;
var extensionAddress="";
var classroomOpenWith=true;
storageArea.get({classroomOpenWith: true}, function (readPrefs) {
    classroomOpenWith = readPrefs.classroomOpenWith;
});


var observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
        if (!mutation.addedNodes) {
            return;
        }
        for (var i = 0; i < mutation.addedNodes.length; i++) {
            var node = mutation.addedNodes[i];
            if (node.attributes && node.attributes['aria-label'] && node.attributes['aria-label'].value === 'Showing viewer.') {
                openWith();
                observer.disconnect();
            }
        }
    });
});


if(document.location.pathname.match(/^\/course\/([0-9]+)\/materials/) )
{

}

function injectScript(e, t) {
    var n = document.getElementsByTagName(t)[0],
        o = document.createElement("script");
    o.setAttribute("type", "text/javascript"), o.setAttribute("src", e), n.appendChild(o)
}

function injectStyle(e, t) {
    var n = document.getElementsByTagName(t)[0],
        o = document.createElement("link");
    o.setAttribute("rel", "stylesheet"), o.setAttribute("href", e), n.appendChild(o)
}



if (document.querySelector('link[href="/sites/all/themes/schoology_theme/print.css"]') || document.querySelector('link[href="/sites/all/themes/schoology_theme/favicon.ico"]') || window.location.origin.match(/^https?:\/\/\S+.schoology.com$/)) {
    var oauthProvider = '';
  
    injectScript(chrome.extension.getURL("content-scripts/schoology/js/axios.js"), "head");
    injectScript(chrome.extension.getURL("content-scripts/schoology/texthelpschoology.js"), "head");
 
   injectStyle(chrome.extension.getURL("content-scripts/schoology/css/stylesTh.css"), "head");

    
}

//only inject if enabled in options
var brightspaceIntegrationEnabled = true;
storageArea.get({ brightspaceIntegrationEnabled: true }, function (readPrefs) {
    brightspaceIntegrationEnabled = readPrefs.brightspaceIntegrationEnabled;
    if (brightspaceIntegrationEnabled) {
        if (window.location.href.indexOf("/d2l/") != -1) {
            injectScript(chrome.extension.getURL("content-scripts/brightspace/texthelpbrightspace.js"), "head");
            injectStyle(chrome.extension.getURL("content-scripts/brightspace/css/stylesTh.css"), "head");
        }
    }
});