package com.danzen.interfaces {
	
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.events.*;
	
	public class AnimatedScore {
		
		private var myText:TextField
		private var myTimer:Timer;
		private var mySeconds:Number;
		private var difference:Number = 0;
				
		public function AnimatedScore(theText:TextField, theSeconds:Number=.1) {
			// constructor code
			trace ("hi from AnimatedTimer");
			myText = theText;			
			mySeconds = theSeconds;
			myTimer = new Timer(mySeconds * 1000);
			myTimer.addEventListener(TimerEvent.TIMER, doTime);
			myTimer.start();			
		}
		
		private function doTime(e:TimerEvent):void {	
			var newScore:Number;
			if (difference > 0) {
				newScore = Number(myText.text) + 1;				
				difference--;
				myText.text = String(newScore);
			} else if (difference < 0) {
				newScore = Math.max(0, Number(myText.text) - 1);
				difference++;
				myText.text = String(newScore);
			}
							
		}
		
		public function addToScore(n:Number):void {
			difference += n;
		}
		
		public function get total():Number {
			return Math.max(0, Number(myText.text) + difference);
		}

	}
	
}
