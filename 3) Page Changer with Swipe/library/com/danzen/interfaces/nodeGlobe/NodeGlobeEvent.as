package com.danzen.interfaces.nodeGlobe {
	
	import flash.events.*
	
	public class NodeGlobeEvent extends Event {		
		
		public static const NODE_ROLLOVER:String = "nodeRollover";
		public static const NODE_ROLLOUT:String = "nodeRollout";
		public static const NODE_CLICK:String = "nodeClick";
		public static const SPIN_DONE:String = "spinDone";
		
		public var obj:Object;
		public var xml:XML;
		private var t:String;
		private var b:Boolean;
		private var c:Boolean;
		
		public function NodeGlobeEvent(type:String,
									   theObject:Object,
									   theXML:XML,
									   bubbles:Boolean = false,
									   cancelable:Boolean = false) {
			t = type;
			b = bubbles;
			c = cancelable;			
			super (t,b,c);
			obj = theObject;
			xml = theXML;

		}
		
		public override function clone():Event {
			return new NodeGlobeEvent(t,obj,xml,b,c);
		}
		
		public override function toString():String {
			return formatToString("MultipleEaseEvent","type","theObject","theXML","bubbles","cancelable","eventPhase");
		}	
	}
}