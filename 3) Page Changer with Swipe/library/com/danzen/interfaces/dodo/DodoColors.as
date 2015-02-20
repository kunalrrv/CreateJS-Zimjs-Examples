
package com.danzen.interfaces.dodo {
	
	// DODO INTRODUCTION  
	// Dodo lets you track light objects on a dark background or dark objects on a light background
	// It puts blobs where it finds objects
	
	// http://dodoflash.wordpress.com - by inventor Dan Zen - http://www.danzen.com
	// if you are using Dodo for commercial purposes, you are welcome to donate to Dan Zen
	// donations can be made to agency@danzen.com at http://www.paypal.com
	// also be aware that Gesture Tek and perhaps others hold patents in these areas
			
	// FEATURES
	// Dodo generates XML as ManyML and this can be fed to multitouch classes of Goose
	// ManyML - http://manyml.wordpress.com
	// Goose Multitouch for Flash - http://gooseflash.wordpress.com
	// this allows you to pick things up and resize them etc. with multiple fingers or wands
	
	// WORKINGS
	// Dodo uses a threshold system and you can set the sensitivity with DodoConfig
	// if the background is dark and the sensitivity is 5 then anything lighter than middle grey will show
	// if the sensitivity is 2 then it needs to be lighter than light grey (fewer objects)
	// if the sensitivity is 8 then it needs to be lighter than dark grey (more objects)
	
	// COMPARISON
	// the Flash Feathers series also provides Ostrich at http://ostrichflash.wordpress.com
	// Ostrich captures and tracks video motion and also has blobs
	// Ostrich works well under general ambient light as it is locating motion only
	// Dodo does not locate motion but rather opposite shades and thus does not work well under ambient light
	// it is best to have high contrast or at least a solid background 
	// with only the blobs you want to detect being visible
	// as such, if there is too much detected then the recursive calculations bog the application
	
	// PHYSICAL SYSTEMS
	// there are all sorts of multitouch table designs - you can search on YouTube
	// generally, you want a single background with the opposite shade as items of touch
	// so the surface might be a light vellum and then your fingers are dark
	// or make a dark box with a black plastic duotang cover and shine pen lights at it
		
	// INSTALLING CLASSES  
	// suggested installation:
	// create a "classes" folder on your hard drive - for example c:\classes
	// add the classes folder to your Flash class path:
	// Flash menu choose Edit > Preferences > ActionScript - ActionScript 3 Settings 
	// then use the + sign for the source path box to add the path to your classes folder
	// put the provided com/danzen/ directory with its folders and files in the classes folder
	// the readme has more information if you need it

	// USING DODO  
	// please make sure that the following director is in a folder in your class path:
	// com/danzen/interfaces/dodo/
	// see the samples for how to use the Dodo classes
	
	// DodoCamera - sets up the Web cam - macs may need to adjust their active camera setting in Flash
	// DodoBlob - detects for a blob in a single location
	// DodoBlobs - runs a series of DodoBlobs to detect for blobs across the whole camera
	// DodoConfig - sets up a config panel for sensitivity and light or dark background
	// DodoData - outputs location of blobs in ManyML XML format - can use with Goose Multitouch	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.Timer;
	
	public class DodoColors extends Sprite {
		
		// CONSTRUCTOR  
		// DodoColors(theCam:DodoCamera, theResponse:Number=2, theBackground:String="dark", theSensitivity:Number=5):void
		// 		DodoBlobs puts blobs on any non background color
	    // 		You can hide the blobs by not adding them to the stage
		// 		and then you can use their location to trigger interactivity with hitTestPoint(), etc.
		// 		or you can put your own Sprites or MovieClips where the blobs are
		//		a blob Sprite is made for each grid square the DodoBlobs analyze
		//		if there is only background color in a square then the x of the blob is at -2000
		//		
		// 		PARAMETERS:
		//		theCam:DodoCamera - the cam used for motion detection
// 		//		theResponse:Number - from 1-10 default 4.  1 is fast but jumpy - 10 is slow and smooth
		// 		theBackground:String - "light" or "dark" - default dark
		//		theSensitivity:Number - from 0-10 default 5 - higher finds more blobs, lower finds less blobs	
		
		// METHODS (in addition to constructor)
		// dispose():void - stops and removes cursor

		// PROPERTIES  
		// cam:DodoCamera - the cam feed passed to the DodoCursor object
		// response:Number - between 1-10 - cursor is checked each followInterval
		//					 but reported every response number of times
		//					 movement between reports is averaged to smoothen the motion
		// background:String - "light" or "dark" background hence either dark or light blobs expected
		// sensitivity:Number - from 0-10 higher finds more blobs, lower finds less blobs
		// blobs:Array - an array of blob Sprites - so you can get x, y and width, etc.		
				
		// USAGE
		// in your classes you would use:
		//		var myCam:DodoCamera = new DodoCamera(0,0,640,480);
		//		var myBlobs:DodoBlobs = new DodoBlobs(myCam, 2); 
		//		addEventListener(Event.ENTER_FRAME, myFunction);
		//		function myFunction(e:Event) {
		//			var len:Number = myBlobs.blobs.length;
		//			for (var i:uint=0; i<len; i++) {
		//				if (myBlobs.blobs[i].x > -1000) {
		//					trace (i, myBlobs.blobs[i].x, myBlobs.blobs[i].y);
		//				}
		//			}
		//		}					
		
		public var myCamera:DodoCamera;
		public var myCursors:Array = [];	
		private var myGridMotion:Array = [];
		private var myGridLocation:Array = [];
		private var myCursorClips:Array = [];
		private var doneList:Array;
		private var blobList:Array;		
		private var readyCheck:Boolean = false;
		private var mySensitivity:Number;
		private var myResponse:Number;
		private var myBackground:String;
		private var myTimer:Timer;
		
		// ********* max is the dimension of the grid of sensors
		// ********* this checks a grid of 30 x 30 squares
		// ********* and if there are at least 3 (threshold) squares with motion
		// ********* then a blob is placed here
		// ********* reducing the max will reduce processing but only work with larger targets
		private var max:Number = 30;
		private var threshhold:Number = 3;
		private var startDelay:Number = 3; // seconds
				
		public function DodoBlobs(theCam:DodoCamera, theResponse:Number=2, theBackground:String="dark", theSensitivity:Number=5) {			
			
			trace ("hi from DodoBlobs");
			
			myTimer = new Timer(startDelay*1000,1);
			myTimer.addEventListener(TimerEvent.TIMER, function (e:TimerEvent) {readyCheck = true;});
			myTimer.start();
			
			// make a VideoMotionCamera object			
			myCamera = theCam;				

			var temp:DodoBlob;
			var tempSprite:Sprite;
			
			var gridW:Number = myCamera.width / max;
			var gridH:Number = myCamera.height / max;			
			
			for (var i:uint = 0; i<max; i++) {
				for (var j:uint = 0; j<max; j++) {					
					temp = new DodoBlob(myCamera, i*gridW, j*gridH, (i+1)*gridW, (j+1)*gridH, 2, theBackground, 5);
					myCursors.push(temp); 					
					myGridMotion.push(0);
					myGridLocation.push([i*gridW+gridW/2, j*gridH+gridH/2]);
					temp.addEventListener(DodoBlob.MOTION_START, onStart);
					temp.addEventListener(DodoBlob.MOTION_STOP, onStop);
					
					tempSprite = new Sprite;
					tempSprite.graphics.beginFill(0xFF99CC, .6);
					tempSprite.graphics.drawCircle(0,0,100);
					tempSprite.x = -2000;
					addChild(tempSprite);
					myCursorClips.push(tempSprite);			
					
				}
			}			
			sensitivity = theSensitivity;
			response = theResponse;
			background = theBackground;
			
		}
		
		private function onStart(e:Event) {
			myGridMotion[e.target.cursorNum] = 1;			
			analyseGrid();
		}
		
		private function onStop(e:Event) {
			myGridMotion[e.target.cursorNum] = 0;
			analyseGrid();
		}				
		
		
		private function analyseGrid() {
			
			if (!readyCheck) {return;}
			
			//set the grid max to 6 and uncomment this to view this arrangement
			/*myGridMotion = [1,1,0,0,0,0,
							1,1,0,0,0,0,
							0,0,0,0,0,0,
							0,0,0,0,0,0,
							0,0,0,0,1,1,
							0,0,0,0,1,1];*/
			
			
			doneList = [];
			blobList = [];
			
			var gridW:Number = myCamera.width / max;
			var gridH:Number = myCamera.height / max;
			
			var num:Number;
			var m:uint;
			var n:uint;			
			
			function goR(n:Number) {
				var col:Number = n % max + 1;
				if (col+1 > max) {return -1;} else {return n+1;}
			}
			function goL(n:Number) {
				var col:Number = n % max + 1;
				if (col-1 < 1) {return -1;} else {return n-1;}
			}	
			function goB(n:Number) {
				var row:Number = Math.floor(n / max) + 1;				
				if (row+1 > max) {return -1;} else {return n+max;}
			}
			function goT(n:Number) {
				var row:Number = Math.floor(n / max) + 1;				
				if (row-1 < 1) {return -1;} else {return n-max;}
			}				
			function checkAround(n:Number) {
				var newNum:Number;
				var functionList:Array = [goR, goL, goB, goT];
				for (var r:uint=0; r<4; r++) {
					newNum = functionList[r](n);
					if (newNum != -1 && myGridMotion[newNum] == 1 && doneList.indexOf(newNum) == -1) {
						doneList.push(newNum)
						blobList[blobList.length-1].push(newNum);
						checkAround(newNum);
					}
				}
			}			
			
			for (var i:uint = 0; i<max; i++) {
				for (var j:uint = 0; j<max; j++) {
					num = i * max + j;					
					if (myGridMotion[num] == 1 && doneList.indexOf(num) == -1) {					
						blobList.push([num]);
						doneList.push(num);						
						checkAround(num);
					}				
				}				
			}
							
			var e:Number;
			var tX:Number;
			var tY:Number;
			var t:Number;
			var factor:Number = (myCamera.width+myCamera.height)/2/max;
			var blobCursors:Array = [];
			for (var b:uint=0; b<blobList.length; b++) {
				t = blobList[b].length;
				if (t < threshhold) {continue;}
				tX = tY = 0;
				for (e=0; e<t; e++) {
					tX += myGridLocation[blobList[b][e]][0];
					tY += myGridLocation[blobList[b][e]][1];
				}
				// x average, y average, radius average
				blobCursors.push([Math.round(tX / t), Math.round(tY / t), Math.sqrt(t)*factor/2]);
			}
			
			for (var q:uint=0; q<Math.pow(max,2); q++) {				
				myCursorClips[q].x = -2000;
			}
					
			var c:uint;			
			for (c=0; c<blobCursors.length; c++) {				
				myCursorClips[c].width = myCursorClips[c].height = blobCursors[c][2] * 2;
				myCursorClips[c].x = blobCursors[c][0];
				myCursorClips[c].y = blobCursors[c][1];
			}		
			
			
		}
		
		public function get sensitivity():Number {
			return mySensitivity;
		}
		public function get response():Number {
			return myResponse;
		}
		public function get background():String {
			return myBackground;
		}
		public function set background(b:String):void {
			if (b == "dark" || b == "black" || b == "DARK" || b == "BLACK") {
				myBackground = "dark";
			} else {
				myBackground = "light";
			}
			for (var i:uint = 0; i<max*max; i++) {
				myCursors[i].background = myBackground; 					
			}	
		}
		public function set sensitivity(s:Number):void {
			mySensitivity = Math.max(Math.min(10,s),0);			
			for (var i:uint = 0; i<max*max; i++) {
				myCursors[i].sensitivity = mySensitivity; 					
			}						
		}
		public function set response(r:Number) {
			myResponse = Math.max(Math.min(10,r),1);
			for (var i:uint = 0; i<max*max; i++) {
				myCursors[i].response = myResponse; 					
			}		
		}
		
		public function get blobs():Array {
			return myCursorClips;
		}
		
		public function dispose() {
			for (var i:uint = 0; i<max*max; i++) {
				myCursors[i].removeEventListener(DodoBlob.MOTION_START, onStart);
				myCursors[i].removeEventListener(DodoBlob.MOTION_STOP, onStop);
				myCursors[i].dispose();	
				removeChild(myCursorClips[i]);
				delete myCursorClips[i];
			}
			for (i=0; i<max*max; i++) {
				delete myCursors[i];
			}
			myTimer.stop();
			myTimer = null;			
		}	
		
		
	}
	
}