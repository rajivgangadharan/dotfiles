

var storageArea = chrome.storage.sync || chrome.storage.local;
var extensionAddress = "";
var ignoreImageClick = false;
var activeNode = null;

var classroomOpenWith = true;
storageArea.get({ classroomOpenWith: true }, function (readPrefs) {
    classroomOpenWith = readPrefs.classroomOpenWith;
});
var mutationObCalled = false;

const HTMLOpenWith = `
<div class="th_open_with_middle">
  <div class="th_orbitdoc-icon-holder">  <div class="th_open_with_icon"></div>    </div>
    <div class="th_open_with_message">Open with OrbitNote</div>
</div>  
`;


var documentViewerAddedListener = new MutationObserver(function (e) {
    e.forEach(function (e) {

        for (var t = 0; t < e.addedNodes.length; t++) {
            var a = e.addedNodes[t];
            if ("material-iframe" === a.id) {

                var n = a.src.match(/\/file\/d\/([A-z0-9-_]+)\/grading\?authuser=([0-9]+)/);
                if (n) {

                    var i = n[1],
                        r = n[2];
                    jsonData = {
                        ids: [i],
                        authuser: r,
                        from: "classroomgradingview"
                    };

                    var aria = 'Source_Document';
                    
                    if (classroomOpenWith) {

                        extensionAddress = 'https://orbit.texthelp.com/?file=';
                        extensionAddress += "https://drive.google.com/uc?id=" + i + "&export=download&filename=" + aria + '&gradeView=true';

                        // Currently this is the selector class for the active filename
                        var activeDov = document.querySelector('.LYKue');

                        if(ignoreImageClick)
                        {
                            if (activeDov.innerText.indexOf('PDF:') != -1) {
                                a.src = extensionAddress;
                            }
                        }

                        
                        
                        if (activeDov.innerText.indexOf('PDF:') != -1) {
                            a.src = extensionAddress;
                        }

                        
                    }
                }
            }
        }
    })
});

documentViewerAddedListener.observe(document.body, {
    childList: !0,
    subtree: !0,
    attributes: !1,
    characterData: !1
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
            let role = mutations[i].target.getAttribute("role");
            if (role==="toolbar"){
                let style = mutationsList[i].target.getAttribute("style");
                if (style==="opacity: 1;"){
                    openWith();
                    break;
                }
            }
        }
    });
});

