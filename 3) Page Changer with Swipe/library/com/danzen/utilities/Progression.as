package com.danzen.utilities {
		
	// Progression Class - Dan Zen http://www.danzen.com http://flashfeathers.com
	// Progress animation class to apply load proportion and damping
	
	// Create an Object (such as a MovieClip) to animate your loading progress
	// Decide on a property of that object to animate and set up Progression()
	// ****** To animate a frame number, pass "frameNumber" as a property
	// and use true for the round paramater (see full constructor)
	// ****** To increase or decrease a number in a TextField, pass "text" as a property
	// and use true for the round parameter - and a TextField for the object
	// To animate a bar width assuming we had a MovieClip called holder
	// with a bar clip and a barBox clip then we would use:
	// barProgression = new Progression(holder.bar, "width", 0, holder.barBox.width);
		
	// Use a Flash ProgressEvent to get bytesLoaded and bytesTotal
	// and call the myProgress(yourProgress) method with your progress
	// for example: 
	// myLoader = new Loader(); 
	// myLoader.load(new URLRequest("your swf or image URL"));
	// myLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadCheck);
	// myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadDone);
	// function loadCheck(e:ProgressEvent) {
	// 		if (e.bytesTotal <= 0) {return;}
	// 		loaded = e.bytesLoaded / e.bytesTotal;			
	// 		myProgression.doProgress(loaded); 
	// }	
	
	// you will want to show your content and get rid of your progressObject after like so:
	// function loadDone(e:Event) {
	//		addChild(myLoader);			
	//		barProgression.dispose();
	//		removeChild(holder);
	//		holder = null;
	// }
	
	// make sure that the content you are loading delays its running until it has a stage
	// the only thing in your constructor would be:
	// addEventListener(Event.ADDED_TO_STAGE, init);
	// then after your constructor:
	// private function init(e:Event) {
	// 		// start your code here
	// }
	
		
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.DisplayObject;
	import flash.events.Event;

	public class Progression extends Sprite {

		// constructor parameters
		private var myProgressObject:DisplayObject;
		private var myProperty:String;
		private var myTargetMin:Number;
		private var myTargetMax:Number;
		private var myRound:Boolean; // true to round results to whole number (good if property is frameNumber)
		private var myDamp:Number; // damping can be changed via damp get/set method property
		private var myFactor:Number; // set to 1 for increasing and -1 for decreasing
		private var myBaseMin:Number;
		private var myBaseMax:Number;
		
		// proportion
		private var baseAmount:Number;
		private var proportion:Number;
		private var targetDifference:Number;	
		private var targetAmount:Number;	
		
		// damping			
		private var differenceAmount:Number;
		private var desiredAmount:Number=0;
		private var lastAmount:Number = 0;

		public function Progression (
					theProgressObject:DisplayObject,
					theProperty:String,
					theTargetMin:Number,
					theTargetMax:Number,
					theRound:Boolean=false,
					theDamp:Number=.01,
					theFactor:Number=1,
					theBaseMin:Number=0,
					theBaseMax:Number=1) {
			
			myProgressObject = theProgressObject;
			myProperty = theProperty;
			myTargetMin = theTargetMin;
			myTargetMax = theTargetMax;
			myRound = theRound;
			myDamp = theDamp;
			myFactor = theFactor;
			myBaseMin = theBaseMin;
			myBaseMax = theBaseMax;						
					
			addEventListener(Event.ENTER_FRAME, animate);
			
		}
		
		public function doProgress(theBaseAmount:Number) {	
		
			// call doProgress(percentLoaded) from your ProgressEvent function
			// this will direct the animation to animate your progressObject
			
			baseAmount = theBaseAmount;
		}
		
		private function animate(e:Event) {		
		
			// animate actually sets the property on your progressObject
			// relative to the amount loaded with damping
		
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
			if (myProperty == "frameNumber") {
				MovieClip(myProgressObject).gotoAndStop(lastAmount);
			} else if (myProperty == "text") {
				TextField(myProgressObject).text = String(lastAmount);
			} else {
				myProgressObject[myProperty] = lastAmount;
			}	
			
		}		
		
		public function set damp(n:Number) {
			myDamp = n;
		}
		public function get damp():Number {
			return myDamp;
		}
		
		public function dispose() {
			removeEventListener(Event.ENTER_FRAME, animate);
		}
	}	
}
