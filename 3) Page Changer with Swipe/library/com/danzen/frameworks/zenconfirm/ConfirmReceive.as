package com.danzen.frameworks.zenconfirm
{
	import com.danzen.utilities.Falcon;
	
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
		
	public class ConfirmReceive extends Sprite
	{
		public var data:Object;
		public var status:String;
		public var statusText:String;
		private var conn:LocalConnection;
		private var site:String;
		private var connectName:String;
		public static const COMPLETE:String = "complete";
		public static const GOOD:String = "good";
		public static const BAD:String = "bad";
		
		// theConnectName must be no spaces, unique for app, and the same for ConfirmSend and ConfirmReceive
		// theSite is the AIR app ID for ConfirmSend i.e. app#com.danzen.kittytartan
		// theSite is the site name where the confirm button is for ConfirmReceive i.e. tartankitty.com 
		
		public function ConfirmReceive(theConnectName:String, theSite:String="*")
		{
			trace ("hi from ConfirmReceive");
			site = theSite;
			connectName = theConnectName;
			conn = new LocalConnection();
			conn.allowDomain(site);
			conn.client = this;			
			try {
				conn.connect(connectName);
			} catch (error:ArgumentError) {
				status = ConfirmReceive.BAD;
				statusText = "error with connection name";
				dispatchEvent(new Event(ConfirmReceive.COMPLETE));
			}			
			conn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, connectionError);			
		}
		private function connectionError(event:SecurityErrorEvent):void {
			
			status = ConfirmReceive.BAD;
			statusText = "error with confirming domain";
			dispatchEvent(new Event(ConfirmReceive.COMPLETE));
			conn.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, connectionError);
		}
		
		public function confirmMe(obj:Object=null):void {
			if (status != ConfirmReceive.BAD) {
				status = ConfirmReceive.GOOD;
				statusText = "Confirmation success";
				data = obj;
				dispatchEvent(new Event(ConfirmReceive.COMPLETE));
			}
		}		
		public function usePasscode(url:String, pass:String, type:String):void {
			// usePasscode will check passcode with serverscript and if pass matches,
			// it will create a pid and dispatch as if confirmed from purchase
			var myFalcon:Falcon = new Falcon(url, Falcon.VARIABLES, {pass:pass, type:type});
			myFalcon.addEventListener(Event.COMPLETE, doConfirm);
			function doConfirm(e:Event):void {
				if (e.target.data.error == 0) {
					data = { pid:pass }; // records pid as pass to avoid using pass multiple times
					dispatchEvent(new Event(ConfirmReceive.COMPLETE));
				}
			}
		}
	
	}
}