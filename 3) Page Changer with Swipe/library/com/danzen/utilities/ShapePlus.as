
package com.danzen.utilities {
	
	import flash.display.*
	
	public class ShapePlus extends Shape {
		
		public function ShapesPlus() {
			
		}
		
		public static function makeRect(x:Number,
										y:Number,
										width:Number,
										height:Number,
										fillColor:Number = 0xDDDDDD,
										alpha:Number = 1,
										fill:Boolean = true,
										lineThickness:Number = 0,
										lineColor:Number = 0															
										):Shape {
						
			var holder = new Shape();			
			if (lineThickness == 0 && !fill) {return holder;}
			if (lineThickness > 0) {
				holder.graphics.lineStyle(lineThickness, lineColor, 1, true, "normal", "square", "miter");
			}
			if (fill) {holder.graphics.beginFill(fillColor);}
			holder.graphics.drawRect(x,y,width,height);			
			if (fill) {holder.graphics.endFill();}		
			holder.alpha = alpha;
			return holder;
		}
		
		public static function makeRoundRect(x:Number,
										y:Number,
										width:Number,
										height:Number,
										round:Number,
										fillColor:Number = 0xDDDDDD,
										alpha:Number = 1,
										fill:Boolean = true,
										lineThickness:Number = 0,
										lineColor:Number = 0x333333															
										):Shape {
						
			var holder = new Shape();			
			if (lineThickness == 0 && !fill) {return holder;}
			if (lineThickness > 0) {
				holder.graphics.lineStyle(lineThickness, lineColor);
			}
			if (fill) {holder.graphics.beginFill(fillColor);}
			holder.graphics.drawRoundRect(x,y,width,height,round);			
			if (fill) {holder.graphics.endFill();}		
			holder.alpha = alpha;
			return holder;
		}		
		
		
	}
}