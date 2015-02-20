package com.danzen.interfaces {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.geom.Matrix;
	import flash.media.CameraRoll;
	import flash.media.MediaPromise;
	import flash.utils.Timer;
	
	// MobileCamRoll - compiled from code on the web and wrapped by Dan Zen 2012
	// tested with iOS, Android and Blackberry 10 (Playbook) used first on hangy.mobi then on hipster.mobi
	
	// MobileCamRoll opens the camera roll on Mobile when you call getPhoto	
	// it then gives an Event.COMPLETE event with an error of "success" if no error 
	// and you can get the bitmapData property to get the picture data
	// an Event.CANCEL is dispatched if cancelled	
	
	public class MobileCamRoll extends MovieClip	{
		
		public var bitmapData:BitmapData;	
		public var error:String;
		private var max:Number;
		
		public function MobileCamRoll()	{
			trace ("hi from MobileCamRoll");
		}
		
		public function getPhoto(theMax:Number=1024):void {
			max = theMax
			var t:Timer = new Timer(100,1);
			t.addEventListener(TimerEvent.TIMER, go);
			t.start();			
		}
		
		private function go(e:TimerEvent):void {
			var cr:CameraRoll=new CameraRoll();	
			var loader:Loader;
			
			if (CameraRoll.supportsBrowseForImage == false) {				
				error = "Sorry, photo browsing not supported";
				dispatchEvent(new Event(Event.COMPLETE));
				return;
			}					
		
			addBrowseListeners();			
			cr.browseForImage();
			
			function addBrowseListeners():void {				
				cr.addEventListener(MediaEvent.SELECT, onImgSelect);
				cr.addEventListener(Event.CANCEL, onCancel);
				cr.addEventListener(ErrorEvent.ERROR, onError);				
			}
			
			function removeBrowseListeners():void {				
				cr.removeEventListener(MediaEvent.SELECT, onImgSelect);
				cr.removeEventListener(Event.CANCEL, onCancel);
				cr.removeEventListener(ErrorEvent.ERROR, onError);				
			}			
			
			function onCancel(event:Event):void {				
				removeBrowseListeners();				
				dispatchEvent(new Event(Event.CANCEL));	
			}
			
			function onError(event:ErrorEvent):void {	
				removeBrowseListeners();				
				error = "Sorry, error loading pic";
				dispatchEvent(new Event(Event.COMPLETE));			
			}			
			
			function onImgSelect(event:MediaEvent):void {				
				var promise:MediaPromise = event.data as MediaPromise;				
				removeBrowseListeners();				
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
				loader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR, onError);
				loader.loadFilePromise(promise);				
			}			
						
			function onImageLoaded(event:Event):void {				
				bitmapData = Bitmap(event.currentTarget.content).bitmapData;	
				
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
				
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);				
				loader.contentLoaderInfo.removeEventListener(ErrorEvent.ERROR, onError);
				error = "success";
				dispatchEvent(new Event(Event.COMPLETE));
			}			
		}
	}
}