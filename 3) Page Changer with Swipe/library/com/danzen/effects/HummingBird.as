package com.danzen.effects {

	// HUMMINGBIRD INTRODUCTION  
	// HummingBird creates a parallax effect on a MovieClip or Sprite
	// http://hummingbirdflash.wordpress.com - by inventor Dan Zen - http://www.danzen.com
	// if you are using HummingBird for commercial purposes, you are welcome to donate to Dan Zen
	// donations can be made to agency@danzen.com at http://www.paypal.com
	
	// INSTALLING CLASSES
	// suggested installation:
	// create a "classes" folder on your hard drive - for example c:\classes
	// add the classes folder to your Flash class path:
	// Flash menu choose Edit > Preferences > ActionScript - ActionScript 3 Settings 
	// then use the + sign for the source path box to add the path to your classes folder	
	// put the provided com/danzen/ directory with its folders and files in the classes folder
	// the readme has more information if you need it

	// USING HUMMINGBIRD
	// make a "holder" MovieClip for instance that has other MovieClips or TextFields, etc. inside it
	// set the z properties of the MovieClips and TextFields
	// in your document class make a new HummingBird Object
	// and pass the holder MovieClip in as the first parameter
	// you should see your content move around to your mouse with a parallax effect	

	// EVENTS  
	// no events
	
	// METHODS  
	// dispose()
		// stop tracking the mouse
	
	// PROPERTIES  
	// shiftX, shiftY, shiftZ : Number
		// how much you are shifting on these axes.
		// can set in constructor
	// damping:Number
		// the damping - .1 is good .01 is slower and .001 is good for sliding sites
		// can set in constructor
	// randomize:Number
		// randomizes motion
		// simulates random clicking from top then middle then top, etc.
		// randomly chooses x position
		// 0 is no random motion, 1 is infrequent clicks and 10 is most frequent
		// good for automatically animating your scene		

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.utils.Timer;
	
	public class HummingBird extends MovieClip {
		
		private var sW:Number;
		private var sH:Number;
		private var startX:Number;
		private var startY:Number;
		private var startZ:Number;
		public var shiftX:Number;
		public var shiftY:Number;
		public var shiftZ:Number;
		public var damping:Number;
		private var mouseDownObject:DisplayObject;
		private var holder:DisplayObject;
		private var mouseCheck:Boolean = false;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		private var myRandomize:Number = 0;
		private var myRandomCount:Number = 0;
		private var mySpeedCount:Number = 0;		
		
	// CONSTRUCTOR  
	// HummingBird(obj:DisplayObject, shiftX:Number, shiftY:Number, shiftZ:Number, damping:Number, mouseDownObject:InteractiveObject):void
	//	constructor to start animating clip to mouse movement
	//	PARAMETERS:
	//		obj:DisplayObject
	//			a MovieClip for instance with clips inside arranged in Z property
	//		shiftX:Number
	//			how much it moves in the x
	//		shiftZ:Number
	//			how much it moves in the Y
	//		shiftY:Number
	//			how much it moves in the Z (up is closer down is farther)
	//		damping:Number
	//			how slowly it follows your mouse - 1 is fast 0 it does not move
	//		mouseDownObject:InteractiveObject
	//			if you want to click and drag to make motion pass in a MovieClip or Sprite
				
				
		public function HummingBird(theObject:DisplayObject, theShiftX:Number=10, theShiftY:Number=10, theShiftZ:Number=10, theDamping:Number=.1, theMouseDownObject:InteractiveObject=null) {
			
			trace ("hi from HummingBird 3a");
			
			holder = theObject;
			shiftX = theShiftX;
			shiftY = theShiftY;
			shiftZ = theShiftZ;
			damping = theDamping;	
			mouseDownObject = theMouseDownObject;
			
			var myTimer:Timer = new Timer(200);			
			myTimer.addEventListener(TimerEvent.TIMER, checkStage);
			myTimer.start();
		}
		private function checkStage(e:TimerEvent) {
			if (!holder.stage) {return;}
			Timer(e.currentTarget).stop();
			holder.stage.scaleMode = StageScaleMode.NO_SCALE;		
			holder.stage.align = StageAlign.TOP_LEFT;			
			sW = holder.stage.stageWidth;
			sH = holder.stage.stageHeight;			
			startX = holder.x;
			startY = holder.y;
			startZ = holder.z;			
			
			holder.stage.addEventListener(Event.ENTER_FRAME, moveScene);
			
			if (mouseDownObject) {				
				mouseDownObject.addEventListener(MouseEvent.MOUSE_DOWN, doMouseDown, false, 0, true);
				mouseDownObject.stage.addEventListener(MouseEvent.MOUSE_UP, doMouseUp, false, 0, true); 
			}
		}			
		
		private function doMouseDown(e:MouseEvent) {
			lastMouseX = mouseX;
			lastMouseY = mouseY; 
			mouseCheck = true;
		}
		
		private function doMouseUp(e:MouseEvent) {
			mouseCheck = false;
		}
						
		private function moveScene(e:Event) {
						
			var proxyDamping:Number;
			if (myRandomize == 0) {
				// mac mouse issue going to other windows!
				if (mouseY > sH * 10 || mouseX > sW * 10) {return;}			
				if (mouseDownObject && isNaN(lastMouseX)) {return;}
				if (!(mouseDownObject && mouseCheck == false)) { 
					// if mouse up needs to glide to last x and y during mouse down				
					if (isNaN(lastMouseX)) {
						lastMouseX = sW/2;
						lastMouseY = sH/2;
					} else {
						lastMouseX = mouseX;
						lastMouseY = mouseY;
					}
				}
				proxyDamping = damping;
			} else { // automatically running with randomize going from 0 (off) to 1 (slow) to 10 (fast)
				
				proxyDamping = .005*Math.pow(myRandomize,1.2);
				
				if (mySpeedCount % Math.floor(600/Math.pow(myRandomize,1.3)) == 0) {
					
				//if (Math.random()*300/myRandomize <= 1) {
					myRandomCount++;
					
					if (myRandomCount%2==0) {
						if (mouseDownObject) {							
							lastMouseY = mouseDownObject.y + Math.random()*mouseDownObject.height/4;
						} else {							
							lastMouseY = Math.random()*holder.stage.stageHeight/4;
						}				
					} else {
						if (mouseDownObject) {
							lastMouseY = mouseDownObject.y + mouseDownObject.height*1/4 + Math.random()*mouseDownObject.height/4;
						} else {
							lastMouseY = holder.stage.stageHeight*1/4 + Math.random()*holder.stage.stageHeight/4;
						}	
					}
					if (mouseDownObject) {
						lastMouseX = mouseDownObject.x + Math.random()*mouseDownObject.width;
					} else {
						lastMouseX = Math.random()*holder.stage.stageWidth;
					}
				}
				mySpeedCount++;
			}
			
			var newX = startX + (lastMouseX - sW/2) / (sW/2) * shiftX;
			var newY = startY + (lastMouseY - sH/2) / (sH/2) * shiftY;
			var newZ = startZ + (lastMouseY - sH/2) / (sH/2) * shiftZ;
			
			var diffX = newX - holder.x;
			var diffY = newY - holder.y;
			var diffZ = newZ - holder.z;
			
			if (Math.abs(diffX) >= 2) {			
				holder.x = holder.x + diffX * proxyDamping; 
			}
			if (Math.abs(diffY) >= 2) {
				holder.y = holder.y + diffY * proxyDamping;
			}
			if (Math.abs(diffZ) >= 2) {
				holder.z = holder.z + diffZ * proxyDamping;
			}
			
			
		}
		
		public function set randomize(n:Number):void {				
			myRandomize = Math.max(Math.min(n,10),0);
			trace (myRandomize)
		}
		
		public function get randomize():Number {
			return myRandomize;
		}
		
		public function dispose() {
			holder.stage.removeEventListener(Event.ENTER_FRAME, moveScene);
		}
	}
}