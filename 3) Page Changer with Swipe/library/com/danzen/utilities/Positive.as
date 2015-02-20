package com.danzen.utilities {

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.display.BitmapData;

	public class Positive {

		private var sX:Number;
		private var sY:Number;	
		
		public static function getPositive(pattern:MovieClip, backingColor:Number=0xffffff, spacingX:Number=1, spacingY:Number=1) {
			
			//trace (pattern.width, pattern.Height);
			
			var myBitmapData:BitmapData = new BitmapData(pattern.width, pattern.height);
			myBitmapData.draw(pattern);
			var myDark:Array = [];
			
			var totalX:Number = Math.floor(pattern.width / spacingX);
			var totalY:Number = Math.floor(pattern.height / spacingY);
			for (var i:uint=0; i<totalY; i++) {
				myDark.push([]);
				for (var j:uint=0; j<totalX; j++) {
					if (myBitmapData.getPixel(j*spacingX, i*spacingY) != backingColor) {
						myDark[i].push(1);
					} else {
						myDark[i].push(0);
					}
				}																		
			}			
			return myDark;
		}			
		
	}
}