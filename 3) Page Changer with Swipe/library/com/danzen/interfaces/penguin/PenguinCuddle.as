
package com.danzen.interfaces.penguin {

	// PENGUIN / PENGUINPOP / PENGUINCUDDLE INTRODUCTION  
	// Penguin is a system where you can emulate mobile device rotation and translation in Flash
	// this lets you create "tilt" applications independent from the technology
	// for instance, rolling a ball around in a maze or steering a car on a mobile device
	// the emulator leaves the data, this class reads it and passes it to your Flash application
	// so if you can get something to leave the data for you, your application is ready to roll!
	
	// http://penguinsflash.wordpress.com - by inventor Dan Zen - http://www.danzen.com
	// if you are using Penguin for commercial purposes, you are welcome to donate to Dan Zen
	// donations can be made to agency@danzen.com at http://www.paypal.com
	
	// INSTALLING CLASSES  
	// suggested installation:
	// create a "classes" folder on your hard drive - for example c:\classes
	// add the classes folder to your Flash class path:
	// Flash menu choose Edit > Preferences > ActionScript - ActionScript 3 Settings 
	// then use the + sign for the source path box to add the path to your classes folder	
	// put the provided com/danzen/ directory with its folders and files in the classes folder
	// the readme has more information if you need it

	// USING PENGUIN  
	// please make sure that the following files are in a folder in your class path:	
	// 		com/danzen/interfaces/penguin/Penguin.as
	// 		com/danzen/interfaces/penguin/PenguinPop.as
	// 		com/danzen/interfaces/penguin/PenguinCuddle.as
	// 		com/danzen/utilities/Falcon.as
	// the three penguin classes are alternatives and act independently	
	// the Penguin.as file uses Falcon.as but the other two do not
	
	// Penguin
	// Examples using Penguin are in the samples folder
	// in this version, you double click and install the penguinTiltEmulator.air file
	// you will need AIR from http://adobe.com it is free and fast to install
	// the emulator writes XML on to your computer to simulate a device writing data
	// the data is in the form of TiltML or Tilt Markup Language
	// http://tiltml.wordpress.com
	// Flash then reads in the XML and you power your motion from it
	// see the diagrams that come with Penguin to better understand the data
	// this is roll pitch yaw forward right down data
	
	// any samples that make use of physics engines are presented as swf files only
	// they use the APE physics engine available at http://www.cove.org/ape/
	
	// PenguinPop
	// Examples using Penguin are in the samples_pop folder
	// in this version, the tilt emulator is popped up in a new window
	// communication with your Flash application is through the LocalConnection class
	// it can be used to show people in the Web your prototype
	// but it does not read in an XML file so will not be optimal for a real application
	
	// PenguinCuddle
	// Examples using Penguin are in the samples_cuddle folder
	// here, the tilt emulator is loaded into a holder swf file along with your application
	// communication with your Flash application is through a "global" variable
	// like PenguinPop it can be used to show people in the Web your prototype
	// but it does not read in an XML file so will not be optimal for a real application	
		
	// there is a list of methods, events and properties below for reference	
	// see the example files that come with Penguin to see how to use Penguin		


	import flash.display.Sprite;
	import flash.display.MovieClip;
    import flash.events.*;
	import flash.net.LocalConnection;
	import flash.utils.Timer;
	
    public class PenguinCuddle extends Sprite {
		
		// CONSTRUCTOR
		// PenguinCuddle(theView:String="top", theOrientation:String="vertical", theFreedom:String="two"):void
		//		constructor to set the Tilt emulator settings
		//		this is different than the Penguin constructor
		//		Penguin is a for you testing your application so you control the emulator
		//		Here, you are displaying your prototype on the Web
		//		so you probably want to start the emulator in the right view, orientation and freedom
		//		PARAMETERS:
		//		theView:String
		//			- default "top" other values: "front"
		//			- top view looks down on the device with the screen parallel to the ground
		//			- front view is holding the device up in front of you with screen perpendicular to the ground
		//		theOrientation:String
		//			- default "vertical" other values: "horizontal"
		//			- just the way the screen is oriented
		//			- depending on your device, this may or may not be important to your readings
		//			- if there is an issue you can always transpose your data
		//		theFreedom:String 
		//			- default "two"	other values: "one"
		//			- are you in two plane tilt mode or one plane rotation mode
		//			- this is just an tilt emulator interface issue so does not effect data
		//			- it was just easier to navigate if we separate out the perpendicular axis
				
		// EVENTS
		// Event.CONNECT
		//		the emulator is ready for setting view, orientation and freedom
		// PenguinPop.MOTION_START
		//		dispatched when motion starts (this is at any motion start as the applicatin runs)
		// PenguinPop.MOTION_START
		//		dispatched when there has been no motion in motionInterval seconds (see getter setter methods)
		// Event.CHANGE
		//		dispatched when the emulator sends data 
		
		// METHODS
		// transposeValue(a:String, b:String):void
		// 		if the data coming in is not how you want to work with it
		// 		for instance, you want pitch to be -pitch or roll to be yaw...
		//		a is the original data which will be changed to values from b
		// 		properties you change are roll pitch yaw forward right down
		// 		you can also specify negatives like transposeValue("pitch", "-yaw");
		// 		see the method for more info
		// setView(v:String):void 
		//		sets the emulator view - v can be either "top" or "front"
		// setOrientation(o:String):void
		//		sets the orientation on the emulator - o can be "horizontal" or "vertical"
		// setFreedom(f:String):void 
		//		sets the freedom on the emulator - f can be "one" or "two"
		// dispose():void
		// 		stops tracking beats and removes listeners, etc.
		
		// PROPERTIES 	
		// view:String - sets or gets emulator view - default "top" other values: "front"
		// orientation:String - sets or gets emulator orientation default "vertical" other values: "horizontal"
		// roll:Number - (read only) clockwise rotation around the forward direction
		// pitch:Number - (read only) clockwise rotation around the right direction
		// yaw:Number - (read only) clockwise rotation around the down direction
		// forward:Number - (read only) direction of travel or user's view
		// right:Number - (read only) direction perpendicular to the forward direction and laterally to the right
		// down:Number - (read only) direction perpendicular to the forward and right and in the down direction
		// tiltUnits:String - (read only) default for the Penguin emulator is "degrees"
		// translationUnits:String - (read only) default for the Penguin emulator is "screens"
		// xmlData:XML - (read only) - the full XML from the emulator
		// transposeList:Array - sets or gets a list of transpositions (alternative to transposeValue method)				
		// motionInterval:Number - sets or gets seconds of no motion before the STOP_MOTION event is triggered
	
		// CONSTANTS
		// MOTION_START:String - static constant (Penguin.MOTION_START) for motion start event
		// MOTION_STOP:String - static constant (Penguin.MOTION_STOP) for motion stop event	
				
		public static const MOTION_START:String = "motion start";
		public static const MOTION_STOP:String = "motion stop";		
		
		public var view:String = "top";
		public var orientation:String = "vertical";
		public var roll:Number = 0;
		public var pitch:Number = 0;
		public var yaw:Number = 0;
		public var forward:Number = 0;
		public var right:Number = 0;
		public var down:Number = 0;
		public var tiltUnits:String = "degrees";
		public var translationUnits:String = "screens";
		public var xmlData:XML;
		public var transposeList:Array;	
		
		private var myConnectionSend:LocalConnection = new LocalConnection();		
		private var myTimer:Timer;
		private var dataNames:Array = ["pitch", "roll", "yaw", "forward", "right", "down"];
		private var myView:String;
		private var myOrientation:String;
		private var myFreedom:String;
		
		private var motionState:String = PenguinCuddle.MOTION_START;
		private var motionLast:Array = [0,0,0,0,0,0];
		private var motionCount:Number = 0;
		private var period:Number = 200; // ms between tilt data readings
		private var myMotionInterval:Number = 1;  // seconds of no motion until stop is determined
		private var loopModulus:Number; 		

        public function PenguinCuddle(
					theView:String = "top",
					theOrientation:String = "vertical",
					theFreedom:String = "two"					
					) {	
		
			trace ("hi from PenguinCuddle");
			
			addEventListener(Event.ENTER_FRAME, getTiltData);
			
			myView = theView;
			myOrientation = theOrientation;
			myFreedom = theFreedom;	
						
			transposeList = dataNames.concat();
			
			myTimer = new Timer(200);
			myTimer.start();
			myTimer.addEventListener(TimerEvent.TIMER, checkEmulator);			
			
			myConnectionSend.addEventListener(StatusEvent.STATUS, onStatus);			
		}
		
		public function checkEmulator(e:TimerEvent) {
			if (!MovieClip.prototype.myXML) {return;}
			myTimer.stop();
			myTimer.removeEventListener(TimerEvent.TIMER, checkEmulator);
			setView(myView);
			setOrientation(myOrientation);
			setFreedom(myFreedom);
			dispatchEvent(new Event(Event.CONNECT));
		}		
		
		private function onStatus(event:StatusEvent):void {
			switch (event.level) {
				case "status" :
					//trace("LocalConnection.send() succeeded");
					break;
				case "error" :
					//trace("LocalConnection.send() failed");
					break;
			}
		}			
		
		public function getTiltData(e:Event) {

			var xmlData:XML;
			if (!MovieClip.prototype.myXML) {return;}
				
			xmlData = XML(MovieClip.prototype.myXML);
			
			view = xmlData.view;
			orientation = xmlData.orientation;			
			roll = xmlData.tilt.@roll;
			pitch = xmlData.tilt.@pitch;
			yaw = xmlData.tilt.@yaw;
			forward = xmlData.translation.@forward;
			right = xmlData.translation.@right;
			down = xmlData.translation.@down;
			tiltUnits = xmlData.tilt.@units;
			translationUnits = xmlData.translation.@units;

			// check for transposition
			if (dataNames.toString() != transposeList.toString()) {
				var len:uint = dataNames.length;
				var orig:Array = [];
				// store the originals
				for (var i:uint = 0; i < len; i++) {
					orig.push(this[dataNames[i]]);
				}
				var val:String;
				var val2:String;
				var sign:Number = 1;
				for (i = 0; i < len; i++) {
					if (dataNames[i] == transposeList[i]) {continue;}
					val = transposeList[i];
					val2 = val.replace(/-\s*/g, "");
					if (val != val2) {
						sign = -1;
					}
					this[dataNames[i]] = sign * orig[dataNames.indexOf(val2)];
				}
			}
			
			// check for motion start and stop
			if (motionState == PenguinPop.MOTION_STOP) {
				if (!compareArray([roll,pitch,yaw,forward,right,down], motionLast)) {
					motionState = PenguinPop.MOTION_START;
					motionCount = 0;					
					dispatchEvent(new Event(PenguinPop.MOTION_START));
				}
				motionLast = [roll,pitch,yaw,forward,right,down];
			} else {
				motionCount++;				
				if (motionCount % loopModulus == 0) {
					if (compareArray([roll,pitch,yaw,forward,right,down], motionLast)) {						
						motionState = PenguinPop.MOTION_STOP;
						dispatchEvent(new Event(PenguinPop.MOTION_STOP));
					}					
					motionLast = [roll,pitch,yaw,forward,right,down];
				}
			}				
			function compareArray(a1,a2) {
				var checkArray:Boolean = true;
				var len:Number = a1.length;
				for (var i:uint=0; i<len; i++) {
					if (a1[i] != a2[i]) {checkArray = false; break;}
				}				
				return checkArray;
			}
											
			dispatchEvent(new Event(Event.CHANGE));
		}
		public function setView(v:String):void {
			myConnectionSend.send("Emulator", "setView", myView);
		}
		public function setOrientation(o:String):void {
			myConnectionSend.send("Emulator", "setOrientation", myOrientation);
		}
		public function setFreedom(f:String):void {
			myConnectionSend.send("Emulator", "setFreedom", myFreedom);
		}		
		
		public function transposeValue(a:String, b:String) {
			// a is the original data which will be changed to b
			// for instance to change pitch to be the value from yaw
			// transpose("pitch", "yaw")
			// this does not swap the values as you will rarely want to do that
			// original data names are pitch roll yaw forward right down
			// you can also change to a negative like so:
			// transpose("pitch","-pitch"); // or transpose("down","-forward");
			// now the transposeList stores the b value
			// that corresponds to the value in the dataNames
			// the transposeList is used to transpose the data in the doTilt function
			transposeList[dataNames.indexOf(a)] = b;
		}		
		
		public function set motionInterval(s:Number):void { // how many seconds does motion have to be the same for MOTION_STOP
			myMotionInterval = s;
			loopModulus = Math.max(1, Math.floor(myMotionInterval * 1000 / period));			
		}
		
		public function get motionInterval():Number {
			return myMotionInterval;
		}		
		
		public function dispose() {
			removeEventListener(Event.ENTER_FRAME, getTiltData);
		}		
		
    }
} 