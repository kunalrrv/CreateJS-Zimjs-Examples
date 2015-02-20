package com.danzen.effects
{	
	
	import com.danzen.frameworks.Easy;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
		
	public class Tartan extends Sprite
	{		
		private var colors:Array;
		private var widths:Array;
		private var tW:Number;
		private var tH:Number;
		
		public function Tartan(theColors:Array, theWidths:Array, theWidth:Number, theHeight:Number)
		{				
			colors = theColors;
			widths = theWidths;
			tW = theWidth;
			tH = theHeight;
			
			var strip:Easy;
			var lastX:Number = 0;
			var lastY:Number = 0;
			var numColors:Number = colors.length;
			
			for (var i:uint = 0; i < numColors*30; i++) {
				strip = Easy.rectangle(2800, widths[i%numColors], colors[i%numColors]);
				addChild(strip);				
				strip.y = lastY;				
				strip.alpha = .5;
				lastY += widths[i%numColors];
				
				strip = Easy.rectangle(2800, widths[numColors-i%numColors-1], colors[numColors-i%numColors-1]);
				addChild(strip);				
				strip.y = lastY;				
				strip.alpha = .5;
				lastY += widths[numColors-i%numColors-1];
				
			}
			for (i = 0; i < numColors*30; i++) {
				strip = Easy.rectangle(widths[i%numColors], 1800, colors[i%numColors]);
				addChild(strip);
				strip.x = lastX;				
				strip.alpha = .5;
				lastX += widths[i%numColors];
				
				strip = Easy.rectangle(widths[numColors-i%numColors-1], 1800, colors[numColors-i%numColors-1]);
				addChild(strip);
				strip.x = lastX;				
				strip.alpha = .5;
				lastX += widths[numColors-i%numColors-1];			
				
			}	
			var blindR:Easy = Easy.rectangle(lastX-tW, tH, 0x444444);
			blindR.x = tW;
			addChild(blindR);
			var blindB:Easy = Easy.rectangle(lastX-tH, tW, 0x444444);
			blindB.y = tH;
			addChild(blindB);
			var blindL:Easy = Easy.rectangle(lastX-tW, tH, 0x444444);
			blindL.x = -blindL.width;
			addChild(blindL);
			var blindT:Easy = Easy.rectangle(lastX-tH, tW, 0x444444);
			blindT.y = -blindT.height;
			addChild(blindT);
			
			trace (colors)
			trace (widths);
		}	
	}
}