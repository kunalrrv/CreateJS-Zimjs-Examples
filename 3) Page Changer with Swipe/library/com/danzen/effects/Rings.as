package com.danzen.effects {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public dynamic class Rings extends MovieClip {
		
		private var myRadius:Number;
		private var myColors:Array;
		private var myNumber:Number;
		private var myTimer:Timer;
		private var myBorderColor:Number;
		
		public static const DISOLVED:String = "disolved";
				
		public function Rings(theRadius:Number=100, theColors:Array=null, theNumber:Number=1, theBorderColor:Number=-1) {
			// constructor code
			trace ("hi from Rings");
			myRadius = theRadius;
			myColors = (theColors != null) ? theColors : [0x000000];
			myNumber = Math.max(1, Math.min(theNumber, myColors.length));
			myBorderColor = theBorderColor;
			myTimer = new Timer(100,10); // for disolving rings
			myTimer.addEventListener(TimerEvent.TIMER, removeOuterRing);
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, ringsRemoved);
			drawRings(1);
		}		
		
		public function drawRings(num:Number):void { 
			//numRings = Math.max(0, Math.min(num, myColors.length));			
			myNumber = Math.min(num, myColors.length);
			myNumber = Math.max(1, myNumber);
			graphics.clear();
			if (myBorderColor>=0) {	
				var col:Number = ((myColors[0] & 0x7E7E7E) >> 1) | (myColors[0] & 0x808080);
				//var col:Number = (myColors[0] & 0xfefefe) >> 1;
				graphics.beginFill(col);
				graphics.drawCircle(0,0,myRadius);
			}			
			for (var i:uint=0; i<myNumber; i++) {				
				graphics.beginFill(myColors[i]);	
				if (myBorderColor>=0) {
					graphics.drawCircle(0,0,(myRadius-2)*(myNumber-i)/myNumber);
				}  else {
					graphics.drawCircle(0,0,myRadius*(myNumber-i)/myNumber);
				}
			}				
		}
		
		public function drawRingsReverse(num:Number):void { 						
			myNumber = Math.min(num, myColors.length);
			myNumber = Math.max(1, myNumber);
			graphics.clear();
			for (var i:uint=0; i<myColors.length; i++) {	
				if (i >= myColors.length-myNumber) {
					graphics.beginFill(myColors[i]);			
					graphics.drawCircle(0,0,myRadius*(myColors.length-i)/myColors.length);
				}
			}			
			
		}
		
		public function disolve():void {
			myTimer.reset();
			myTimer.start();
		}
		
		private function removeOuterRing(e:TimerEvent):void {
			drawRingsReverse(myNumber-1);
		}
				
		private function ringsRemoved(e:TimerEvent):void {
			dispatchEvent(new Event(Rings.DISOLVED));
		}
		
		public function addRing():void {
			drawRings(myNumber+1);
		}
		
		public function removeRing():void {
			drawRings(myNumber-1);
		}
		
		public function set radius(r:Number):void {
			myRadius = r;
			drawRings(myNumber);
		}
		
		public function get radius():Number {
			return myRadius;			
		}
		
		public function set colors(c:Array):void {
			myColors = c;
			drawRings(myNumber);
		}
		
		public function get colors():Array {
			return myColors;			
		}
		
		public function set number(n:Number):void {
			myNumber = Math.max(0, Math.min(n, myColors.length));
			drawRings(myNumber);
		}
		
		public function get number():Number {
			return myNumber;			
		}
		
	}
	
}
