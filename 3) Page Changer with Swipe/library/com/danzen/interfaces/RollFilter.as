package com.danzen.interfaces {

	// adds a filter to an object on rollover and removes it on rollout
	
	// HOW TO INSTALL CLASSES
	// Flash has what are called class paths so it can find classes
	// you should make a folder called classes in a "generic" location on the computer
	// "generic" means do not put the classes folder in the same folder as a specific project
	// once you have made the classes folder - for example c:\classes then add this folder to your class path
	// like so: from the top Flash menu choose Edit > Preferences > ActionScript - ActionScript 3 Settings 
	// then use the + sign for the source path box to add the path to your classes folder
	// people who distribute classes often use the reverse domain technique
	// this allows you to put many people's classes in your classes folder without overwriting other classes
	// com/danzen is how Dan Zen distributes classes		
	// so you should have a com folder in your classes folder and a danzen folder in the com folder
	// folders that contain classes are called packages so com is a package and danzen is a package
	// danzen distributes classes in a variety of packages like utilities, effects, interfaces, etc.
	// any further packages like these should also be added to the danzen package 
	// inside these are the classes (with .as extensions)	
	
	// please make sure that com/danzen/interfaces/RollFilter.as is in a folder in your class path
	

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class RollFilter {
		
		private var myFilter:*;
		private var myObject:MovieClip;
		private var originalButtonMode:Boolean;
		private static var num:Number = 0;
		
		public function RollFilter(theObject:MovieClip, theFilter:*, theButtonMode:Boolean=true) {			
			num++;
			if (num <= 1) {
				trace ("hi from RollFilter");			
			}
			myFilter = theFilter;
			myObject = theObject;
			originalButtonMode = myObject.buttonMode;
			myObject.buttonMode = theButtonMode;
			myObject.addEventListener(MouseEvent.MOUSE_OVER, rOver);
			myObject.addEventListener(MouseEvent.MOUSE_OUT, rOut);
		}
		
		private function rOver(e:MouseEvent):void {
			e.target.filters = [myFilter]
		}
		private function rOut(e:MouseEvent):void {
			e.target.filters = []
		}		
		
		public function dispose():void {
			trace ("by from RollFilter");
			myObject.removeEventListener(MouseEvent.MOUSE_OVER, rOver);
			myObject.removeEventListener(MouseEvent.MOUSE_OUT, rOut);
			myObject.buttonMode = originalButtonMode;
		}
		
	}
}