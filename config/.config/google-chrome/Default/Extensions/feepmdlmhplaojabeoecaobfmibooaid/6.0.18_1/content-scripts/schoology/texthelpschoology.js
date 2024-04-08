var SchoologyFilename = "";

var pdfReaderServerAddress = "https://orbit.texthelp.com";

// Web link view
if (document.location.pathname.match(/^\/course\/([0-9]+)\/materials\/link\/view\//)) {
    var activeIframe = document.querySelector('.sCourseIframeResized-processed');
    var activeLink = activeIframe.src;


    var previewOnly = false;

    var PageTitle = document.querySelector('.page-title');
    var pdfIconOnPage = document.querySelector('.pdf-icon');
    if (activeLink != null) {
        var activeLink = activeLink.toLowerCase();

        if (activeLink.indexOf('.pdf') != -1) {
            previewOnly = true;
        }
    }

    if (pdfIconOnPage != null) {
        previewOnly = true;

    }

    if (previewOnly) {

        var topHolder = document.querySelector('.content-top-wrapper');

        var OpenWithHTML = `Open with OrbitNote`;

        let holderLink = document.createElement('div');
        holderLink.id = "thLinkHolder";

        holderLink.style.paddingTop = '10px';
        holderLink.style.borderTop = '1px solid #dcdcdc';

        let newLink = document.createElement("a");
        newLink.id = "SchoologyOpenWith";
        newLink.style.borderLeft = '0';

        var chromeId = 'feepmdlmhplaojabeoecaobfmibooaid';


        newLink.setAttribute('href', pdfReaderServerAddress + '?file=' +
            activeLink + "?previewonly=true");


        newLink.textContent = OpenWithHTML;

        holderLink.appendChild(newLink);

        topHolder.appendChild(holderLink);
    }


}
// --------------------------------------------------------------------------------------
// Assignment setup

if (document.location.pathname.match(/^\/course\/([0-9]+)\/materials/)) {
    Drupal.behaviors.stextHelp = function (sender) {
        var i = document.querySelector(
            ".s-grade-item-assignment-submission-apps");

        if (i != null) {

            var activeTHButton = document.getElementById(
                'texthelpAssignment');

            if (activeTHButton == undefined) {

                var textHelpButton = document.createElement('div');
                //iv class="s-grade-item-assignment-submission-app" tabindex="0" data-app-nid="kami"

                textHelpButton.classList.add(
                    's-grade-item-assignment-submission-app');
                textHelpButton.tabIndex = 0;
                textHelpButton.setAttribute("data-app-nid", "Texthelp");
                textHelpButton.id = 'texthelpAssignment';

                textHelpButton.innerHTML = ` <div class="app-logo-container">
      <img class="app-logo" src="chrome-extension://feepmdlmhplaojabeoecaobfmibooaid/Chrome/Icons/orbitnote-icon-32x32.png"></div>\n    
        <div class="app-title">OrbitNote</div>\n      
        <div class="texthelp-tooltip">Assign PDFs for students to complete using OrbitNote <a href="https://orbit.texthelp.com" target="_blank">Learn More</a></div>\n     
        `;



                i.appendChild(textHelpButton);
                /*
                    window.addEventListener("message", function(event) {
                            alert(request);
                        }, false
                    );
                */

                // Wait for message from background script.
                // window.addEventListener("message", receiveMessage, false);

                function receiveMessage(event) {

                    var chromeId = 'feepmdlmhplaojabeoecaobfmibooaid';

                    if (event.origin ==
                        "chrome-extension://" + chromeId + "") {

                        window.removeEventListener("message",
                            receiveMessage);

                        var headers = {};



                        headers.Authorization = event.data
                            .authorization_header

                        axios.get(event.data.download_url, {
                            responseType: "blob",
                            headers: headers
                        }).then(function (t) {

                            var formSend = new FormData;

                            var transferFilename = event.data
                                .file_name.toLowerCase();

                            if (transferFilename.indexOf('.pdf') ==
                                -1) {
                                transferFilename =
                                    transferFilename + '.pdf';
                            }
                            this.SchoologyFilename =
                                transferFilename;



                            formSend.append('name',
                                transferFilename);
                            formSend.append('use_plain', 1);
                            formSend.append('chunks', 0);
                            formSend.append('file', t.data);
                            formSend.append('originalfile',
                                transferFilename);

                            let schoologyProtocol = window.location
                                .protocol;
                            let schoologyDomain = window.location
                                .hostname;

                            let schoolurl = schoologyProtocol +
                                '//' + schoologyDomain;

                            axios.post(
                                schoolurl +
                                '/s_attachment_upload_chunked/2',
                                formSend, {
                                onUploadProgress: function (
                                    t) {
                                    console.log(t
                                        .loaded / t
                                            .total *
                                        .5 + .5);
                                }
                            }).then(function (response,
                                transferFilename) {
                                console.log(response.request
                                    .response);

                                var fileCollect = document
                                    .querySelector(
                                        "[name='file[files]'"
                                    );

                                var fileUploadData = {};

                                var fileUploadResponse =
                                    JSON.parse(
                                        response.request
                                            .response);


                                fileUploadData[
                                    fileUploadResponse
                                        .file.fid] = {
                                    title: event.data
                                        .file_name,
                                    encode: 1,
                                    TextHelpAssignment: 1

                                }

                                // Assign new file data to schoology
                                fileCollect.value = JSON
                                    .stringify(
                                        fileUploadData);

                                // Handle UI

                                HandleAssignmentUI(
                                    fileUploadResponse);
                                // Close Popup
                                Popups.close(e);


                            });



                        });


                    }


                    // ...
                }

                function HandleAssignmentUI(fileDetails) {

                    //Set title 
                    var documentTitle = document.querySelector(
                        '.s-grade-item-assignment-submission-content-title'
                    );

                    documentTitle.innerText = this.SchoologyFilename;

                    // Set header 
                    //s-grade-item-assignment-submission-app

                    var appsButtons = document.querySelectorAll(
                        '.s-grade-item-assignment-submission-app')


                    appsButtons.forEach(function (activeButton) {


                        if (activeButton.getAttribute(
                            'data-app-nid') ==
                            'Texthelp') {
                            activeButton.classList.add('active');
                        } else {
                            activeButton.style.display = 'none';
                        }
                    });


                    var documentHolder = document.querySelector(
                        '.s-grade-item-assignment-submission-content');

                    documentHolder.style.display = 'block';


                }

                textHelpButton.addEventListener("click", function (t) {
                    window.addEventListener("message",
                        receiveMessage, false);

                    t.stopPropagation(), t.preventDefault(), t
                        .stopImmediatePropagation(), Popups
                            .saveSettings();
                    var chromeId = 'feepmdlmhplaojabeoecaobfmibooaid';


                    if (typeof PDFJSDev !== 'undefined' && PDFJSDev
                        .test(
                            'GENERIC || QA')) {
                        chromeId =
                            'efeafadncamffgiohgiciboonbjldkfj'
                    }

                    let schoologyProtocol = window.location
                        .protocol;
                    let schoologyDomain = window.location.hostname;

                    let schoolurl = schoologyProtocol + '//' +
                        schoologyDomain;

                    // localhost:3000
                    // pdf.dev.texthelp.com/
                    var pdfServerAddress = 'chrome-extension://feepmdlmhplaojabeoecaobfmibooaid/filePicker/index.html',
                        o = Popups.activePopup(),
                        s = Popups.options({
                            ajaxForm: !1,
                            extraClass: "popups-extra-large s-grade-item-assignment-submission-popup thfilepicker",
                            updateMethod: "none",
                            hijackDestination: !1,
                            disableCursorMod: !0,
                            disableAttachBehaviors: !1
                        }),


                        a =
                            `<iframe id="schoology-app-container" frameborder="0" width="100%" height="600" \n    
              src="` + pdfServerAddress +
                            `?file=SchoologyTransfer#domain=` +
                            schoolurl + `" 
              name="schoology-app-container" \n     
               class="sAppLauncher-processed" style="height: 600px;"></iframe>\n      `;
                    e = Popups.openPathContent(
                        "assignment_submission_app",
                        "Add Assignment From OrbitNote",
                        a, t
                        .target, s, o)



                })
            }
        }
    }
}


// ---------------------------------------------------------
// Student open handling


function getUrlParameter(name) {
    name = name.replace(/[\[]/, '\\[').replace(/[\]]/, '\\]');
    var regex = new RegExp('[\\?&]' + name + '=([^&#]*)');
    var results = regex.exec(window.location.href);
    return results === null ? '' : decodeURIComponent(results[1].replace(/\+/g,
        ' '));
}



var urlPath = document.location.pathname;

try {
    urlPath = document.location.toString().split("?")[0];
} catch (e) {

}
if (document.location.pathname.match(/^\/assignment\/([0-9]+)\/info/)) {
    var thReturnURL = getUrlParameter('th_return_url');
    var thFileTitle = null;

    if (thReturnURL != '') {
        var a = document.location.pathname.match(
            /^\/assignment\/([0-9]+)\/info/);
        var courseID = a[1];

        var c = document.querySelector("[href='/assignment/" + courseID +
            "/dropbox/submit']");
        c.click();

        var chromeId = 'feepmdlmhplaojabeoecaobfmibooaid';


        let schoologyProtocol = window.location.protocol;
        let schoologyDomain = window.location.hostname;

        let schoolurl = schoologyProtocol + '//' + schoologyDomain;

        var schoologyAppContainer = document.createElement('iframe');

        schoologyAppContainer.id = "schoology-app-container";
        schoologyAppContainer.setAttribute('frameborder', '0');
        schoologyAppContainer.setAttribute('width', '100%');
        schoologyAppContainer.setAttribute('height', '600');
        schoologyAppContainer.setAttribute('name', 'schoology-app-container');

        schoologyAppContainer.style.height = '600px';
        schoologyAppContainer.className = 'sAppLauncher-processed'

        schoologyAppContainer.src = `chrome-extension://` + chromeId + `/schoologyHandin/index.html?file=SchoologyHandin&th_return_url=` + thReturnURL + `#domain=` + schoologyDomain;


        let tempDiv = document.createElement("div");
        tempDiv.id = "thSubmission";
        //  tempDiv.classList.add('popups-box');
        tempDiv.classList.add('thSubmission-overlay');
        tempDiv.classList.add('thSubmission-overlay-fullscreen');

        tempDiv.appendChild(schoologyAppContainer);


        document.body.appendChild(tempDiv);

        window.addEventListener("message", receiveMessage, false);

        function receiveMessage(event) {
            if ((event.origin ==
                "chrome-extension://efeafadncamffgiohgiciboonbjldkfj") || (
                    event.origin ==
                    "chrome-extension://feepmdlmhplaojabeoecaobfmibooaid")) {
                if (event.data.action == 'TurnIn') {


                    var headers = {};

                    headers.Authorization = event.data.authorization_header


                    var docID = thReturnURL;
                    var xhr = new XMLHttpRequest();

                    xhr.open("GET",
                        "https://www.googleapis.com/drive/v2/files/" +
                        docID + "?fields=downloadUrl,title", true);
                    xhr.setRequestHeader("Authorization", event.data
                        .authorization_header);

                    xhr.onreadystatechange = function () {
                        if (this.readyState == 4) {
                            if (this.status == 200) {
                                var jsonResponse = JSON.parse(this
                                    .response);

                                thFileTitle = getUrlParameter(
                                    'th_return_file_name');

                                axios.get(jsonResponse.downloadUrl, {
                                    responseType: "blob",
                                    headers: headers,

                                }).then(function (t) {

                                    var intervalSettings =
                                        setInterval(() => {
                                            if (Drupal && Drupal
                                                .settings &&
                                                Drupal.settings
                                                    .s_attachment &&
                                                Drupal.settings
                                                    .s_attachment
                                                    .file_service_upload &&
                                                Drupal.settings
                                                    .s_attachment
                                                    .file_service_upload
                                                    .token) {

                                            }

                                            var submissionForm =
                                                document
                                                    .querySelector(
                                                        '.popups-dropbox-submit'
                                                    );

                                            submissionForm.style
                                                .display =
                                                'none';

                                        }, 100);
                                    clearInterval(intervalSettings);

                                    UploadTurnInAssignment(
                                        thFileTitle, t.data);
                                    // Now start the process to add the blob to the form and close down the texthelp window


                                });
                            }
                        }
                    };


                    xhr.send();
                }
            }
        }

        var assignmentIDPath = document.location.pathname.match(
            /^\/assignment\/([0-9]+)\/info/);
        var assignmentID = assignmentIDPath[1];
        var assignmentPath = 'assignment/' + assignmentID + '/info';
        /*
            e = Popups.openPathContent(assignmentPath,
                "Preparing Assignment TurnIn", a, t
                .target, s, o)

        */


    }

    var OpenWithHTML = `Open with OrbitNote`;

    var attachmentFiles = document.querySelectorAll(
        '#main-inner .attachments-file');
    var courseNameHolder = document.querySelector('.course-title');
    var courseNameTxt = courseNameHolder.querySelector('.sExtlink-processed');

    var usedFilenames = [];

    attachmentFiles.forEach(function (attachmentItem) {

        var filenameArea = attachmentItem.querySelector(
            '.attachments-file-name');
        var fileIcon = attachmentItem.querySelector(
            '.attachments-file-icon .pdf-icon')
        var documentPDFhref = attachmentItem.querySelector(
            ".sExtlink-processed").href;
        var classAssignmentID = document.getElementById('edit-nid');

        if (classAssignmentID == null) {
            // Try and get the assignment id from url
            var pageelem = document.location.pathname.match(
                /^\/assignment\/([0-9]+)\/info/);

            classAssignmentID = document.createElement('div');
            classAssignmentID.value = pageelem[1];

        }

        //if(fileIcon.)

        if (fileIcon != null) {
            var CourseID = document.getElementById(
                'edit-node-realm-id');

            if (CourseID == null) {
                // Try and get the assignment id from url


                CourseID = document.createElement('div');
                CourseID.value = '';

            }


            let tempDiv = document.createElement("a");
            tempDiv.id = "SchoologyOpenWith";

            tempDiv.innerHTML = OpenWithHTML;

            var filenameRoot = attachmentItem.querySelector(
                ".attachments-file-name");

            var originalFileName = filenameRoot.querySelector(
                '.infotip');

            var pageTitle = document.querySelector(".page-title");

            if (originalFileName != null) {
                originalFileName = originalFileName.innerText;
            } else {
                originalFileName = filenameRoot.querySelector(
                    '.sExtlink-processed');
                if (originalFileName != null) {

                    originalFileName = originalFileName.innerText;

                    if (usedFilenames.indexOf(originalFileName) > -1) {
                        originalFileName = "1-" + originalFileName;
                    } else {



                    }

                    usedFilenames.push(originalFileName);

                }

            }

            if (originalFileName.toLowerCase().indexOf('.pdf') == -1) {
                originalFileName += '.pdf';
            }

            var chromeId = 'feepmdlmhplaojabeoecaobfmibooaid';


            // Cleanup filename
            // Cleanup filename
            originalFileName = originalFileName.replace(/&/g, '_');
            originalFileName = originalFileName.replace(/}/g, '_');
            originalFileName = originalFileName.replace(/{/g, '_');
            originalFileName = originalFileName.replace(/%/g, '_');
            originalFileName = originalFileName.replace(/#/g, '_');
            originalFileName = originalFileName.replaceAll('+', '_');
            originalFileName = encodeURIComponent(originalFileName);
            // Clean up PageTitle
            var PageTitleClean = pageTitle.innerText.replace(/&/g, '_');
            PageTitleClean = PageTitleClean.replace(/}/g, '_');
            PageTitleClean = PageTitleClean.replace(/{/g, '_');
            PageTitleClean = PageTitleClean.replace(/%/g, '_');
            PageTitleClean = PageTitleClean.replace(/#/g, '_');
            PageTitleClean = PageTitleClean.replace('/', '_');
            PageTitleClean = encodeURIComponent(PageTitleClean);

            tempDiv.setAttribute('href', "chrome-extension://" +
                chromeId + "/schoologyOpen/index.html?file=" +
                documentPDFhref + "?&nid=" +
                classAssignmentID.value + "&cid=" + CourseID.value +
                "&ofilename=" + originalFileName +
                "&assignmenttitle=" + PageTitleClean +
                "&CourseTitle=" + encodeURIComponent(courseNameTxt.innerText) +
                "&SCHOOLOGYURL=true");

            filenameArea.appendChild(tempDiv);
        }

    });



}

function UploadTurnInAssignment(SubmissionFileName, UploadData) {
    var formSend = new FormData;

    formSend.append('name', SubmissionFileName);
    formSend.append('use_plain', 1);
    formSend.append('chunks', 0);
    formSend.append('file', UploadData);

    let schoologyProtocol = window.location.protocol;
    let schoologyDomain = window.location.hostname;

    let schoolurl = schoologyProtocol + '//' + schoologyDomain;

    axios.post(
        schoolurl + '/file/upload-service',

        formSend, {
        headers: {
            Authorization: "Bearer " + Drupal.settings.s_attachment
                .file_service_upload.token
        },
        onUploadProgress: function (t) {
            console.log(t.loaded / t
                .total * .5 + .5);
        }
    }).then(function (response) {

        var fileCollect = document
            .querySelector(
                "[name='file[files]'");

        var fileUploadData = {};

        var fileUploadResponse = JSON.parse(
            response.request.response);


        fileUploadData[fileUploadResponse.fileMetadataId] = {
            title: thFileTitle,
            encode: true

        }

        // Assign new file data to schoology
        fileCollect.value = JSON.stringify(
            fileUploadData);

        // Setup Assignment ID 
        var assignmentIDPath = document.location.pathname.match(
            /^\/assignment\/([0-9]+)\/info/);
        var assignmentID = assignmentIDPath[1];
        var assignmentPath = 'assignment/' + assignmentID + '/info';

        var resolveAssignmentPath = document.querySelector(
            "#dropbox-submit-upload-tab-content form");
        resolveAssignmentPath.action = resolveAssignmentPath.action
            .split("%3F")[0];


        var addedFileDetail = `<div class="progressWrapper" id="o_1cer5oedb1u3qlrt61qr7s174oa" style="opacity: 1;">\n           
         <div class="progressContainer green">\n            
           <span class="progressName th_texthelpUpload" ></span>\n          
           <div class="progressBarStatus">Complete</div><div class="progressBarComplete" style="">\n  
                       </div>\n            
                         <div class="file-details-content clearfix" style="display: none;">\n        
                               </div>\n       
                                    </div>\n   
                                           </div>`;

        let newfileContainer = document.createElement("div");

        newfileContainer.style.display = "block";
        newfileContainer.innerHTML = addedFileDetail;

        var thUploadFilename = newfileContainer.querySelector('.th_texthelpUpload');
        thUploadFilename.id = `file-${fileUploadResponse.fileMetadataId}`;
        thUploadFilename.textContent = thFileTitle;

        var attachmentContainer = document.querySelector(
            '#attachments-added-container');

        attachmentContainer.appendChild(newfileContainer);

        var submissionForm = document.querySelector(
            '.popups-dropbox-submit');
        submissionForm.style.height = "353px";
        submissionForm.style.display = 'block';

        var activeUploadWindow = document.getElementById(
            'thSubmission');

        try {
            activeUploadWindow.parentNode
                .removeChild(
                    activeUploadWindow
                )
        } catch (e) {

        }

        history.pushState(null, "", document.location.toString().split(
            "?")[0]);


    });
}



/// Handle course attachments only
// https://app.schoology.com/course/2325128606/materials

if (document.location.pathname.match(/^\/course\/([0-9]+)\/materials\//)) {
    var previewOnly = false;

    var PageTitle = document.querySelector('.page-title');
    var pdfIconOnPage = document.querySelector('.pdf-icon');
    if (PageTitle != null) {
        var pageTitleText = PageTitle.innerText.toLowerCase();

        if (pageTitleText.indexOf('.pdf') != -1) {
            previewOnly = true;
        }
    }

    if (pdfIconOnPage != null) {
        previewOnly = true;

    }

    if (previewOnly) {

        var pathToFile = document.querySelectorAll('.attachments-file-name');
        var pdfLink = pathToFile[0].querySelector('.sExtlink-processed');


        var topHolder = document.querySelector('.content-top-wrapper');

        var OpenWithHTML = `Open with OrbitNote`;

        let holderLink = document.createElement('div');
        holderLink.id = "thLinkHolder";

        holderLink.style.paddingTop = '10px';
        holderLink.style.borderTop = '1px solid #dcdcdc';

        let newLink = document.createElement("a");
        newLink.id = "SchoologyOpenWith";
        newLink.style.borderLeft = '0';

        var chromeId = 'feepmdlmhplaojabeoecaobfmibooaid';


        newLink.setAttribute('href', pdfReaderServerAddress + '?file=' +
            pdfLink + "?previewonly=true");


        newLink.innerHTML = OpenWithHTML;

        holderLink.appendChild(newLink);

        topHolder.appendChild(holderLink);
    }
}
