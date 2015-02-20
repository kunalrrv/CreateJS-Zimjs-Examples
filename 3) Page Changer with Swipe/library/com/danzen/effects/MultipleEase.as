package com.danzen.effects {
	
	import flash.display.Sprite;
	import flash.events.Event;	
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class MultipleEase extends Sprite {
		
		// MultipleEase - Dan Zen 2011 - free to use
		// create a MultipleEase object and pass to it the easing (.1 default)
		// also pass to it a removeDelay value in milliseconds (1000 default)
		// we wait this amount of time before triggering a COMPLETE event
		// when there is no change in the object's position.
		
		// pass to the doEasing() multiple objects and their desired locations:
		// in an enterFrame event call doEasing(theInfo:Array)
		// and pass in an array of arrays as follows:
		// [[object, desiredX, desiredY], [object, desiredX, desiredY]];
		// this method will return the eased values in the same format
		// class is set up to do x and y positions but could do rotation for instance
		// just pass rotation in for x and 0 in for y 
		
		// dispatches a MultipleEaseEvent.COMPLETE when any easing is done
		// this has an object property and an x and y property for that object
		// note: the object is not returned in array received from doEase()
		
		// you can then choose to remove the object that has finished easing
		// or you can move it to the x and y and then send its data back into doEase()
		// an object at rest will trigger this event constantly but such is life
		
		private var ease:Number; // damping
		private var delay:Number; // delay in issuing change COMPLETE event
				
		// an object with objects as keys rather than strings as keys
		private var dict:Dictionary = new Dictionary(true);
		// store which objects belong to which timers
		private var timers:Dictionary = new Dictionary(true);
		
		public function MultipleEase (theEase:Number=.1, theDelay:Number=1000) {
			trace ("hi from MultipleEase");			
			
			ease = theEase;		
			delay = theDelay;
					
			addEventListener(Event.ENTER_FRAME, animate);			
		}
		
		public function doEasing(info:Array):Array {
			
			var timer:Timer;
			for (var i:uint=0; i<info.length; i++) {
				if (!dict[info[i][0]]) {					
					timer = new Timer(delay,1);
					timer.addEventListener(TimerEvent.TIMER, doTimer);
					timers[timer] = info[i][0];
					// [desiredX, desiredY, lastX, lastY, timer, timerActive]
					dict[info[i][0]] = [info[i][1], info[i][2], info[i][1], info[i][2], timer, false];
				} else {
					// already exists so just update the desired values
					dict[info[i][0]][0] = info[i][1];
					dict[info[i][0]][1] = info[i][2];
				}			
			}
			var newPositions:Array = [];
			for (var obj:Object in dict) {
				newPositions.push([obj, dict[obj][2], dict[obj][3]]);
			}			
			return newPositions;
		}
		
		private function animate(e:Event):void {
			
			var differenceX:Number;
			var differenceY:Number;
			
			for (var obj:Object in dict) {
				differenceX = dict[obj][0] - dict[obj][2];
				differenceY = dict[obj][1] - dict[obj][3];
				
				// handle no movement delay response
				if (Math.abs(differenceX) < .5 && Math.abs(differenceY) < .5) {
					if (!dict[obj][5]) {
						dict[obj][4].start(); // start timer
						dict[obj][5] = true;
					}					
				} else {
					if (dict[obj][5]) {
						dict[obj][4].reset();
						dict[obj][5] = false;
					}
				}
				
				dict[obj][2] += differenceX * ease;	
				dict[obj][3] += differenceY * ease;				
			}			
		}
		
		private function doTimer(e:TimerEvent):void {
			var obj:Object = timers[e.currentTarget];
			dispatchEvent(new MultipleEaseEvent(MultipleEaseEvent.COMPLETE, obj, dict[obj][2], dict[obj][3]));
			delete timers[e.currentTarget];
			delete dict[obj];
		}
		
		private function dispose():void {
			removeEventListener(Event.ENTER_FRAME, animate);
			timers = null;
			dict = null;			
		}
						
	}

}