
package com.danzen.interfaces {
	
	import flash.display.InteractiveObject;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.Regular;
		
	public class PulseFade {
		
		private var myClip:InteractiveObject;
		private var myMax:Number;
		private var myMin:Number;
		private var myPeriod:Number;
		private var myTween:Tween;

		public function PulseFade (
					theClip:InteractiveObject,
					theMax:Number=1,
					theMin:Number=0,
					thePeriod:Number=2) {

			myClip = theClip;
			myMax = theMax;
			myMin = theMin;
			myPeriod = thePeriod;
			myTween = new Tween(myClip, "alpha", Regular.easeInOut, myMax, myMin, myPeriod / 2, true);
			myTween.addEventListener(TweenEvent.MOTION_FINISH, back);
		}
		private function back(e:TweenEvent) {
			myTween.yoyo();
		}
		
		public function dispose() {
			myTween.stop();
			myTween.removeEventListener(TweenEvent.MOTION_FINISH, back);
			myTween = null;
		}		
	}
}