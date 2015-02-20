package com.danzen.utilities {
	
	// Ticks - by Dan Zen - http://www.danzen.com
	// puts ticks behind the slider so behind the slider knob
	// lets you place ticks above or below slider in y
	// apply like so if a holder MovieClip holds the slider
	// holder.addChildAt(new Ticks(holder.slider, 1, .5, Ticks.POSITION_TOP), holder.getChildIndex(holder.slider));
	
	// to use the class, place the com folder with all its subfolders and files
	// in a folder that is in your class path (Edit > Preferences > ActionScript 3 > Source Path)
	// note: do not add the com folder to the source path
	// but rather, add the folder the com folder is in to your Source Path
	
	import flash.display.Sprite;
	import fl.controls.Slider;	

	public class Ticks extends Sprite {
		
		// s is the slider instance
		// t is the tick interval (default 1)
		// a is the alpha of the tick (default 1)
		// p is the tick placement above or below the slider
		
		public static const POSITION_TOP:String = "position_top";
		public static const POSITION_BOTTOM:String = "position_bottom";
		
		public function Ticks(s:Slider, t:Number=1, a:Number=1, p:String=Ticks.POSITION_TOP) {
			graphics.lineStyle(1, 1, a, true, "normal", "none");
			var sY:Number;
			if (p == Ticks.POSITION_TOP) {
				sY = -4;
			} else {
				sY = 6;
			}
			var h:Number = 2;			
			var min:Number = s.minimum;
			var max:Number = s.maximum;
			var w:Number = s.width;
			var num:Number = Math.floor((max - min) / t);
			var spacing:Number = s.width / num;			
			for (var i:uint=0; i<=num; i++) {
				graphics.moveTo(s.x+spacing*i,s.y+sY);
				graphics.lineTo(s.x+spacing*i,s.y+sY+h);		
			}			
		}
	}	
}
