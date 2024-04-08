
import {GCMMessaging} from './GCMMessaging.js';

// Creates the right type of messaging based on the the type passed.
// By default it will use the couch db messaging

export class MessagingFactory {

  /**
   * @constructor
   * @param {string} messagingType - message type to create.
   * @param {function} messageCallback - function called on message
   */
  constructor(messagingType, messageCallback) {
      try{
          switch (messagingType) {
          
            default:
              this._messaging = new GCMMessaging('224182583415', 'gcm', messageCallback);
              break;
          }
      }
      catch(ex){
          console.log(ex);
          this._messaging = {};
      }
  }

  /**
   * Read only property to get the correct messaging instance
   * @constructor
   * @return {object} instance of the created authenticator.
   */
  get messaging() {
      return this._messaging;
  }
}
