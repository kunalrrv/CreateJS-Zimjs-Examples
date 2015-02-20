package com.danzen.interfaces {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.TextField;
	
	public class TextScroll extends MovieClip {
		
		// scrolls a text field based on swipe type movement
		private var t:TextField;
		private var startY:Number;
		private var lastY:Number;
		private var startS:Number;	
		private var lastD:Number;
		private var sensitivity:Number; // 1 mobile, .05 web
		
		public function TextScroll(theTextField:TextField, theSensitivity:Number = 1):void {		
			sensitivity = theSensitivity;
			t = theTextField;			
			t.addEventListener(MouseEvent.MOUSE_DOWN, doDown);
			t.addEventListener(Event.CHANGE, testScroll);			
		}	
		
		public function testScroll():Boolean {
			if (t.maxScrollV > 1) {
				return true;
			} else {
				return false;
			}
		}
		
		private function doDown(e:MouseEvent):void {
			lastY = startY = mouseY;
			startS = t.scrollV;			
			t.stage.addEventListener(MouseEvent.MOUSE_MOVE, doScroll);
			t.stage.addEventListener(MouseEvent.MOUSE_UP, doUP);
		}
		private function doScroll(e:MouseEvent):void {			
			var newV:Number = startS - (mouseY-startY)*sensitivity;
			trace (sensitivity, newV);
			t.scrollV = Math.min(t.maxScrollV, Math.max(0, newV));			
		}
		private function doUP(e:MouseEvent):void {
			t.stage.removeEventListener(MouseEvent.MOUSE_MOVE, doScroll);
			t.stage.removeEventListener(MouseEvent.MOUSE_UP, doUP);
		}
	}
}