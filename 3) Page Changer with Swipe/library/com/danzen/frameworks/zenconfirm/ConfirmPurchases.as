package com.danzen.frameworks.zenconfirm
{
	// Purchases is a wrapper for shared objects to store purchase ids and goods associated with the purchase
	// Global scope is so that one purchase id is unique for all products to stop parallel manipulation
	// Local scope is where the goods can be tracked
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.SharedObject;
	
	public class ConfirmPurchases extends Sprite
	{
		public var data:Object = {};
		private var globalSO:SharedObject;
		private var localSO:SharedObject;
		
		public function ConfirmPurchases(theGlobalScope:String, theLocalScope:String)
		{
			trace ("hi from ConfirmPurchases");
			globalSO = SharedObject.getLocal(theGlobalScope, "/");	
			if (!globalSO.data.ids) {
				globalSO.data.ids = [];
			}
			localSO = SharedObject.getLocal(theLocalScope, "/");	
			data = localSO.data;
		}
		public function addID(id:Object):Boolean {
			//check global shared object to see if id is already in pidList
			// return false if it is and true if it is not - and add pid
			trace ("id="+id);
			if (globalSO.data.ids.indexOf(id) == -1) {
				globalSO.data.ids.push(id);
				return true;
			} else {
				return false;
			}
		}
		public function clear():void {
			for (var i:Object in globalSO.data) {
				globalSO.data[i] = null;
			}
			globalSO.data.ids = [];
			for (var j:Object in localSO.data) {
				localSO.data[j] = null;
			}			
		}
	}
}