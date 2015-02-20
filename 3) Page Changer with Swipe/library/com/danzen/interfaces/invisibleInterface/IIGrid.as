package com.danzen.interfaces.invisibleInterface {
	
	import flash.display.MovieClip;
	import flash.events.*;
	
	dynamic public class IIGrid extends MovieClip {

		private var cols:uint;
		private var rows:uint;
		private var clip:MovieClip;
		private var dc:Boolean;
		
		private var sW:Number;
		private var sH:Number;
		
		private var spacing:Number;
		private var rounding:Number;
		
		public function IIGrid(theClip:MovieClip, theCols:uint=3, theRows:uint=2, theSpacing:Number=10, theRounding:Number=70):void {
			// constructor code
			
			//trace ("hi from IIGrid");
			
			clip = theClip;	
			
			if (clip.stage.fullScreenWidth > 0) {
				sW = clip.stage.fullScreenWidth;
				sH = clip.stage.fullScreenHeight;
			} else {
				sW = clip.stage.stageWidth;
				sH = clip.stage.stageHeight;
			}			
			
			cols = theCols;
			rows = theRows;	
			spacing = theSpacing;
			rounding = theRounding;
			
			makeGrid();
			
			// blendMode = "difference";
			alpha = 1;
			buttonMode = true;
			
			addEventListener(MouseEvent.CLICK, doPress);							 
			
		}
		
		private function doPress(e:MouseEvent):void {			
			dispatchEvent(new IIEvent(IIEvent.PRESS, null, e.target.num));
		}
				
		private function makeGrid():void {
			var box:MovieClip;
			var w:Number = sW/cols;
			var h:Number = sH/rows;
			//trace (w, h);
			var count:Number = 0;
			var p:Number = spacing;
			var c:Number = rounding;
			for (var i:uint=0; i<rows; i++) {				
				for (var j:uint=0; j<cols; j++) {
					count++;
					box = new MovieClip();
					box.x = j*w;
					box.y = i*h;
					box.graphics.beginFill(0xf00,0);
					box.graphics.lineStyle(2,0x000000,0);
					box.graphics.drawRect(0,0,w,h);
					box.graphics.beginFill(0x000000,.075);
					box.graphics.lineStyle(2,0x000000,0);
					box.graphics.drawRoundRect(p,p,w-2*p,h-2*p, c, c);
					box.num = count;					
					box.doubleClickEnabled = dc;
					addChild(box);
				}
			}					
		}	
		
		public function dispose():void {			
			removeEventListener(MouseEvent.CLICK, doPress);			
		}		
	}	
}
