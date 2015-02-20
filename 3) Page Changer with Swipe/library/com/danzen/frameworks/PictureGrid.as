package com.danzen.frameworks {
	
	import flash.display.Sprite;
	
	
	public class PictureGrid extends Sprite {

		private var pics:Sprite;
		private var w:Number;
		private var h:Number;
		private var p:Number;
		
		private var m:Sprite; // mask				
		private var r:Number; // rows
		private var c:Number; // cols

		public function PictureGrid(thePics:Sprite, theUnitWidth:Number, theUnitHeight:Number, thePadding:Number = 0) {
			// constructor code
			trace ("hi from PictureGrid");
			
			pics = thePics;
			w = theUnitWidth;
			h = theUnitHeight;
			p = thePadding;
			
			m = new Sprite();
			m.graphics.beginFill(0x000,1);
			m.graphics.drawRect(0,0,w-2*p,h-2*p);
			addChild(m);
			pics.x = -p;
			pics.y = -p;
			addChild(pics);			
			pics.mask = m;
			
			c = Math.round(pics.width / w);
			r = Math.round(pics.height / h);
			
		}
		
		public function goPic(t:Number):void {
			t--;
			var targetR:Number = Math.floor(t / c);
			var targetC:Number = t - targetR * c;
			pics.x = - targetC * w - p;
			pics.y = - targetR * w - p;
		}

	}
	
}
