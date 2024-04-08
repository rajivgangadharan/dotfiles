window.textHelpExtensionID = "feepmdlmhplaojabeoecaobfmibooaid";

console.log('++ Production Texthelp PDF Reader Build ++');

function getExtensionID()
{
    var extensionID = window.textHelpExtensionID ;

    if(extensionID == undefined)
    {
        extensionID = "feepmdlmhplaojabeoecaobfmibooaid";
    }

    return extensionID;
}