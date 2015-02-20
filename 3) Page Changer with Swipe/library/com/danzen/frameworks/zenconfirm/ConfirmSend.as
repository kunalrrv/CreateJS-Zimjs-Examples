package com.danzen.frameworks.zenconfirm
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.LocalConnection;
	
	// copyright 2012 Dan Zen - free to use
	
	// Sets up a confirmation system when purchasing a desktop app through paypal for instance
	// Works in leu of a unique paypal id - because paypal sandbox was not working at the time to test
	// also avoids a username and password situation
	
	// SYSTEM 
	// put a download link and a confirmation button swf file on the returning page from PAYPAL
	// once the user downloads, installs and runs the AIR app the user is to press the confirm button
	// the confirm button uses ConfirmSend with a LocalConnection to confirm and send an optional object of variables
	// on the AIR side, the ConfirmReceive object receives the message and gives a COMPLETE event
	// at which point the status, statusText and data properties are available
	// from that point on store a shared object with the AIR app to keep track of registration
	
	public class ConfirmSend extends Sprite
	{
		public var status:String;
		public var statusText:String;
		private var conn:LocalConnection;
		public static const COMPLETE:String = "complete";
		public static const GOOD:String = "good";
		public static const BAD:String = "bad";
		
		private var site:String;
		private var connectName:String;
		
		// theConnectName must be no spaces, unique for app, and the same for ConfirmSend and ConfirmReceive
		// theSite is the AIR app ID for ConfirmSend i.e. app#com.danzen.kittytartan
		// theSite is the site name where the confirm button is for ConfirmReceive i.e. tartankitty.com 
			
		public function ConfirmSend(theConnectName:String, theSite:String="*")
		{
			trace ("hi from ConfirmSend");
			connectName = theConnectName;
			site = theSite;			
			conn = new LocalConnection();
			conn.addEventListener(StatusEvent.STATUS, onStatus);			
			conn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, connectionError);			
		}
		public function send(obj:Object):void {
			conn.send(site+":"+connectName, "confirmMe", obj);
		}
		private function connectionError(event:SecurityErrorEvent):void {
			status = ConfirmSend.BAD;
			statusText = "error with confirming domain";
			dispatchEvent(new Event(ConfirmSend.COMPLETE));
		}
		private function onStatus(e:StatusEvent):void {
			switch (e.level) {
				case "status":
					status = ConfirmSend.GOOD;
					statusText = "success making connection - not necessarily accepted";
					dispatchEvent(new Event(ConfirmSend.COMPLETE));					
					break;
				case "error":
					status = ConfirmSend.BAD;
					statusText = "error with making connection";
					dispatchEvent(new Event(ConfirmSend.COMPLETE));
					break;
			}
		}
	}
}