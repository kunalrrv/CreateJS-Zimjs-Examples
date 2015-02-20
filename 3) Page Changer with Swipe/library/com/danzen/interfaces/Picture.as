package com.danzen.interfaces
{		
	import com.danzen.frameworks.Easy;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	
	import uk.co.soulwire.display.colour.ColourUtils;

	// Picture extends a Sprite and loads an image into itself and gets a palatte (colors property)
	// receives URL:String, paletteSize:Number
		
	public class Picture extends Sprite
	{
		public var url:String;
		public var colors:Array;
		public var paletteSize:Number;
		private var pic:Sprite;	
		
		public static const PIC_READY:String = "picReady";
		
		public function Picture(thePicture:Object, thePaletteSize:Number=16)
		{
			trace("hi from Picture");
			
			if (thePicture is String) { 
				url = String(thePicture);
				pic = Easy.picture(url);
				pic.addEventListener(Event.COMPLETE, done);
			} else {
				pic = Sprite(thePicture);
				picReady();
			}
			paletteSize = thePaletteSize;			
		}
		private function done(e:Event):void {
			picReady();
		}
		private function picReady():void {			
			addChild(pic);
			// url from web is okay without timer but it is synchronous for desktop
			// so need to delay to let the listener be registered
			// also, Bitmap draw needed a touch of a delay too.
			var myTimer:Timer = new Timer(300,1);
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, doDelay);
			myTimer.start();
		}
		private function doDelay(e:TimerEvent):void {
			var bitData:BitmapData = new BitmapData(100, 100);
			var matrix:Matrix = new Matrix();
			// make picture smaller to sample more quickly
			matrix.scale(100/pic.width, 100/pic.height);
			bitData.draw(pic,matrix);				
			colors = ColourUtils.colourPalette(bitData, paletteSize, .02);
			pic.removeEventListener(Event.COMPLETE, done);
			dispatchEvent(new Event(Picture.PIC_READY));			
		}
		
	}
}