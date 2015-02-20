
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
	import flash.filters.ColorMatrixFilter;
	import flash.filters.BlurFilter;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.Timer;
	import flash.events.*

		
	public class DodoCamera extends Sprite {		

	// CONSTRUCTOR  
	// OstrichCamera(theL:Number=0, theT:Number=0, theR:Number=640, theB:Number=480, theFlip:Boolean=true):void
	// this class captures the camera and stores it in a cam Video object
	// it flips the camera so you can match your motion like a mirror
	// you can use this class without adding it to the stage with addChild()
	// or you can add it and set the alpha or the visible as desired
	//  just use once and then all Dodo objects can use it to capture motion
	//
	// PARAMETERS:
	// theL:Number - the left side x of the camera
	// theT:Number - the top side y of the camera
	// theR:Number - the right side x of the camera
	// theB:Number - the bottom side y of the camera
	// theFlip:Boolean - do you want to flip the camera

	// EVENTS 
	// DodoCamera.READY - the camera is on and ready for motion capture 
	// DodoCamera.NO_CAMERA - called if there is no camera to start
	
	// METHODS (in addition to constructor)
	// dispose():void
	// stops camera - then can remake with different size if desired

	// PROPERTIES  
	// camNum:Number - the cam num starting at 0 
	// camCheck:Boolean - a Boolean used as a safeguard by other Ostrich classes
	// left, right, top and bottom:Number - read only - what was sent in as object was created
	// but it extends a sprite so there is alpha, visible, etc.
	// flip:Boolean - read only

	// CONSTANTS  
	// READY:String - static constant (DodoCamera.READY) for camera ready event
	// NO_CAMERA:String - static constant (DodoCamera.NO_CAMERA) for no camera at start
		
		
		public static const READY:String="ready";
		public static const NO_CAMERA:String="noCamera";
		public var cam:Video;// the cam instance
		public var signal:Camera;// the camera signal
		// there are more public properties (getter/setter) down below
		
		// static constants and related
		private static var camTotal:Number=0;// keeps track of cam numbers starting at 0
		private var myCamNum:Number;// used with getter method at botton of class to return cursorNum
		internal var myFlip:Boolean;
		
		internal var cm:ColorMatrixFilter;// a color matrix
		internal var bf:BlurFilter;// a blur filter
		internal var camCheck:Boolean=false;// use the DodoCursor.READY event instead!

		private var timerCheckStart:Timer;// timers to check the availability of the camera
		private var timerCheckStart2:Timer;
		private var myTimer:Timer; // delay for camera list check

		public function DodoCamera(theL:Number=0, theT:Number=0, theR:Number=640, theB:Number=480, theFlip:Boolean=true) {
				
			if (camTotal==0) {
				trace("hi from DodoCamera");
			}
			
			myCamNum=camTotal++; // which means camNum starts at 0
			cam = new Video(theR-theL, theB-theT);
						
			cam.x=theL;
			cam.y=theT;
			myFlip = theFlip;
					
			myTimer = new Timer(200, 1);
			myTimer.addEventListener(TimerEvent.TIMER, init);
			myTimer.start();						
		}
		
		private function init(e:TimerEvent) {
			
			if (Camera.names.length == 0) {
				dispatchEvent(new Event(DodoCamera.NO_CAMERA));				
				return;
			}
			
			var macCamera:Number = -1;
			for (var i:uint=0; i<Camera.names.length; i++) {				
				if (Camera.getCamera(String(i)).name == "USB Video Class Video") {
					macCamera = i; 
					break;
				}
			}
	
			if (macCamera >= 0) {
				signal = Camera.getCamera(String(macCamera));
			} else {
				signal = Camera.getCamera();
			}
			signal.setMode(cam.width, cam.height, 30);
			cam.attachCamera(signal);
			addChild(cam);
			
			if (myFlip) {
				// flip the cam instance around to get a mirror effect
				// need to also accomodate for this in cursor class
				cam.scaleX=-1;
				cam.x+=cam.width;
			}
			
			// need to find out when camera is active and set small delay to avoid motion trigger at start
			// can't use status because it does not trigger when camera is automatically accepted
			// set a check every 200 ms to see if camera is accepted
			// once it is accepted, set a delay of 1000 ms until we start checking for motion with camCheck
			timerCheckStart=new Timer(200);
			timerCheckStart.addEventListener(TimerEvent.TIMER, startStopEvents);
			timerCheckStart.start();
			timerCheckStart2=new Timer(1000,1);
			timerCheckStart2.addEventListener(TimerEvent.TIMER, startStopEvents2);
			function startStopEvents(e:TimerEvent) {
				if (! signal.muted) {
					timerCheckStart.stop();
					timerCheckStart2.start();
				}
			}

			function startStopEvents2(e:TimerEvent) {
				camCheck=true;
				dispatchEvent(new Event(DodoCamera.READY, true));
			}

			// set up some filters for better motion detection
			// we will apply these in the cursor classes
			
			// first we set up a color matrix filter to up the contrast of the image
			// to do this we boost each color channel then reduce overall brightness
			// we create a color matrix that will boost each color (multiplication)
			// and then drop the brightness of the channel (addition)
			
			var boost:Number = 4; //3
			var brightness:Number = -50; //-60;
			var cmArray:Array = [
				boost,0,0,0,brightness,	
				0,boost,0,0,brightness,
				0,0,boost,0,brightness,
				0,0,0,1,0
			];			
	
			// create a new colorMatrixFilter so that we can apply our color matrix
			cm = new ColorMatrixFilter(cmArray);		
			
			// set up a blur filter to help emphasize areas of change
			bf = new BlurFilter(16,16,2);			

		}

		// these getter setter methods prevent the camNum from being set
		public function get camNum() {
			return myCamNum;
		}
		public function set camNum(t) {
			trace("camNum is read only");
		}

		// these getter setter methods prevent the dimensions from being set
		public function get left() {
			return cam.x;
		}
		public function set left(t) {
			trace("left is read only - dispose() and recreate class if changes are needed");
		}
		public function get right() {
			return cam.x + cam.width;
		}
		public function set right(t) {
			trace("right is read only - dispose() and recreate class if changes are needed");
		}
		public function get top() {
			return cam.y;
		}
		public function set top(t) {
			trace("top is read only - dispose() and recreate class if changes are needed");
		}
		public function get bottom() {
			return cam.y+cam.height;
		}
		public function set bottom(t) {
			trace("bottom is read only - dispose() and recreate class if changes are needed");
		}
		public function get flip() {
			return myFlip;
		}
		public function set flip(t) {
			trace("flip is read only - dispose() and recreate class if changes are needed");
		}

		public function dispose() {
			if (timerCheckStart) {
				timerCheckStart.stop();
			}
			if (timerCheckStart2) {
				timerCheckStart2.stop();
			}
			removeChild(cam);
		}
	}
}