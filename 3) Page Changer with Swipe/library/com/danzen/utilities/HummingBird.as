package com.danzen.utilities {

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

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class HummingBird extends MovieClip {
		
		private var sW:Number;
		private var sH:Number;
		private var startX:Number;
		private var startY:Number;
		private var startZ:Number;
		private var shiftX:Number;
		private var shiftY:Number;
		private var shiftZ:Number;
		private var damping:Number;
		private var holder:DisplayObject;
		
		public function HummingBird(theObject:DisplayObject, theShiftX:Number=10, theShiftY:Number=10, theShiftZ:Number=10, theDamping:Number=.1) {
			
			trace ("hi from HummingBird");	
			
			holder = theObject;
			shiftX = theShiftX;
			shiftY = theShiftY;
			shiftZ = theShiftZ;
			damping = theDamping;	
					
			holder.stage.addEventListener(Event.ENTER_FRAME, moveScene);
			sW = holder.stage.stageWidth;
			sH = holder.stage.stageHeight;
			startX = holder.x;
			startY = holder.y;
			startZ = holder.z;			
		}			
			
		private function moveScene(e:Event) {
			
			var newX = startX + (mouseX - sW/2) / (sW/2) * shiftX;
			var newY = startY + (mouseY - sH/2) / (sH/2) * shiftY;
			var newZ = startZ + (mouseY - sH/2) / (sH/2) * shiftZ;
			
			var diffX = newX - holder.x;
			var diffY = newY - holder.y;
			var diffZ = newZ - holder.z;
			
			if (Math.abs(diffX) >= 2) {			
				holder.x = holder.x + diffX * damping; 
			}
			if (Math.abs(diffY) >= 2) {
				holder.y = holder.y + diffY * damping;
			}
			if (Math.abs(diffZ) >= 2) {
				holder.z = holder.z + diffZ * damping;
			}
			
		}
		
		private function dispose() {
			holder.stage.removeEventListener(Event.ENTER_FRAME, moveScene);
		}
	}
}