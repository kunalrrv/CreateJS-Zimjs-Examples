package com.danzen.effects {
	
	import flash.events.*
	
	public class MultipleEaseEvent extends Event {		
		
		public static const COMPLETE:String = "complete";
		
		public var object:Object;
		public var x:Number;
		public var y:Number;
		private var t:String;
		private var b:Boolean;
		private var c:Boolean;
		
		public function MultipleEaseEvent(type:String,
									   theObject:Object,
									   theX:Number,
									   theY:Number,
									   bubbles:Boolean = false,
									   cancelable:Boolean = false) {
			t = type;
			b = bubbles;
			c = cancelable;			
			super (t,b,c);
			object = theObject;
			x = theX;
			y = theY;

		}
		
		public override function clone():Event {
			return new MultipleEaseEvent(t,object,x,y,b,c);
		}
		
		public override function toString():String {
			return formatToString("MultipleEaseEvent","type","theObject","theX","theY","bubbles","cancelable","eventPhase");
		}	
	}
}