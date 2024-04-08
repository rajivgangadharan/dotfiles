
const HTML = `
<div class="th_open_with_middle">
  <div class="th_orbitdoc-icon-holder">  <div class="th_open_with_icon"></div>    </div>
    <div class="th_open_with_message">Open with OrbitNote</div>
</div>    
`;


var VIEWER_URL = 'https://orbit.texthelp.com';

function getViewerURL(pdf_url) {
    return VIEWER_URL + '?file=' + encodeURIComponent(pdf_url);
}

var storageArea = chrome.storage.sync || chrome.storage.local;
var OpenWebPagePDF=false;


var asyncCancel = new Promise((resolve, reject) => {
    storageArea.get({defaultOpenWebPagePDF: false}, function (readPrefs) {
        OpenWebPagePDF = readPrefs.defaultOpenWebPagePDF;
        if (!OpenWebPagePDF)
        {
            OpenWebPagePDF = readPrefs.defaultOpenWebPagePDF;
            if (!OpenWebPagePDF)
            {
                var urlPath = (window.location.href).toLowerCase();
    
                //alert(urlPath.indexOf('schoology.com'));
                if(urlPath.indexOf('schoology.') == -1)
                {
                resolve();
                }

                if(urlPath.indexOf('localhost:3000') == -1)
                {
                resolve();
                }
                
            }
        }
    });
});


function openExtension(){
    location.href =getViewerURL(location.href)
}


asyncCancel.then( ()=> {

    var urlPath = (window.location.href).toLowerCase();
    var showOpenWith = true;

    if(urlPath.indexOf('localhost:3000') > -1)
    {
        showOpenWith = false;
    }

    if(urlPath.indexOf('pdf.dev.texthelp.com') > -1)
    {
        showOpenWith = false;
    }
    if(urlPath.indexOf('orbit.texthelp.com') > -1)
    {
        showOpenWith = false;
    }

    
    if(showOpenWith)
    {

        var div = document.createElement("div");
        div.textContent="Open with OrbitNote";
        document.body.insertBefore(div, document.body.firstChild);
        div.innerHTML=HTML;
        div.className="th_open_with";
        var openWithIcon = div.querySelector(".th_open_with_icon");
        var openWithMesage = div.querySelector(".th_open_with_message");
        openWithIcon.addEventListener("click",openExtension)
        openWithMesage.addEventListener("click",openExtension)
    }


});