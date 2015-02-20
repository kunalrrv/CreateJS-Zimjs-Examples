package com.danzen.interfaces {
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Matrix;
	
	public class Cropper extends MovieClip	{
		
		private var image:MovieClip;
		private var leftHandle:MovieClip;
		private var rightHandle:MovieClip;
		private var startGutter:Number = 40;
		private var downCheck:Boolean = false;
		private var dragLeftCheck:Boolean = false;
		private var dragRightCheck:Boolean = false;
		private var scale:Number;
		private var touches:Object = new Object();
		
		public function Cropper(theImage:MovieClip, theLeftHandle:MovieClip, theRightHandle:MovieClip) {
			trace ("hi from Cropper");
			image = theImage;
			scale = image.scaleX;
			leftHandle = theLeftHandle;	rightHandle = theRightHandle;
			leftHandle.mouseChildren = false;
			rightHandle.mouseChildren = false;
			leftHandle.x = image.x + startGutter; leftHandle.y = image.y + startGutter;
			rightHandle.x = image.x + image.width - startGutter; rightHandle.y = image.y + image.height - startGutter;
			drawCropRect();
			leftHandle.addEventListener(TouchEvent.TOUCH_BEGIN, doDown);	
			rightHandle.addEventListener(TouchEvent.TOUCH_BEGIN, doDown);			
			leftHandle.buttonMode = rightHandle.buttonMode = true;			
		}
				
		private function doDown(e:TouchEvent):void {			
			if (!downCheck) {
				downCheck = true;
				image.stage.addEventListener(TouchEvent.TOUCH_MOVE, setBounds);
				image.stage.addEventListener(TouchEvent.TOUCH_END, doUp);
			}
			touches[e.touchPointID] = e.target;		
			e.target.offsetX = e.stageX - e.target.x;
			e.target.offsetY = e.stageY - e.target.y;
		}
		
		private function doUp(e:TouchEvent):void {
			delete touches[e.touchPointID];
			for each (var prop:Object in touches) {var full:Boolean=true; break;}
			if (!full) {
				image.stage.removeEventListener(TouchEvent.TOUCH_MOVE, setBounds);
				image.stage.removeEventListener(TouchEvent.TOUCH_END, doUp);
				downCheck = false;
			}
		}
		
		private function setBounds(e:TouchEvent):void {			
			var t:MovieClip = MovieClip(touches[e.touchPointID]);
			t.x = e.stageX - t.offsetX;
			t.y = e.stageY - t.offsetY;			
			bounds(t);			
			drawCropRect();
		}
		
		private function drawCropRect():void {
			graphics.clear();
			graphics.lineStyle(4,0x000000,1,false);
			graphics.drawRect(leftHandle.x, leftHandle.y, rightHandle.x - leftHandle.x, rightHandle.y - leftHandle.y);
			graphics.lineStyle(4,0xfffffff,1,false);
			graphics.drawRect(leftHandle.x+4, leftHandle.y+4, rightHandle.x - leftHandle.x - 8, rightHandle.y - leftHandle.y - 8);
		}
		
		private function bounds(w:MovieClip):void {
			if (w.x < image.x) {
				w.x = image.x;
			}
			if (w.y < image.y) {
				w.y = image.y;
			}
			if (w.x > image.x + image.width) {
				w.x = image.x + image.width;
			}
			if (w.y > image.y + image.height) {
				w.y = image.y + image.height;
			}
			if (w == leftHandle) {
				if (w.x + leftHandle.width * 1.5 > rightHandle.x) {
					w.x = rightHandle.x - leftHandle.width * 1.5;
				}
				if (w.y + leftHandle.height * 1.5 > rightHandle.y) {
					w.y = rightHandle.y - leftHandle.height * 1.5;
				}
			} else if (w == rightHandle) {
				if (w.x - rightHandle.width * 1.5 < leftHandle.x) {
					w.x = leftHandle.x + rightHandle.width * 1.5;
				}
				if (w.y - rightHandle.height * 1.5 < leftHandle.y) {
					w.y = leftHandle.y + rightHandle.height * 1.5;
				}
			}			
		}
		
		public function getBitmapData():BitmapData {			
			var bmData:BitmapData = new BitmapData((rightHandle.x - leftHandle.x)/scale, (rightHandle.y - leftHandle.y)/scale, false);
			var matrix:Matrix = new Matrix();
			matrix.translate((image.x-leftHandle.x)/scale, (image.y-leftHandle.y)/scale);			
			bmData.draw(image, matrix);
			return bmData;			
		}
		
		public function dispose():void {
			leftHandle.removeEventListener(TouchEvent.TOUCH_BEGIN, doDown);	
			rightHandle.removeEventListener(TouchEvent.TOUCH_BEGIN, doDown);	
			if (downCheck) {
				image.stage.removeEventListener(TouchEvent.TOUCH_MOVE, setBounds);
				image.stage.removeEventListener(TouchEvent.TOUCH_END, doUp);
			}
		}
		
	}
}