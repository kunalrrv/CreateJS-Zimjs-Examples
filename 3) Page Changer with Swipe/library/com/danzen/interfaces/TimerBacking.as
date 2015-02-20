package com.danzen.interfaces {
	
	import flash.display.Sprite;
	import flash.utils.Timer;
	import flash.events.*;
	
	public class TimerBacking extends Sprite {
		
		public static const RIGHT_LEFT:String = "rightLeft"; // there would be other directions
		public static const TIME_COMPLETE:String = "timeComplete";
		private var myStage:Object;
		private var myTime:Number;
		private var myInterval:Number = 1000;
		private var w:Number;
		private var h:Number;
		private var c:Number;
		private var d:String;
		private var myTimer:Timer;
		private var dirX:Number;
		private var dirY:Number;
		
		
		private var steps:Number;
		private var distance:Number;
		
		public function TimerBacking(theStage:Object, theTime:Number, theInterval:Number, theWidth:Number, theHeight:Number, theColor:Number=0x000000, theDirection:String=TimerBacking.RIGHT_LEFT) {
			// constructor code
			trace ("hi from TimerBacking");
			
			myStage = theStage;			
			myTime = theTime;
			myInterval = theInterval;
			w = theWidth;
			h = theHeight;
			c = theColor;
			d = theDirection;
			
			steps = myTime / myInterval;			
			myTimer = new Timer(myInterval, steps-1);
			myTimer.addEventListener(TimerEvent.TIMER, animate);
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, done);
			myTimer.start();			
			
			if (d == TimerBacking.RIGHT_LEFT) {
				doRightLeft();
			}
			
			graphics.beginFill(c);
			graphics.drawRect(0,0,w,h);
			
		}
		
		private function doRightLeft():void {
			x = w;
			distance = w / steps;
			dirX = -1;
			dirY = 0;
		}
		
		private function animate(e:TimerEvent):void {
			x += dirX*distance;
			y += dirY*distance;
		}
		
		private function done(e:TimerEvent):void {
			x = 0;
			y = 0;
			dispatchEvent(new Event(TimerBacking.TIME_COMPLETE));
		}
		
		public function dispose():void {
			myTimer.removeEventListener(TimerEvent.TIMER, animate);
			myTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, done);
			graphics.clear();
		}
		

	}
	
}
