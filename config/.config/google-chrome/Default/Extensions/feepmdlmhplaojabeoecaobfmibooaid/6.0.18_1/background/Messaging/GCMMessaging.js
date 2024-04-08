// Manages the the current users identity 
export class GCMMessaging {

  // Constructor
  constructor(database, syncType, messageCallback) {
    // sample url
    // https://messaging-db.texthelp.com/test-channel/_design/last/_view/last_view_topic?descending=true&limit=1&include_docs=true&startkey=["505e96030d9acc82debe4340d1e11954d8ed99643b79a12e72cab0b111d9715a@gedudemotexthelpsupport.com",{}]&endkey=["505e96030d9acc82debe4340d1e11954d8ed99643b79a12e72cab0b111d9715a@gedudemotexthelpsupport.com"]

      this._senderId = [database];
      this._messagingUrl = 'https://messaging.texthelp.com/';
      // this._messagingUrl = 'http://localhost:53530/';
      this._messagingCallback = messageCallback;
      this._lastMessage = undefined;
      this._waiting = false;
      this._onMessageCallback = undefined;
      this._lastTopic = undefined;
      this._lastCallback = undefined;
      this._lastWaitTopic = undefined;
      this._lastWaitCallback = undefined;
      this._syncType = syncType;

      this._GCMListen();

      chrome.alarms.onAlarm.addListener((alarm) => {
        switch (alarm.name) {
          case "GCMKeepAlive":
              if (this._lastTopic != undefined) {
                this._registerTopic(this._lastTopic, false, (response) => {
                });
              }
              break;
      
          default:
              break;
        }
      });

    }

  /**
   * In GCM there isn't a way to get a new last message.
   * By default we return the last last message
   * @param {string} topic - The topic to look up
   * @param {bool} useCache - Use the cached version if it exists
   * @param {function} callback - Callback function to call on completion
   *       If undefined use massageCallback defined in the constructor
   */
  _getLastMessage(topic, useCache, callback) {
    var expired = false;

    var haveLastMessage = (this._lastMessage !== undefined);

    if (topic !== this._lastTopic) {
      useCache = false;
    }

    if (this._lastTopic !== topic) {
      // Register the topic with our service
      this._registerTopic(topic, true, (result) => {
      });
    }

    this._lastTopic = topic;
    this._lastCallback = callback;

    if ((useCache) && (haveLastMessage)) {
      try {
        if (this._lastMessage.timetype == 'timed') {
          if (this._expiryTimeMS(this._lastMessage, true) < 0) {
            expired = true;
          }
        }
      } catch (error) {
        // The message isn't in the correct format, throw it away
        expired = true;
      }

      

      if (callback !== undefined) {
        if (expired) {
          callback(undefined);
        }
        else {
          callback(this._lastMessage);
        }
      }
      if (this._messagingCallback !== undefined) {
        if (expired) {
          this._messagingCallback(this._lastMessage);
        }
        else {
          this._messagingCallback(this._lastMessage);
        }
      }
      return;
    }
      
    try {
      var serviceUrl = this._messagingUrl + 'getlastmessage/v1';

      var xhr = new XMLHttpRequest();
      xhr.withCredentials = true;

      var data = JSON.stringify({
        "message_topic": topic
      });

      xhr.addEventListener("readystatechange", function () {
        if (xhr.readyState === 4) {
          if (xhr.status == 200) {
            // Tidy the response
            var response = JSON.parse(xhr.responseText);
            var lastMessage = undefined;

            if (response.length > 0) {

              // Extract the message
              var tempDoc = response[0];
              lastMessage = this._parseMessageDoc(tempDoc);
              
            }

            console.log('Got last message.');

            this._lastMessage = lastMessage;

            var expired = false;

            try {
              if (this._lastMessage.timetype == 'timed') {
                if (this._expiryTimeMS(this._lastMessage, true) < 0) {
                  expired = true;
                }
              }
            } catch (error) {
              // The message isn't in the correct format, throw it away
              expired = true;
            }
            
            if (callback !== undefined) {
              if (expired) {
                callback(undefined);
              }
              else {
                callback(lastMessage);
              }
            }
            if (this._messagingCallback !== undefined) {
              if (expired) {
                this._messagingCallback(undefined);
              }
              else {
                this._messagingCallback(lastMessage);
              }
            }
            if ((!expired) && (this._onMessageCallback !== undefined)) {
              this._onMessageCallback(lastMessage);
            }
          }
          else {
            if (callback !== undefined) {
              callback(undefined);
            }
            if (this._messagingCallback !== undefined) {
              this._messagingCallback(undefined);
            }
          }
        }
      }.bind(this));

      xhr.open("POST", serviceUrl);
      xhr.setRequestHeader("Content-Type", "application/json");
      xhr.setRequestHeader("Authorization", "Basic " + this._clientAuth);
      xhr.setRequestHeader("Cache-Control", "no-cache");

      xhr.send(data);
    }
    catch (error) {
      // throw it away
    }
  }

