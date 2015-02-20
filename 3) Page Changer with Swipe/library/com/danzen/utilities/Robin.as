
package com.danzen.utilities {
	
	// ROBIN INTRODUCTION  
	// Robin is a custom Flash AS3 class with supporting NodeJS to handle realtime communication
	// realtime communication is used for chats and multiuser games with avatars, etc.
	// http://robinflash.wordpress.com - by inventor Dan Zen - http://www.danzen.com
	// The backend was initially PHP but was switched over to NodeJS for http://droner.mobi
	// if you are using Robin for commercial purposes, you are welcome to donate to Dan Zen
	// donations can be made to agency@danzen.com at http://www.paypal.com
	
	// INSTALLING CLASSES
	// suggested installation:
	// create a "classes" folder on your hard drive - for example c:\classes
	// add the classes folder to your Flash class path:
	// Flash menu choose Edit > Preferences > ActionScript - ActionScript 3 Settings 
	// then use the + sign for the source path box to add the path to your classes folder	
	// put the provided com/ directory with its folders and files in the classes folder
	// the readme has more information if you need it	
		
	// USING ROBIN
	// please make sure that com/danzen/utilities/Robin.as is in a folder in your class path
	// set the configuration below to match the robinServer.js file port
	// make sure you run your nodeJS as recommended
	// the Flash side will not connect unless you have nodeJS running properly
	// there is a list of methods, events and properties below for reference
	// see the example files that come with Robin to see how to work with Robin		

	// CONFIGURATION
	// the myServer variable must match the domain that is hosting your robinServer (no http://)
	// you can set myServer to "localhost" if you are running nodeJS locally
	// the myPort variable needs to match what you set in the robinServer.js for the port
			
	
    import flash.display.Sprite;
    import flash.net.XMLSocket;
    import flash.system.Security;
    import flash.utils.Timer;
	import flash.events.*;
	
	public class Robin extends Sprite {		

		// just put your server domain without http:// for example www.danzen.com
		// see RobinNest.zip for examples to run on your local host NodeJS server
		
		//private var myServer:String = "127.0.0.1";  	
		//private var myServer:String = "54.209.193.48"; 
		
		private var myServer:String; // now obtained with constructor parameter
		private var myPort:Number = 8081;
		
		// see the example files that call the Robin class
		
		// CONSTRUCTOR
		// Robin(theApplicationName:String, theMaxPeople:uint = 0, theFill:Boolean = true, theStartProperties:Object = null):void
		//		constructor to connect your application to the server.js Node socket for multiuser functionality
		//		server.js must be running for this to work.  It works in your Flash authoring tool too (AS3)
		//		PARAMETERS:
		//			theApplicationName:String
		//				you make this up - it should be one word (or camel case) and probably unique for your app
		//			theMaxPeople:uint
		//				how many people are allowed per "room" - there are as many rooms as needed - 0 is virtually unlimited
		//			theFill:Boolean
		//				if someone leaves a room - set to true to fill in their location with the next person to join
		//		EXAMPLES:
		//			at its simplest making a new Robin object might look like this: 
		//				var myRobin:Robin = new Robin("FreezeTag");
		//			or you could add some limitations: 
		//				var myRobin:Robin = new Robin("FreezeTag", 10, false);		
		
		// EVENTS
		// IOErrorEvent.IO_ERROR
		//		trouble connecting - make sure server.js is running and you have the right domain and port (see CONFIGURATION)
		// Event.CONNECT
		//		connected to socket - you can set up your application to submit and receive data, etc.
		// DataEvent.DATA
		//		dispatched when someone in the room makes a change (not including you)
		// Event.CLOSE
		//		the socket is closed - could be that server.js stops for some reason - all data on the server will be lost
		// Robin.CLIENT_JOINED
		//		another client (not you) joined - can find out with lastIndexToJoin property
		// Robin.CLIENT_LEFT
		//		another client (not you) left - can find out with lastIndexToLeave property
				
		// METHODS
		// setProperty(propertyName:String, propertyValue:Object):void
		// 		sets your property to the value and sends out change to all in room (distributes)
		// setProperties(objectOfPropertiesToSet:Object):void
		//		pass in an object with properties and values and it sets yours to match and distributes them
		// getProperty(propertyName:String):String
		//		returns your value for the property you pass to it
		// getProperties(propertyName:String):Array
		//		returns an array of everyone in the room's values for the property you pass to it (can include blanks! see numPeople property)
		// getPropertyNames():Array
		//		returns an array of all property names that have been distributed
		// getSenderProperty(propertyName:String):String
		//		returns the value of the property you pass it that belongs to the last person to distribute (not you)
		// getLatestValue(propertyName:String):String
		// 		returns the last distributed value for the property you pass to it - could be yours - could be null if person leaving
		// getLatestValueIndex(propertyName:String):Number
		//		returns the index number of the last person to distribute a value for the property you pass to it
		// getLatestProperties():Array
		//		returns an array of the last properties to be distributed (sometimes multiple properties are distributed at once)
		// appendToHistory(someText:String=""):void
		//		adds the text passed to it to the history file for the room (deleted if room is empty)
		// clearHistory():void
		//		deletes the history file for the room		
		// dispose():void
		//		removes listeners, closes connection to socket, deletes data objects
		
		// PROPERTIES (READ ONLY) Getter Methods at bottom		
		// applicationName:String - the name of your application
		// server:String - the server you set in the CONFIGURATION
		// port:Number - the port you set in the CONFIGURATION
		// maxPeople:Number - see CONSTRUCTOR
		// numPeople:Number - how many people are in the room - do not go by the length of a getProperties() array
		// fill:Boolean - see CONSTRUCTOR
		// senderIndex:Number - the index number of the last person to send out data
		// history:String - the history text for your room at the time of application start
		// lastIndexToJoin:Number - the index of the last client to join (other than you)
		// lastIndexToLeave:Number - the index of the last client to leave (other than you)
		
		// PUBLIC CONSTANTS
		public static const CLIENT_JOINED:String = "clientJoined";
		public static const CLIENT_LEFT:String = "clientLeft";
		
		// PRIVATE VARIABLES
		// getter methods allow you to get these properties (less the "my" prefix)
		private var myApplicationName:String;
		private var myMaxPeople:uint;
		private var myFill:Boolean;
		private var mySenderIndex:Number;
		private var myHistory:String = "";
		private var myLastIndexToJoin:Number;
		private var myLastIndexToLeave:Number;
		private var disposeCheck:Boolean = false;

		// public methods are available to get this data
		private var myData:Object = new Object();
		private var theirData:Object = new Object();
		private var latestValues:Object = new Object();
		private var latestIndexes:Object = new Object();
		private var latestProperties:Array = [];	
		
		// internal variables
		private var mySocket:XMLSocket;
		private var initializationCheck:Boolean = false;
		private var myTimer:Timer;				
		private var connectCheck:Boolean = false;		
		private var lastIndexes:Array = [];
		private var pingTimer:Timer;
		private var connectAttempt:Number = 0;
		private var errorCheck:Boolean = false;
		private var errorTimer:Timer;
					
		public function Robin(				
				theApplicationName:String,							  
				theMaxPeople:uint = 0, 
				theFill:Boolean = true,
				theServer:String = "127.0.0.1"
								) { 				
		
			trace ("hi from Robin");
			myApplicationName = theApplicationName;	
			if (!myApplicationName.match(/^[a-zA-Z0-9_-]+$/)) {
				trace ("----------------------------------");
				trace ("Robin Application Name: \""+myApplicationName+"\"");
				trace ("Sorry - your application name must include only a-z, A-Z, numbers, _ or -");
				trace ("----------------------------------");
				return;
			}		

			myMaxPeople = (theMaxPeople == 0) ? 1000000 : theMaxPeople;			
			myFill = theFill;
			myServer = theServer;
						
			mySocket = new XMLSocket();
			mySocket.timeout = 10;
			var fixTimer:Timer = new Timer(100,1); // create a delay for any error events
			fixTimer.addEventListener(TimerEvent.TIMER_COMPLETE, fix);			
			fixTimer.start();
			
			errorTimer = new Timer(500, 1);
			errorTimer.addEventListener(TimerEvent.TIMER, doErrorTimer);
			
			pingTimer = new Timer(15*1000); // create ping to defeat server timeOut (set to 15 seconds)
			pingTimer.addEventListener(TimerEvent.TIMER, ping);	
		}
		
		// --------------------  PRIVATE METHODS  -------------------------------
		
		private function fix(e:TimerEvent):void {
			getPolicy();
			makeConnection();
		}
		
		private function ping(e:TimerEvent):void {
			if (mySocket) {
				mySocket.send("p"); // send ping to socket server
			}			
		}
				
		private function getPolicy():void {			
			Security.loadPolicyFile("xmlsocket://"+myServer+":"+myPort);
			mySocket.connect(myServer, myPort);
			mySocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, policyDelay);			
			mySocket.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event):void{}); 
			mySocket.close();
		}		
		
		private function policyDelay(e:Event):void {
			// do not want to try and access socket before policy returns
			// so bounce errors to the makeConnection until the policy connects
			// Web issue only
			// errorCheck monitors how many times this has happened 
			// as there may be no socket connection to connect
			if (!errorCheck) {
				makeConnection();
			}
		}
		
		private function makeConnection():void {	
			mySocket.connect(myServer, myPort);
			mySocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, noConnect);
			mySocket.addEventListener(Event.CONNECT, handleMeta);			
			mySocket.addEventListener(Event.CLOSE, handleMeta);			
			mySocket.addEventListener(IOErrorEvent.IO_ERROR, handleMeta);			
			mySocket.addEventListener(DataEvent.DATA, incomingData);		
		}		
		
		private function noConnect(e:Event):void {
			connectAttempt++;
			if (connectAttempt > 40) {
				if (errorCheck) {return;}
				errorCheck = true;
				dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
				// wait to dispose in case delayed security error
				errorTimer.start();
			}
		}
		
		private function doErrorTimer(e:TimerEvent):void {		
			dispose();
		}
		
		private function handleMeta(e:Event):void {	
			switch(e.type){
				case 'ioError': 
					//trace ("error");
					dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
					if (pingTimer) {
						pingTimer.stop();
					}
				break;				
				case 'connect':
					if (!initializationCheck) {
						initializationCheck = true;										
						sendData();							
						pingTimer.start();
					}					
				break;				
				case 'close': 
					//trace ("close");					
					dispatchEvent(new Event(Event.CLOSE));
					dispose();
				break; 							
			} 
		}		
				
		
		private function incomingData(e:DataEvent):void {
			
			// GENERAL DATA FORMAT
			// HISTORY -~^~- LATEST -~^~- VARIABLES
			// HISTORY -~^~- LATEST -~^~- is only sent to new clients once at start
			// HISTORY -~^~- LATEST -~^~- is not sent to existing clients
			// VARIABLES are sent every time although ignored if client is leaving			
			
			// EXAMPLE FORMAT NEW CLIENT
			// history as string
			// -~^~-\n 			// delimeter then the latest users for the properties
			// _u_^1    		// the second user was last to update anything
			// text^0|value		// the first user was the last to update the text and its value
			// x^1|value		// the second user was the last to update x and y then its value
			// y^1|value
			// -~^~- 		// delimeter then the VARIABLES section - this shows sample for new client
			// -1 			// mySenderIndex is -1 as the client sent message to themself
			// 				// blank line for variables sent as nobody sent variables - client is new
			// _u_^12		// etc. for VARIABLES section (see later below for processing that section)
			
			
			// SPLIT DATA			
			
			var latestData:String
			var incomingData:String;
			
			//trace ("DATA:\n-----------\n"+e.data+"\n-----------");
			
			if (!String(e.data)) {return;}
			if (!connectCheck) {				
				var feed:Array = String(e.data).split("-~^~-\n");
				myHistory = decode(feed[0]).replace(/\n$/,"");
				latestData = feed[1].replace(/\n$/,"");
				incomingData = feed[2].replace(/\n$/,"");					
			} else {
				incomingData = String(e.data).replace(/\n$/,"");
			}			
			
			// VARIABLES FORMAT
			// 0 					// -1 if new user or -2 if a user is leaving
			// x|y 					// blank return if new user or a user is leaving
			// _u_^12|22			// could be blanks in here for users who have left
			// text^test|hello		// might be blanks in here for no updates from user or they left
			// x^27|30
			// y^25|200			
			
			// PROCESS VARIABLES 
			var lines:Array = incomingData.split("\n"); // line locked data
			mySenderIndex = Number(lines.shift());
			
			var updatedProperties:String = lines.shift();
			
			/* needs to be after we check
			if (getProperties("_u_")) {
				lastIndexes = getProperties("_u_").slice(0);
			}
			*/
			
			// for new clients and normal messages - not for leaving room
			//if (connectCheck == false || mySenderIndex > -1) {												
				theirData = {};
				var temp:Array;
				var prop:String;
				var temp2:Array;
				for (var i:uint=0; i<lines.length; i++) {
					if (lines[i] == "") {continue;}
					temp = lines[i].split("^");
					prop = temp[0];
					if (temp[1] != "") {	
						temp2 = temp[1].split("|");
						for (var j:uint=0; j<temp2.length; j++) {
							 temp2[j] = decode(temp2[j]);
						}
						theirData[prop] = temp2;
						//theirData[prop] = decode(temp[1]).split("|");
					}
				}
			//}					
						
			// PROCESS LATEST
			// if -2 values - someone has left
			
			if (connectCheck==false) { // new client get data from latestData
			
				// _u_^1    		// the second user was last to update anything
				// text^0|value		// the first user was the last to update the text and its value
				// x^1|value		// the second user was the last to update x and y then its value
				// y^1|value			
				
				latestProperties = [];
				var latestLines:Array = latestData.split("\n");				
				var latestVV:Array;
				
				for (var iii:uint=0; iii<latestLines.length; iii++) {					
					if (latestLines[iii] != "") {					
						latestVV = latestLines[iii].split("^"); // [_u_, 0|value] then [text, 0|value]						
						latestIndexes[latestVV[0]] = Number(latestVV[1].split("|")[0]);						
						latestValues[latestVV[0]] = String(latestVV[1].split("|")[1]);					
					}
				}				
			} else { // existing client				
				if (mySenderIndex > -1) {
					if (updatedProperties == "") {
						// should always be something for a normal send but just in case
					} else {				
						latestProperties = updatedProperties.split("|");
						for (var ii:uint=0; ii<latestProperties.length; ii++) {
							// already added all normal sender data to theirData[v]=[value|value|value]
							// already set mySenderIndex
							// getSenderProperty(property) gets the value at the mySenderIndex for the property							
							latestValues[latestProperties[ii]] = getSenderProperty(latestProperties[ii]);														
							latestIndexes[latestProperties[ii]] = mySenderIndex;
						}
					}	
				}
			}		
			
			if (connectCheck == false) { // client joined
				//trace("Robin - connect");	
				dispatchEvent(new Event(Event.CONNECT));	
				connectCheck = true;								
			} else if (mySenderIndex == -2) { // sender leaving - figure out who left					
				if (hasLeft()) {
					// set latestIndex belonging to leaving index to -2		
					for (var vari:String in latestIndexes) {
						if (latestIndexes[vari] == lastIndexToLeave) {
							latestIndexes[vari] = -2;
							// do not update values
							// this gives user choice to take a value of someone who left
							// for instance in a shared ball position
							// or ignore the last value if they check the index first
						}											
					}					
				}				
				dispatchEvent(new Event(Robin.CLIENT_LEFT));
			} else {
				if (hasJoined(mySenderIndex)) { // sender joined				
					// new client - dispatch CLIENT_JOINED
					// trace("Robin - Joined");
					dispatchEvent(new Event(Robin.CLIENT_JOINED));							
				}				
				dispatchEvent(new DataEvent(DataEvent.DATA, false, false, String(e.data)));				
			} 
			
			if (getProperties("_u_")) {
				lastIndexes = getProperties("_u_").slice(0);
			}
			if (mySenderIndex == -2) {				
				lastIndexes[lastIndexToLeave] = "";
			}
			
		}			
		
		private function hasLeft():Boolean {			
			var list:Array = [];
			if (!getProperties("_u_")) {
				for (var j:uint=0; j<lastIndexes.length; j++) {
					list.push("");
				}
			} else {
				list = getProperties("_u_");	
			}			
			for (var i:uint=0; i<lastIndexes.length; i++) {				
				if (lastIndexes[i] != "" && lastIndexes[i] != list[i]) {
					myLastIndexToLeave = i;
					return true;					
				}
			}			
			return false;					
		}
		
		private function hasJoined(clientIndex:Number):Boolean {		
			if (clientIndex >= lastIndexes.length || lastIndexes[clientIndex] == "") {
				myLastIndexToJoin = clientIndex;
				return true;
			} else {
				return false;
			}			
		}
		
		private function sendData(s:String=""):void {
			var f:Number;
			if (myFill) {f=1;} else {f=0;}
			var prefix:String = "%^%"+myApplicationName+"|"+myMaxPeople+"|"+f;		
			// %^%sample9|3|1^y=5^x=20
			// the %^% makes sure that if there are multiple entries in the socket buffer
			// that they can be separated in the server code
			if (mySocket.connected) {
				mySocket.send(prefix+s);			
			} else {
				//trace ("crash");
				dispatchEvent(new Event(Event.CLOSE));
				dispose();
			}
		}			
		
		private function encode(w:String):String {
			w = w.replace(/\r\n/g,"\n");
			w = w.replace(/\n\r/g,"\n");
			w = w.replace(/\n/g,"`~`");
			w = w.replace(/\^/g,"*`*");
			//w = w.replace(/\|/g,"^~^");
			w = w.replace(/\|/g,"%`%");
			return w;
		}
		
		private function decode(w:String):String {
			w = w.replace(/`~`/g,"\n");
			//w = w.replace(/^~^/g,"|");
			w = w.replace(/%`%/g,"|");
			w = w.replace(/\*`\*/g,"^");
			return w;
		}		
		
		// --------------------  PUBLIC METHODS  -------------------------------

		public function setProperty(n:String, v:Object):void {
			// set one of my properties at a time
			myData[n] = v;								
			sendData("^" + n + "=" + encode(String(v)));			
		}

		public function setProperties(o:Object):void {
			// set a bunch of my properties at once with an object
			var vars:String = "";
			for (var i:Object in o) {
				myData[i] = String(o[i]);
				vars += "^" + i + "=" + encode(String(o[i]));
			}						
			sendData(vars);			
		}

		public function getProperty(w:String):String {
			// get one of my properties
			return myData[w];			
		}
		
		public function getProperties(w:String):Array {
			// get an array of their properties
			return theirData[w];
		}
		
		public function getPropertyNames():Array {
			// get a list of their property names
			var props:Array =[];
			for (var i:String in theirData) {
				props.push(i);
			}
			return props;			
		}
		
		public function getSenderProperty(w:String):String {
			if (theirData[w] && theirData[w][mySenderIndex]) {
				return theirData[w][mySenderIndex];
			} else {
				return null;
			}
		}
				
		public function getLatestValue(w:String):String {				
			if (latestValues[w]) {
				return latestValues[w];
			} else {
				return null;
			}	
		}
		
		public function getLatestValueIndex(w:String):Number {			
			return Number(latestIndexes[w]);
		}
		
		public function getLatestProperties():Array {			
			return latestProperties;
		}				
				
		public function appendToHistory(t:String=""):void {
			sendData("^_history_=" + encode(String(t)));
		}		
		
		public function clearHistory():void {
			sendData("^_clearhistory_=");
		}			
		
		public function dispose():void {
			// avoid double disposing
			if (disposeCheck) {return;}
			disposeCheck = true;
			mySocket.removeEventListener(Event.CONNECT, handleMeta);					
			mySocket.removeEventListener(IOErrorEvent.IO_ERROR, handleMeta);			
			mySocket.removeEventListener(DataEvent.DATA, incomingData);
			mySocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, policyDelay);
			mySocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, noConnect);
			
			if (mySocket.connected) {
				mySocket.close();
			}			
			mySocket.removeEventListener(Event.CLOSE, handleMeta);	
			mySocket = null;
			
			pingTimer.stop();
			pingTimer.removeEventListener(TimerEvent.TIMER, ping);	
			pingTimer = null;
			
			myData = null;
			theirData = null;
			latestValues = null;
			latestIndexes = null;
			latestProperties = null;
			myHistory = null;
			
			trace ("bye from Robin");			
		}
		
		// ----------------------- PUBLIC READ ONLY PROPERTIES ---------------------
		
		public function get applicationName():String {
			return myApplicationName;
		}
		public function get server():String {
			return myServer;
		}
		public function get port():Number {
			return myPort;
		}
		public function get maxPeople():Number {
			return myMaxPeople;
		}
		public function get numPeople():Number {
			var list:Array = getProperties("_u_");
			var num:uint = 0;
			if (list != null && list.length > 0) {				
				for (var i:uint=0; i<list.length; i++) {
					if (list[i] != "") {
						num++;
					}
				}
			} 
			return num;					
		}
		public function get fill():Boolean {
			return myFill;
		}		
		public function get senderIndex():Number {
			return mySenderIndex;
		}
		public function get history():String {
			return myHistory;
		}	
		public function get lastIndexToJoin():Number {
			return myLastIndexToJoin;
		}	
		public function get lastIndexToLeave():Number {
			return myLastIndexToLeave;
		}	
			
	
	}
	
}

