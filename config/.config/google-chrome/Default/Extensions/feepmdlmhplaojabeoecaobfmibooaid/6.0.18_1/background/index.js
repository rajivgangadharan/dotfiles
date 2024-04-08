import {
  MessagingManager
} from './Messaging/MessagingManager.js';

console.log(location.href);
console.log('Initialising TH Messaging Handler');
window.textHelp = window.textHelp || {};


chrome.runtime.onMessage.addListener(
  function (request, sender, sendResponse) {
    console.log(sender.tab ?
      "from a content script:" + sender.tab.url :
      "from the extension");
    if (request.sender == "DatadeskTrigger") {

      InitialiseDatadesk(request.UserDeIdent);
    

    }
  }
);



var MessagingManagerInstance;

function SendMessageToAllTabs(payLoad)
{
  chrome.tabs.query({}, tabs => {
    // eslint-disable-next-line no-restricted-syntax
    for (const tab of tabs) {
      const {
        id,
        url
      } = tab;
      if (url.includes("chrome://") || url.includes("devtools://")) {
        continue;
      }

     
      chrome.tabs.sendMessage(id, payLoad, function (response) {


      });
    }
  });
}

function InitialiseDatadesk(userID) {
  console.log('setting up datadesk');
  if (MessagingManagerInstance == undefined) {
    console.log("initialising messages...");
    MessagingManagerInstance = new MessagingManager(undefined);

    var topic = userID; 

    MessagingManagerInstance.getLastMessage(topic, true, (lastMessage) => {

      if (lastMessage !== undefined) {

  
        if (lastMessage.features != undefined)

          MessagingManagerInstance.LastMessage = lastMessage;

          var payLoad = {
            "sender": "datadesk",
            "data": lastMessage
          };
          SendMessageToAllTabs(payLoad);
        
      



      }

      //inMemoryLicense.pfs = policy.features;

      //this.ParseLicenceDataDesk(lastMessage);
    });


    chrome.idle.onStateChanged.addListener(function (newState) {

      if (newState == 'active') {
        MessagingManagerInstance.checkIfStalled(true, 120000);
      }
    });


    // Add messaging listener
    chrome.alarms.onAlarm.addListener(onMessagingAlarm);

    function onMessagingAlarm(alarm) {

      switch (alarm.name) {
        case "MessageExpired":
          // Create dummy message;
          var newMessageReset = {
            features: {},
            expired: 'expired'
          };
          MessagingManagerInstance.LastMessage = newMessageReset;

          var payLoad = {
            "sender": "datadesk",
            "data": newMessageReset
          };
          SendMessageToAllTabs(payLoad);
         
          break;

        default:
          break;
      }
    };

    MessagingManagerInstance.onMessage((license) => {
      console.log('new message -> ' + license);
      if (license.features != undefined) {
        if(MessagingManagerInstance.LastMessage.timestamp != license.timestamp)
        {
        MessagingManagerInstance.LastMessage = license;


            var payLoad = {
              "sender": "datadesk",
              "data": license
            };
           SendMessageToAllTabs(payLoad);
        
          }
          else{
            console.log('no change in datadesk');
          }


      }
    });
  } else {
    if (MessagingManagerInstance.LastMessage != undefined) {

      var payLoad = {
        "sender": "datadesk",
        "data": MessagingManagerInstance.LastMessage
      };
      SendMessageToAllTabs(payLoad);
     
    }
  }


}