package com.danzen.interfaces {
	
	import com.adobe.images.JPGEncoder;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;
	
	
	// ImageSend - Dan Zen 2010
	// create jpg and send image to url
	
	
	public class ImageSend extends MovieClip {
		
		private var bitmapData:BitmapData;
		private var url:String;
		
		public function ImageSend(theBitmapData:BitmapData, theURL:String, max:Number=1024)	{
			trace ("hi from ImageSend");
			
			bitmapData = theBitmapData;
			url = theURL;
			
			if (bitmapData.height > max || bitmapData.width > max) {
				var newW:Number;
				var newH:Number;
				var scale:Number;
				if (bitmapData.height / bitmapData.width > 1) {
					scale = max / bitmapData.height;
					newW = bitmapData.width * scale;
					newH = max;					
				} else {
					scale = max / bitmapData.width
					newH = bitmapData.height * scale;
					newW = max;
				}
				var m:Matrix = new Matrix();
				m.scale(scale,scale);
				var bm:BitmapData = new BitmapData(newW, newH, false, 0);
				bm.draw(bitmapData, m);
				bitmapData = bm;
			}
			
			var myEncoder:JPGEncoder = new JPGEncoder(80);
			var stream:ByteArray = myEncoder.encode(bitmapData);			
			var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			var jpgURLRequest:URLRequest;
			var urlLoader:URLLoader;			
			
			jpgURLRequest = new URLRequest(url);
			jpgURLRequest.requestHeaders.push(header);
			jpgURLRequest.method = URLRequestMethod.POST;
			jpgURLRequest.data = stream;
			
			urlLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, imageComplete);
			urlLoader.load(jpgURLRequest);			
		}
		
		private function imageComplete(e:Event):void {
			dispatchEvent(new Event(Event.COMPLETE));	
		}
		
	}
}