  /**
   * Wait for the next message to come in
   * @param {string} topic - The topic to listen for
   * @param {function} callback - optional function to call on message
   */
  _waitForNextMessage(topic, callback) {

    this._waiting = true;

    if (topic !== this._lastTopic) {
      // Register the topic with our service
      this._registerTopic(topic, true, (result) => {
      });
    }

    // Remove for now, not sure it helps anyway
    // this._GCMKeepAlive(5);

    this._lastWaitCallback = callback;
  }

  _onMessage(callback) {
    this._onMessageCallback = callback;
  }

    /**
   * Checks if the waiting for a message has stalled
   * This can happen after a laptop goes to sleep
   * for example.
   * @param {bool} restartIfStalled - Attempt to restart waiting?
   * @param {number} timeout - timeout in milliseconds after last wait
   * @returns {bool} Has the waiting timed out
   */
  _checkIfStalled(restartIfStalled, timeout) {
    // if timeout isn't set default to 1 minute
    return true;
  }

  /**
   * Parese the document and retrun a valid message
   * @param {json} document - The document to parse
   */
  _parseMessageDoc(document) {
    var returnMessage = undefined;
    try {
      // Get the message
      var tempMessage = {};

      if (typeof document['message'] == "string") {
        tempMessage = JSON.parse(document['message']);
      }
      else {
        tempMessage = document['message'];
      }

      returnMessage = {};
      try {
        returnMessage.features = tempMessage['disabled-features'].reduce(function(obj, v) {
          obj[v] = 0;
          return obj;
        }, {})
      } catch (error) {
        returnMessage.features = {};
      }
      
      returnMessage.time = tempMessage.time;
      returnMessage.timetype = tempMessage.timetype;

      // Parse the timestamp into a useable format
      // var timestamp = moment(document.ts, 'YYYYMMDDHHmmss').utc();
      // returnMessage.timestamp = timestamp.toISOString();
      returnMessage.timestamp = document.post_date;
    } catch (error) {
      returnMessage = undefined;
    }

    return returnMessage;
  }


  _expiryTimeMS(message, setAlarm) {
    // Check we have a valid time addition
    if (!Number.isNaN(message.time)) {
      // convert the timestamp back into a date
      try {

        var currDateTime = moment(new Date).utc();
        var timestamp = moment(message.timestamp).utc();

        var expiryDate = timestamp.clone();
        expiryDate.add(message.time, 'h');

        var diff = expiryDate.diff(currDateTime);

        if ((setAlarm) && (diff > 0)) {
          chrome.alarms.create('MessageExpired', {when: expiryDate.valueOf()});
          
          // chrome.alarms.create('MessageExpired', {delayInMinutes: 5});
        }

        return diff;
      
      } catch (error) {
          // Not a valid date, ignore
          console.error(error);
      }
    }
  }

  _GCMKeepAlive(waitTimeInMinutes) {
    // Check the alarm isn't already active
    //GCMKeepAlive
    chrome.alarms.get('GCMKeepAlive', (alarm) => {
      if (alarm == undefined) {
        chrome.alarms.create('GCMKeepAlive', {periodInMinutes: waitTimeInMinutes});
      }
    })
  }