document.addEventListener('click', events => {
    var node = events.target;

    // Handle the click on a PDF button
    var closestAnchor = node.closest('a');
    if(closestAnchor != null && classroomOpenWith){
        var anchorAriaLabel = closestAnchor.getAttribute("aria-label");

        if(anchorAriaLabel != null && anchorAriaLabel.startsWith("Attachment: PDF")){
            let linkAddress = closestAnchor.href;

            let stage1 = linkAddress.split("/view?");
            if(stage1.length > 1){
                let stage2 = stage1[0].split("/");
                var driveId = stage2[stage2.length-1];
            }

            let activeLocation = encodeURIComponent(location.href);

            // Handle the situation where student is not in the detail view
            if(location.href.indexOf('/all') > -1)
            {
                var holdLi = closestAnchor.closest('li');
                var ahrefArray = holdLi.querySelectorAll('a');
                activeLocation = encodeURIComponent(ahrefArray[ahrefArray.length-1].href);
            }

            let extensionAddress = `https://orbit.texthelp.com/?file=https://drive.google.com/uc?id=${driveId}&export=download&filename=${anchorAriaLabel}&ClassroomRetUrl=${activeLocation}`;
            
            location.href = extensionAddress;
            return;
        }
    }     


    if(node.parentElement.innerText.indexOf('PDF:') != -1) 
    {
        ignoreImageClick = true;
        activeNode = node.parentElement;
    }
    else
    {
        ignoreImageClick = false;
        activeNode = node.parentElement;;
    }

    let imagePDFLinks = [];

    // TODO: handling pdf button clicks based on "[data-mime-type='application/pdf']" can be removed, as it is handled by the previous method anyway - aria label starts with "Attachment: PDF" 
    imagePDFLinks = Array.from(document.querySelectorAll("[data-mime-type='application/pdf']"))
        .filter(x => !x.offesetHeight)
        .map(img => img.closest('a'))

    var useLinkReference = false;

    while (node) {
        if (node.getAttribute) {

            var aria = node.getAttribute("aria-label");

            imagePDFLinks.forEach(element => {
                var parentLinkItem = node.closest('a');

                if (element == parentLinkItem) {

                    //"https://drive.google.com/open?id=1xFM0WNSzOFC7o72TE8NQRzacaZrhOKDq&authuser=0"
                    var linkAddress = parentLinkItem.href;

                    if(linkAddress != null)
                    {
                        //linkAddress  = linkAddress.toLowerCase(); 
                    }

                    if(linkAddress.indexOf("id=") == -1)
                    {
                        // https://drive.google.com/file/d/1GcsKbX82ajLb20YiFW5DWDRnd_YphvkQ/view?usp=sharing

                        var stage1 = linkAddress.split("/view?") ;
                        
                        if(stage1.length > 1){
                            var stage2 = stage1[0].split("/");

                            var driveId = stage2[stage2.length-1];

                            if (classroomOpenWith) {
                                var activeLocation = encodeURIComponent(location.href);

                                useLinkReference = true;

                                // Handle the situation where student is not in the detail view
                            
                                if(location.href.indexOf('/all') > -1)
                                {
                                    var holdLi = parentLinkItem.closest('li');

                                    var ahrefArray = holdLi.querySelectorAll('a');
                                    activeLocation = encodeURIComponent(ahrefArray[ahrefArray.length-1].href);

                                }
                                extensionAddress = 'https://orbit.texthelp.com/?file=';

                                var createButton = document.querySelector('.SRX5Hd[guidedhelpid="createMenuGH"]');

                                if(createButton == null)
                                {
                                    var studentWorkButton = document.querySelectorAll('.S6Vdac');

                                    var setPossTeacherRole = false;
                                    for (i = 0; i < studentWorkButton.length; i++) {
                                
                                        if(studentWorkButton[i].innerText == 'Student work')
                                        {
                                            setPossTeacherRole = true;
                                        }
                                    }
                                    if(setPossTeacherRole)
                                    {
                                        extensionAddress += "https://drive.google.com/uc?id=" + driveId + "&export=download&filename=" + aria + "&ClassroomTeacherSrc=true";
                                    }
                                    else{
                                        extensionAddress += "https://drive.google.com/uc?id=" + driveId + "&export=download&filename=" + aria + "&ClassroomRetUrl=" + activeLocation;
                            
                                    }
                                }
                                else{
                                    extensionAddress += "https://drive.google.com/uc?id=" + driveId + "&export=download&filename=" + aria+ "&ClassroomTeacherSrc=true";;
                                }


                                location.href = extensionAddress;
                            }
                        }
                    }
                    else{
                        var url = new URL(linkAddress)

                        var address = url.searchParams.get("id")
                    
                   
                        if (classroomOpenWith) {
                            var activeLocation = encodeURIComponent(location.href);

                            useLinkReference = true;

                            // Handle the situation where student is not in the detail view
                        
                            if(location.href.indexOf('/all') > -1)
                            {
                                var holdLi = parentLinkItem.closest('li');

                                var ahrefArray = holdLi.querySelectorAll('a');
                                activeLocation = encodeURIComponent(ahrefArray[ahrefArray.length-1].href);

                            }
                            extensionAddress = 'https://orbit.texthelp.com/?file=';
                            extensionAddress += "https://drive.google.com/uc?id=" + address[0] + "&export=download&filename=" + aria + "&ClassroomRetUrl=" + activeLocation;
                            location.href = extensionAddress;
                        }
                    }

                }
            });


        }
        node = node.parentNode;
    }
});


function openExtension() {
    var win = window.open(extensionAddress, '_blank');
    win.focus();
}

function openWith() {
    var toolbar = document.querySelector('[role="toolbar"]');
    var div = document.querySelector(".th_open_with");

    if (!div) {
        div = document.createElement("div");
        div.innerHTML = HTMLOpenWith;

        toolbar.children[0].insertBefore(div, toolbar.children[0].children[2]);
        //toolbar.children[0].children[0].parentElement.appendChild(div);
        div.className = "th_open_with";
        div.addEventListener("click", openExtension)

    }
}


chrome.runtime.sendMessage({greeting: "hello"}, function(response) {
    alert(response.farewell);
  });