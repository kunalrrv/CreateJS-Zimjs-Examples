package com.danzen.frameworks.zenmvc {
	
	import com.danzen.utilities.Falcon;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ZenModel extends Sprite {
		
		public var data:Object = {};
		
		public function ZenModel() {
			trace ("hi from ZenModel Abstract Class");				
		}
		
		public function setText():Boolean {
			return true;
		}
		public function getText(url):Boolean {
			var myFalcon:Falcon = new Falcon(url, Falcon.TEXT);
			myFalcon.addEventListener(Event.COMPLETE, done);			
			function done(e:Event) {
				dispatchEvent(new ModelEvent(ModelEvent.COMPLETE, myFalcon.data, myFalcon.error));		
			}
			return true;
		}
		public function getSetText():String {
			return "set and get text data";
		}
		
		public function setXML():Boolean {
			return true;
		}
		public function getXML(url):Boolean {
			var myFalcon:Falcon = new Falcon(url, Falcon.XML_DATA);
			myFalcon.addEventListener(Event.COMPLETE, done);			
			function done(e:Event) {
				dispatchEvent(new ModelEvent(ModelEvent.COMPLETE, myFalcon.data, myFalcon.error));		
			}
			return true;
		}
		public function getSetXML():String {
			return <test>hello</test>;
		}		
		
		public function getBinary(url):Boolean {
			var myFalcon:Falcon = new Falcon(url, Falcon.BINARY);
			myFalcon.addEventListener(Event.COMPLETE, done);			
			function done(e:Event) {
				dispatchEvent(new ModelEvent(ModelEvent.COMPLETE, myFalcon.data, myFalcon.error));		
			}
			return true;
		}
		
	}	
	
}