
package com.danzen.effects.woodpecker {
	
	import flash.events.*
	
	class SoundBeatEvent extends Event {		
		
		public static const PROCESS_SOUND:String = "processsound";
		
		public var processArray:Array;
		private var t:String;
		private var b:Boolean;
		private var c:Boolean;
		
		public function SoundBeatEvent(type:String,
									   theArray:Array,
									   bubbles:Boolean = false,
									   cancelable:Boolean = false) {
			t = type;
			b = bubbles;
			c = cancelable;			
			super (t,b,c);
			processArray = theArray;

		}
		
		public override function clone():Event {
			return new SoundBeatEvent(t,processArray,b,c);
		}
		
		public override function toString():String {
			return formatToString("SoundBeatEvent","type","theArray","bubbles","cancelable","eventPhase");
		}	
	}
}