  _registerTopic(topic, registerWithDb, callback) {

    chrome.storage.local.get("GCMRegistrationId", (result) => {

      var found = false;

      chrome.gcm.register(this._senderId, (registrationId) => {

        if (chrome.runtime.lastError != undefined) {
          // When the registration fails, handle the error and retry the
          // registration later.
          callback(null);
          return;
        }

        if (!registerWithDb) {
          callback({"success": true});
          return;
        }
      
        // check the topic is stored
        if ((result.id != undefined) && (result.topics != undefined)) {
          if (result.id == registrationId) {
            if (result.topics.indexOf(token) > -1) {
              found = true;
              // remove the above line and uncomment below after sprint has gone out.
              /*
              if (result.lastModified != undefined) {
                // Check it's not over a week old
                var currDate = moment(); // fixed just for testing, use moment();
                var lastModified = moment(result.lastModified);
                var expiry = currDate.clone().subtract(7, 'days').startOf('day');

                if (lastModified.isBefore(expiry)) {
                  found = true;
                }
              }
              */
            }
          }
        }

        if (!found) {
          // do we have an id?
          if (result.id != undefined) {
            // We have an id, register the topic against it
            if (result.topics != undefined) {
              result.topics.push(topic);
            }
            else {
              result.topics = [topic];
            }

            // Register with our service
            this._registerIdWithService(registrationId, topic, (result) => {
              if (result) {
                result.lastModified = moment().utc();

                chrome.storage.local.set({GCMRegistrationId: result});

                // this._GCMListen();

                callback(result);
              }
            });

          }
          else {
            // Register with our service
            this._registerIdWithService(registrationId, topic, (result) => {
              if (result) {
                var regObject = {
                  "id": registrationId,
                  "topics": [topic],
                  "lastModified": moment().utc()
                };
                chrome.storage.local.set({GCMRegistrationId: regObject});

                console.log('id registered with the messaging service.');

                // this._GCMListen();

                callback(regObject);
              }
            });
          }

        }
        else {
          callback(result);
        }
  
      });

    });

  }

    /**
   * Register the registration id and token
   * @param {string} regid - The registration id from Google
   * @param {string} topic - UThe topic we listen to
   * @param {function} callback - Callback function to call on completion
   *       If undefined use massageCallback defined in the constructor
   */
  _GCMListen() {
    chrome.gcm.onMessage.addListener((message) => {

      // A message is an object with a data property that
      // consists of key-value pairs.
      // Tidy the response
      var response = JSON.parse(message.data.message);
      
      // Throw away the message if it's not for us
      if (response.message.application !== undefined) {
        if (response.message.application.toLowerCase() !== 'rw4gc') {
          return;
        }
      }

      // Extract the message if there is one
      if (response.message.time !== undefined) {
        // Extract the message
        var lastMessage = this._parseMessageDoc(response);

        this._lastMessage = lastMessage;

        var expired = false;

        try {
          if (this._lastMessage.timetype == 'timed') {
            if (this._expiryTimeMS(this._lastMessage, true) < 0) {
              expired = true;
            }
          }
        } catch (error) {
          // The message isn't in the correct format, throw it away
          expired = true;
        }
        
        if ((!expired) && (this._messagingCallback !== undefined)) {
          this._messagingCallback(lastMessage);
        }
        if ((!expired) && (this._onMessageCallback !== undefined)) {
          this._onMessageCallback(lastMessage);
        }
      }

    });
  }

  /**
   * Register the registration id and token
   * @param {string} regid - The registration id from Google
   * @param {string} topic - UThe topic we listen to
   * @param {function} callback - Callback function to call on completion
   *       If undefined use massageCallback defined in the constructor
   */
  _registerIdWithService(regid, topic, callback) {
      
    var serviceUrl = this._messagingUrl + 'registertoken/v1';

    var xhr = new XMLHttpRequest();
    xhr.withCredentials = true;

    var data = JSON.stringify({
      "message_topic": topic,
      "google_token": regid
    });

    xhr.addEventListener("readystatechange", function () {
      if (xhr.readyState === 4) {
        if (xhr.status == 200) {
          // Tidy the response
          var response = JSON.parse(xhr.responseText);

          if (callback !== undefined) {
            callback(response.success);
          }

        }
        else {
          // just log the messaging error for now
          if (callback !== undefined) {
            callback(false);
          }
        }
      }
    }.bind(this));

    xhr.open("POST", serviceUrl);
    xhr.setRequestHeader("Content-Type", "application/json");
    xhr.setRequestHeader("Cache-Control", "no-cache");

    xhr.send(data);
  }

  get waiting() {
    return this._waiting;
  }

};
