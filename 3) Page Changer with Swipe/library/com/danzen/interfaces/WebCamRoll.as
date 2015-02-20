package com.danzen.interfaces {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.Timer;
	
	// WebCamRoll - compiled from code on the web and wrapped by Dan Zen 2012
	
	// MobileCamRoll opens the camera roll on Mobile when you call getPhoto	
	// it then gives an Event.COMPLETE event with an error of "success" if no error 
	// and you can get the bitmapData property to get the picture data
	// an Event.CANCEL is dispatched if cancelled	
	
	public class WebCamRoll extends MovieClip	{
		
		public var bitmapData:BitmapData;	
		public var error:String;
		private var max:Number;
		private var myFile:FileReference;
		private var dir:String;
		private var myLoader:Loader;
		
		public function WebCamRoll()	{
			trace ("hi from WebCamRoll");
		}
		
		public function getPhoto(theMax:Number=3000):void {
			max = theMax	
			myFile = new FileReference();
			myFile.addEventListener(Event.SELECT, selectHandler);
			myFile.addEventListener(Event.COMPLETE, completeHandler);
			myFile.addEventListener(Event.CANCEL, cancelHandler);
			myFile.browse([new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png")]);
		}
		
		private function cancelHandler(e:Event):void {
			dispatchEvent(new Event(Event.CANCEL));
		}
		
		private function selectHandler(e:Event):void {
			myFile.load();
		}
		
		private function completeHandler(e:Event):void {			
			myLoader=new Loader();
			myLoader.loadBytes(myFile.data);
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadDone);
		}
		
		private function loadDone(e:Event):void {			
			var newW:Number;
			var newH:Number;
			var scale:Number;
			if (myLoader.height / myLoader.width > 1) {
				scale = max / myLoader.height;
				newW = myLoader.width * scale;
				newH = max;					
			} else {
				scale = max / myLoader.width
				newH = myLoader.height * scale;
				newW = max;
			}
			var m:Matrix = new Matrix();
			m.scale(scale,scale);
			bitmapData = new BitmapData(newW, newH, true, 0x000000);
			bitmapData.draw(myLoader.content, m);	
			error = "success";
			dispatchEvent(new Event(Event.COMPLETE));
		}		
	}
}