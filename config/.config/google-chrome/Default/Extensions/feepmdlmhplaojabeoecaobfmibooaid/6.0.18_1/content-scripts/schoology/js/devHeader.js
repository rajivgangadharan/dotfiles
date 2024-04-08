window.textHelpExtensionID = "efeafadncamffgiohgiciboonbjldkfj";

console.log('++ Dev Texthelp PDF Reader Build ++');

function getExtensionID()
{
    var extensionID = window.textHelpExtensionID ;

    if(extensionID == undefined)
    {
        extensionID = "efeafadncamffgiohgiciboonbjldkfj";
    }

    return extensionID;
}