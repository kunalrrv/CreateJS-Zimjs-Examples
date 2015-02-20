
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

	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.*;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.BlurFilter;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.Timer;
	import flash.events.*
	
	public class DodoBlob extends Sprite {
		
		// *** cursor means blob in the below descriptions - this is modified from the Ostrich Cursor Class
		
		// CONSTRUCTOR  
		// DodoBlob(theCam:DodoCamera, theL:Number=0, theT:Number=0, theR:Number=0, theB:Number=0, theResponse:Number=4, theBackground:String="dark", theSensitivity:Number=5):void
		// 		DodoBlob detects a blob in a specified area of a DodoCamera
		//		It is then used by DodoBlobs to make blobs across the whole camera
		
		// 		PARAMETERS:
		//		theCam:DodoCamera - the cam used for blob detection
		// 		theL:Number - the left side x of the region (with respect to the DodoCam left)
		// 		theT:Number - the top side y of the region (with respect to the DodoCam top)
		// 		theR:Number - the right side x of the region (with respect to the DodoCam left)
		// 		theB:Number - the bottom side y of the region (with respect to the DodoCam top)
		// 		theResponse:Number - from 1-10 default 4.  1 is fast but jumpy - 10 is slow and smooth
		// 		theBackground:String - "light" or "dark" - default dark
		//		theSensitivity:Number - from 0-10 default 5 - higher finds more blobs, lower finds less blobs
		

		// EVENTS 
		// DodoBlob.MOTION_START 	blob first detected 
		// DodoBlob.MOTION_STOP 	blob stopped being detected 
		
		// METHODS (in addition to constructor)
		// dispose():void - stops and removes cursor

		// PROPERTIES  
		// cursorNum:Number - read only - the cursor num starting at 0 
		// cam:DodoCamera - the cam feed passed to the DodoBlob object
		// x:Number - the x position of the cursor - setting this will do you no good ;-)
		// y:Number - the y position of the cursor - setting this will do you no good ;-)
		// response:Number - between 1-10 - cursor is checked each followInterval
		//					 but reported every response number of times
		//					 movement between reports is averaged to smoothen the motion
		// background:String - "light" or "dark" background hence either dark or light blobs expected
		// sensitivity:Number - from 0-10 higher finds more blobs, lower finds less blobs		
		
		// CONSTANTS  
		// MOTION_START:String - static constant (DodoBlob.MOTION_START) for motion start event
		// MOTION_STOP:String - static constant (DodoBlob.MOTION_STOP) for motion stop event
		
		// USAGE
		// used only by DodoBlobs
		
				
		// event constants
		public static const MOTION_START:String = "MotionStart";
		public static const MOTION_STOP:String = "MotionStop";
		
		// static constants and related
		private static var cursorTotal:Number = 0; // keeps track of cursor numbers starting at 0
		private var myCursorNum:Number; // used with getter method at botton of class to return cursorNum
										
		// ********* increasing followInterval will reduce processing
		private var followInterval:Number = 100; // motion checking interval in ms
		
		// various holder variables and checks
		private var myCam:DodoCamera; // the cam instance
		private var motionRectangle:Sprite; // a holder for the motion rectangle (hidden)
		private var myBM:BitmapData; // the frame of motion		
		private var myMatrix:Matrix; // to handle flipping of the camera
		private var rect:Rectangle; // from getColorBoundsRect around motion color between old and new frames		
		private var motionCheck:Boolean = false; // true when motion over an interval based on followInterval * response		
		private var timerFollow:Timer; // interval for testing motion based on followInterval		
		private var timerMoveCursor:Timer; // interval for moving the cursor based on response * followInterval
				
		// these are variables used in the calculations		
		private var cursorSpeed:Number; // the interval the cursor moves based on followInterval * response in ms
		private var regionL:Number; 
		private var regionR:Number;
		private var regionT:Number;
		private var regionB:Number;
		private var regionW:Number;
		private var regionH:Number;
		private var regionR1:Number;
		private var regionR2:Number;
		private var regionT1:Number;
		private var regionT2:Number;
		private var moveX:Number;
		private var moveY:Number;			

		private var motionTally:Number = 0;		
		
		private var myResponse:Number;
		private var mySensitivity:Number;
		private var myBackground:String;

		public function DodoBlob(theCam:DodoCamera, theL:Number=0, theT:Number=0, theR:Number=0, theB:Number=0, theResponse:Number=4, theBackground:String="dark", theSensitivity:Number=5) {	
			
			if (cursorTotal == 0) {trace ("hi from DodoBlob");}		
			
			myCursorNum = cursorTotal++; // which means cursorNum starts at 0
								
			myCam = theCam;
			background = theBackground;
			sensitivity = theSensitivity;
			
			// this interval reports any motion collected by the tests
			// it operates on an interval of the response times the followInterval
			// it acts to make the blobs less jumpy but then also less responsive
			timerMoveCursor = new Timer(theResponse * followInterval);
			timerMoveCursor.addEventListener(TimerEvent.TIMER, moveCursor);
			timerMoveCursor.start();			
			
			response = theResponse;
			
			// create a sprite that will hold the overall motion rectangle that the cursor follows
			motionRectangle = new Sprite();
			addChild(motionRectangle);
							
			// set the region in which the cursor will work			
			regionL = theL; 
			regionT = theT;
			regionR = (theR != 0) ? theR : theL + myCam.width; 			
			regionB = (theB != 0) ? theB : theT + myCam.height; 
			
			if (theCam.camCheck) { // double check the camera is ready
				init();
			} else {
				trace ("--------------------------------");
				trace ("please call the DodoBlob(s) class");
				trace ("after using an DodoCamera.READY event");
				trace ("--------------------------------");				
			}
		}
			
		private function init() {
			
			if (cursorTotal == 0) {trace ("hi from DodoBlob");}					
												
			// get the width and height of the region to draw
			regionW = regionR - regionL;  
			regionH = regionB - regionT;
						
			// here we figure out translations required to capture our rectangle			
			if (myCam.myFlip) {								
				moveX = myCam.width - regionR;
				moveY = regionT;				
			} else {							
				moveX = regionL;
				moveY = regionT;				
			}
			
			// set up the matrix to capture our region later on
			myMatrix = new Matrix();					
			myMatrix.translate(-moveX, -moveY);
						
			// prepare bitmap object to store the current video frames			
			myBM = new BitmapData(regionW, regionH, false);					
			
			// this interval runs the function follow every followInterval milliseconds
			// follow puts a rectangle around motion			
			timerFollow = new Timer(followInterval);
			timerFollow.addEventListener(TimerEvent.TIMER, follow);
			timerFollow.start();
			
		}				
			
		private function follow(c) {		
											
			// We then draw what is currently on the camera over top of the old frame
			// As we are specifying using the difference filter, any pixels of the new
			// frame that have the same color as the old frame will have a difference of zero
			// zero means black and then every where that is not black will be some color
			myBM.draw(myCam.cam,myMatrix,null); 
								
			// We apply the contrast color filter from the DodoCamera to focus in on our motion
			myBM.applyFilter(myBM,myBM.rect,new Point(0,0),myCam.cm);
						
			// We apply the blur filter from the DodoCamera to smoothen our motion region
			myBM.applyFilter(myBM,myBM.rect,new Point(0,0),myCam.bf);
									
			// the higher the sensitivity the more it picks up
			
			var myColor:Number;
			if (myBackground == "dark") {				
				myColor = (10-sensitivity) / 10 * 0xFFFFFF;
				myBM.threshold(myBM,myBM.rect,new Point(0,0),">",myColor,0xFF00FF00,0x00FFFFFF);
			} else {				
				myColor = sensitivity / 10 * 0xFFFFFF;   
				myBM.threshold(myBM,myBM.rect,new Point(0,0),"<",myColor,0xFF00FF00,0x00FFFFFF);
			}
			
			// Below we get a rectangle that encompasses the color (second number)
			// the first number is a mask (confusing because it deals with bitwise operators)
			// true means a rectangle around the color - false means a rectangle not around the color
			
			rect = myBM.getColorBoundsRect(0x00FFFFFF,0xFF00FF00,true);
			if (rect.width > 0) {
				motionTally++;		
			}	
			
		}	
		

		private function moveCursor(c) {			
			
			// handle checking for any motion				
			if (motionTally > 0 && motionCheck == false && myCam.camCheck) {
				motionCheck = true;
				dispatchEvent(new Event(DodoBlob.MOTION_START, true));
			} else if (motionTally == 0 && motionCheck && myCam.camCheck) {
				motionCheck = false;
				dispatchEvent(new Event(DodoBlob.MOTION_STOP, true));	
			}	
			motionTally = 0;			
			
		}		
		
		
		// these getter setter methods prevent the cursorNum from being set
		public function get cursorNum() {return myCursorNum;}
		public function set cursorNum(t) {trace ("cursorNum is read only");}
		
		// these getter setter methods prevent the cam from being set
		public function get cam() {return myCam;}
		public function set cam(t) {trace ("cam is read only");}		
		
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
			if (b == "dark" || b == "black") {
				myBackground = "dark";
			} else {
				myBackground = "light"
			}	
		}
		public function set sensitivity(s:Number):void {
			mySensitivity = Math.max(Math.min(10,s),0);									
		}
		public function set response(r:Number) {
			myResponse = Math.max(Math.min(10,r),1);
			cursorSpeed = myResponse * followInterval;	
			timerMoveCursor.delay = cursorSpeed;
		}					
		
		public function dispose() {
			if (timerFollow) {timerFollow.stop();}
			if (timerMoveCursor) {timerMoveCursor.stop();}
		}				
				
	}
	
}