package com.danzen.interfaces
{
	// class to press number in label and roll to right or left to increase or decrease number 
	// rounds the number to a whole number and dispatches an Event.CHANGE when number changes
	// set value, maxNumber, minNumber, active, sensitivity (gets /100) and you can dispose()
	// active = true or false adds or removes event listeners but can always have a value 
	// Dan Zen http://www.danzen.com (used with Flex)
	
	import flash.events.*;
	
	import spark.components.Label;
	import flash.filters.GlowFilter;
	
	public class NumberPresserFlex extends Label
	{
		private var currentNumber:Label;
		private var currentNumberStart:Number;
		private var currentNumberAmount:Number;
		private var currentNumberWhole:Number;
		private var startNumber:Number;
		
		private var myValue:Number;
		private var myMaxNumber:Number;
		private var myMinNumber:Number = 0;
		private var myActive:Boolean;
		private var mySensitivity:Number;
		private var rollState:Boolean
		private var changedCheck:Boolean = false;
		
		public var num:int; // if you want you can set the num to some int
		
		public function NumberPresserFlex(theMaxNumber:Number=999, theMinNumber:Number=0, theActive:Boolean=true, theSensitivity:Number=17){
			super();
			maxNumber = theMaxNumber;
			minNumber = theMinNumber;			
			sensitivity = theSensitivity;
			if (sensitivity == 0) {sensitivity = 1;}
			active = theActive;
		}
			
		private function numberOn(e:MouseEvent):void {
			addEventListener(Event.ENTER_FRAME, numberMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, numberOff);
			currentNumber = Label(e.target);
			currentNumberStart = mouseX;
			startNumber = currentNumberAmount = currentNumberWhole = Number(currentNumber.text);
			rollState = true;
			filters = [new GlowFilter(0xffffff, 1, 27, 27, 1.7, 3, true)];
			//blendMode = "subtract";
			
		}
		private function numberMove(e:Event):void {				
			currentNumberAmount	= startNumber + (mouseX-currentNumberStart) / sensitivity;
			currentNumberAmount = Math.max(Math.min(myMaxNumber, currentNumberAmount), myMinNumber);
			var newNumber:Number = Math.floor(currentNumberAmount);
			if (newNumber != currentNumberWhole) {
				value = currentNumberWhole = newNumber;				
				dispatchEvent(new Event(Event.CHANGE));
				changedCheck = true;
			}
		}
		
		/*private function numberMove(e:Event):void {				
			currentNumberAmount	+=mySensitivity*(mouseX-currentNumberStart);
			currentNumberAmount = Math.max(Math.min(myMaxNumber, currentNumberAmount), myMinNumber);
			var newNumber:Number = Math.floor(currentNumberAmount);
			if (newNumber != currentNumberWhole) {
				value = currentNumberWhole = newNumber;				
				dispatchEvent(new Event(Event.CHANGE));
				changedCheck = true;
			}
		}*/
		
		
		private function numberOff(e:MouseEvent):void {
			removeEventListener(Event.ENTER_FRAME, numberMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, numberOff);
			rollState = false;
			if (changedCheck) {
				dispatchEvent(new Event(Event.COMPLETE));
				changedCheck = false;
			}
			filters = [];
			//blendMode = "normal";
		}			
		public function set maxNumber(n:Number):void {
			if (n < myMinNumber) {
				myMaxNumber = myMinNumber;
				myMinNumber = n;				
			} else {
				myMaxNumber = n;
			}
		}
		public function get maxNumber():Number {
			return myMaxNumber;
		}
		public function set minNumber(n:Number):void {
			if (n > myMaxNumber) {
				myMinNumber = myMaxNumber;
				myMaxNumber = n;				
			} else {
				myMinNumber = n;
			}
		}
		public function get minNumber():Number {
			return myMinNumber;
		}
		public function set sensitivity(n:Number):void {
			mySensitivity = n / 500;
		}
		public function get sensitivity():Number {
			return mySensitivity * 500;
		}	
		public function set value(n:Number):void {
			if (n < 0) {
				if (text != "") {active = false;}
				text = "";
			} else {
				if (text == "") {active = true;}
				myValue = Math.round(Math.max(Math.min(myMaxNumber, n), myMinNumber));
				text = String(myValue);
			}
		}
		public function get value():Number {
			return myValue;
		}	
		public function set active(t:Boolean):void {
			if (t != myActive) {
				myActive = t;
				dispose();
				if (myActive) {
					addEventListener(MouseEvent.MOUSE_DOWN, numberOn);
				}
			}
		}
		public function get active():Boolean {
			return myActive;
		}	
		public function dispose():void {
			if (rollState) {
				removeEventListener(Event.ENTER_FRAME, numberMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP, numberOff);
			}
			removeEventListener(MouseEvent.MOUSE_DOWN, numberOn);
		}
		
	}
}