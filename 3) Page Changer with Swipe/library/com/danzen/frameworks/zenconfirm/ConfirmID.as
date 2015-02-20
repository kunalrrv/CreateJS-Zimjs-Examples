package com.danzen.frameworks.zenconfirm
{
	// ConfirmID is a wrapper for a shared object to store and retrieve the App user id
	
	import com.danzen.utilities.Falcon;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.SharedObject;
	
	public class ConfirmID extends Sprite
	{
		private var localSO:SharedObject;
		public var data:Object;
		public var error:String;
		
		public function ConfirmID(theLocalScope:String)
		{
			trace ("hi from ConfirmID");
			localSO = SharedObject.getLocal(theLocalScope, "/");					
		}
		public function get id():Object {
			return localSO.data.id;
		}
		public function set id(theID:Object):void {
			localSO.data.id = theID;			
		}
		public function randomID(n:Number=10000000000):Number {
			return Math.round(Math.random()*n);
		}
		public function record(url:String, obj:Object):void {
			// if you want you can send some data to a server script - like recording the id
			var myFalcon:Falcon = new Falcon(url, Falcon.VARIABLES, obj);
			myFalcon.addEventListener(Event.COMPLETE, recorded);
		}
		private function recorded(e:Event):void {
			// any variables coming back from the server script is stored in data as properties
			error = e.target.error;
			data = e.target.data;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		public function clear():void {			
				localSO.data.id = null;			
		}
	}
}