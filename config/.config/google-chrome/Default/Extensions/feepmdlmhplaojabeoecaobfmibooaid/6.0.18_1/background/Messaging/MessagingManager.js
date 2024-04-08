import {MessagingFactory} from "./MessagingFactory.js"

// Manages the messaging 
 export class MessagingManager {

  // Constructor
  constructor(messagingType, messageCallback) {

    //console.log('constructing messenger');

      // default to a Google account if no account type is set.
      if (messagingType === undefined) {
        messagingType ="";
      }
      
      // create the authenticator for the current account type and get the users id. As we are in the constructor
      // and don't want any OAuth dialogs on a Chrome start set Interactive here to false. 
      this._messaging = (new MessagingFactory(messagingType, messageCallback).messaging);

      this.LastMessage = "";
  }

  /**
  * Retrieves the last message send to the specified topic
  * @param {string} topic - The topic to look up
  * @param {bool} useCache - The topic to look up
  * @param {function} callback - function to call on finish
  */
 getLastMessage(topic, useCache, callback) {
  //console.log('manager get last message');
  this._messaging._getLastMessage(topic, useCache, callback);
}

/**
* Retrieves the last message send to the specified topic
* @param {string} topic - The topic to look up
* @param {function} callback - function to call on message
*/
waitForNextMessage(topic, callback) {
  // Are we already waiting for a message?
  // If not wait
  if (!this._messaging.waiting) {
   // console.log('manager get last message');
    this._messaging._waitForNextMessage(topic, callback);
  }
}

onMessage(callback) {
  this._messaging._onMessage(callback);
}

checkIfStalled(restartIfStalled, timeout) {
  this._messaging._checkIfStalled(restartIfStalled, timeout);
}
  

};
