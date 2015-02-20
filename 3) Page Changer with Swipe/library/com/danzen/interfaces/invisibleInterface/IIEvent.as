package com.danzen.interfaces.invisibleInterface {

    import flash.events.*;	
	
    public class IIEvent extends Event {
		
		public static const PRESS:String = "press";
		
		public var grid:String;
		public var num:Number;
		private var t:String;
		private var b:Boolean;
		private var c:Boolean;		
						
		public function IIEvent(type:String,	
								   theGrid:String,
								   theNum:Number,
								   bubbles:Boolean = false,
								   cancelable:Boolean = false) {
			t = type;
			b = bubbles;
			c = cancelable;			
			super (t,b,c);
			grid = theGrid;
			num = theNum;
		}
		
		public override function clone():Event {			
			return new IIEvent(t,grid,num,b,c);
		}
		
		public override function toString():String {
			return formatToString("IIEvent","type","theGrid","theNum","bubbles","cancelable","eventPhase");
		}	

    }
} 

		
		