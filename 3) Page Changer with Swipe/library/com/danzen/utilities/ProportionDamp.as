package com.danzen.utilities {
		
	// ProportionDamp Class - Dan Zen http://www.danzen.com http://flashfeathers.com
	// adjusts an input value to an output value on a different scale with damping
	
	// put in min and max for the output scale (say volume)
	// put in desired damping with 1 being no damping and .01 being the default
	// put in min and max for the input scale (say x values, 0 and 1 are the defaults)	
		
	// in your own enter frame event function or whatever call convert()
	// pass in your input property (say the mouseX)
	// convert will return the output property with easing (for instance, a volume)	
	
	// the object always starts by assuming baseMin as baseValue.
	// if you want to start or go to an immediate value without easing then
	// call the immediate() method with your desired baseValue (not targetValue)
		
	import flash.display.Sprite;
	import flash.events.Event;

	public class ProportionDamp extends Sprite {

		// constructor parameters
		private var myTargetMin:Number;
		private var myTargetMax:Number;	
		private var myBaseMin:Number;
		private var myBaseMax:Number;						
		private var myDamp:Number; // damping can be changed via damp get/set method property	
		private var myFactor:Number; // set to 1 for increasing and -1 for decreasing
		private var myRound:Boolean; // true to round results to whole number (good if property is frameNumber)
		
		// proportion
		private var baseAmount:Number;
		private var proportion:Number;
		private var targetDifference:Number;	
		private var targetAmount:Number;	
		
		// damping			
		private var differenceAmount:Number;
		private var desiredAmount:Number=0;
		public var lastAmount:Number = 0;

		public function ProportionDamp (
					theTargetMin:Number,
					theTargetMax:Number,		
					theDamp:Number=.01,	
					theBaseMin:Number=0,
					theBaseMax:Number=1,					
					theFactor:Number=1,
					theRound:Boolean=false) {
			
			
			myTargetMin = theTargetMin;
			myTargetMax = theTargetMax;						
			myBaseMin = theBaseMin;
			myBaseMax = theBaseMax;
			myDamp = theDamp;
			myFactor = theFactor;
			myRound = theRound;
			
			baseAmount = myBaseMin; // just start at the min otherwise call immediate(baseValue);
			lastAmount = myTargetMin;					
			
			addEventListener(Event.ENTER_FRAME, calculate);
			
		}
				
		private function calculate(e:Event):void {				
			
			if (isNaN(baseAmount)) {return;}
							
			baseAmount = Math.max(baseAmount, myBaseMin);
			baseAmount = Math.min(baseAmount, myBaseMax);
			proportion = (baseAmount - myBaseMin) / (myBaseMax - myBaseMin);
			targetDifference = myTargetMax - myTargetMin;			
			targetAmount = myTargetMin + myFactor * targetDifference * proportion;
			
			desiredAmount = targetAmount;			
			differenceAmount = desiredAmount - lastAmount;									
			lastAmount += differenceAmount*myDamp;						
			if (myRound) {lastAmount = Math.round(lastAmount);}			
			
		}		
		
		public function immediate(n:Number):void {
			convert(n);
			calculate(null);
			lastAmount = targetAmount;
			if (myRound) {lastAmount = Math.round(lastAmount);}	
		}
		
		public function convert(n:Number):Number {
			baseAmount = n;
			return lastAmount;
		}
		
		public function set damp(n:Number):void {
			myDamp = n;
		}
		public function get damp():Number {
			return myDamp;
		}
		
		public function dispose():void {
			removeEventListener(Event.ENTER_FRAME, calculate);
		}
	}	
}
