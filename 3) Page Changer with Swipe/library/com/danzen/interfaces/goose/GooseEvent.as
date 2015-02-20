package com.danzen.interfaces.goose {

	import flash.display.Sprite;
	import flash.display.InteractiveObject;
    import flash.events.*;	
	
    public class GooseEvent extends Event {
		
		public static const TOUCH:String = "touch";
		public static const DOUBLE_TOUCH:String = "doubleTouch"; // not active
		public static const TOUCH_DOWN:String = "touchDown";
		public static const TOUCH_UP:String = "touchUp";
		public static const TOUCH_MOVE:String = "touchMove";
		
		public static const PRESS:String = "press";
		public static const DOUBLE_PRESS:String = "doublePress"; // not active
		public static const PRESS_DOWN:String = "pressDown";
		public static const PRESS_UP:String = "pressUp";
		public static const PRESS_MOVE:String = "pressMove";	
		
		public static const PICK_UP:String = "pickUp"; // for first follow or size
		public static const PUT_DOWN:String = "putDown"; // for last follow or size
		
		public var cursor:Sprite;
		public var cursorZ:Number;
		public var cursorID:String;
		public var obj:InteractiveObject;
		private var t:String;
		private var b:Boolean;
		private var c:Boolean;		
						
		public function GooseEvent(type:String,
								   theCursor:Sprite,								   
								   theCursorZ:Number,
								   theCursorID:String,
								   theObject:InteractiveObject = null,
								   bubbles:Boolean = false,
								   cancelable:Boolean = false) {
			t = type;
			b = bubbles;
			c = cancelable;			
			super (t,b,c);
			cursor = theCursor;	
			cursorZ = theCursorZ;
			cursorID = theCursorID;			
			obj = theObject;
		}
		
		public override function clone():Event {			
			return new GooseEvent(t,cursor,cursorZ,cursorID,obj,b,c);
		}
		
		public override function toString():String {
			return formatToString("GooseEvent","type","theCursor","theCursorZ","theCursorID","theObject","bubbles","cancelable","eventPhase");
		}	

    }
} 

		
		