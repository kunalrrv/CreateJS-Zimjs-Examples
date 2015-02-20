package com.danzen.interfaces {
		
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.*;
	import flash.geom.Matrix;
	
	public class Rotator extends MovieClip	{
		
		private var image:DisplayObject;
		private var button:MovieClip;
		private var holder:MovieClip;		
		
		public static const ROTATE:String = "rotate";
		public var bitmapData:BitmapData;
		
		public function Rotator(theImage:DisplayObject, theButton:MovieClip) {
			trace ("hi from Rotator");
			image = theImage;
			holder = MovieClip(image.parent);
			button = theButton;
			button.buttonMode = true;
			button.addEventListener(MouseEvent.CLICK, doRotate);
			bitmapData = new BitmapData(image.width, image.height, false, 0);
			bitmapData.draw(image);
			
		}
		
		private function doRotate(e:MouseEvent):void {
			
			// grab bitmapData from sample - would be the image complete
			// rotate it with matrix removeChild old Bitmap and set to null
			// add new Bitmap
			// store the bitmapData to create the crop pic			
		
			var matrix:Matrix = new Matrix();
			matrix.translate(-bitmapData.width / 2, -bitmapData.height / 2);
			matrix.rotate(90 * (Math.PI / 180));
			matrix.translate(bitmapData.height / 2, bitmapData.width / 2);
			
			var bmd:BitmapData = new BitmapData(bitmapData.height, bitmapData.width, false, 0x00000000);
			bmd.draw(bitmapData, matrix);
			bitmapData = bmd;			
			var temp:DisplayObject = holder.getChildAt(0);
			holder.removeChild(temp);
			temp = null;			
			holder.addChild(new Bitmap(bitmapData));
			
			dispatchEvent(new Event(Rotator.ROTATE));
		}	
		
		public function dispose():void {
			button.removeEventListener(MouseEvent.CLICK, doRotate);		
			bitmapData = null;
		}
	}
}