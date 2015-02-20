package com.danzen.interfaces {
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.geom.Matrix;
	
	public class CropperSingle extends MovieClip	{
		
		private var image:MovieClip;
		private var leftHandle:MovieClip;
		private var rightHandle:MovieClip;
		private var startGutter:Number = 40;
		private var downCheck:Boolean = false;
		private var dragLeftCheck:Boolean = false;
		private var dragRightCheck:Boolean = false;
		private var scale:Number;
		
		public function CropperSingle(theImage:MovieClip, theLeftHandle:MovieClip, theRightHandle:MovieClip) {
			trace ("hi from Cropper");
			image = theImage;
			scale = image.scaleX;
			leftHandle = theLeftHandle;
			rightHandle = theRightHandle;
			leftHandle.mouseChildren = false;
			rightHandle.mouseChildren = false;
			leftHandle.x = image.x + startGutter;
			leftHandle.y = image.y + startGutter;
			rightHandle.x = image.x + image.width - startGutter;
			rightHandle.y = image.y + image.height - startGutter;
			setBounds(null);
			leftHandle.addEventListener(MouseEvent.MOUSE_DOWN, doDown);	
			rightHandle.addEventListener(MouseEvent.MOUSE_DOWN, doDown);
			leftHandle.buttonMode = rightHandle.buttonMode = true;
		}
		
		private function doDown(e:MouseEvent):void {
			if (!downCheck) {
				image.stage.addEventListener(MouseEvent.MOUSE_MOVE, setBounds);
				image.stage.addEventListener(MouseEvent.MOUSE_UP, doUp);
			}
			if (e.target == leftHandle) {
				dragLeftCheck = true;
			}
			if (e.target == rightHandle) {
				dragRightCheck = true;
			}
			e.target.offsetX = image.parent.mouseX - e.target.x;
			e.target.offsetY = image.parent.mouseY - e.target.y;
		}
		
		private function doUp(e:MouseEvent):void {
			image.stage.removeEventListener(MouseEvent.MOUSE_MOVE, setBounds);
			image.stage.removeEventListener(MouseEvent.MOUSE_UP, doUp);
			downCheck = false;
			dragLeftCheck = false;
			dragRightCheck = false;
		}
		
		private function setBounds(e:Event):void {
			if (dragLeftCheck) {
				leftHandle.x = image.parent.mouseX - leftHandle.offsetX;
				leftHandle.y = image.parent.mouseY - leftHandle.offsetY;
			}
			bounds(leftHandle);
			if (dragRightCheck) {
				rightHandle.x = image.parent.mouseX - rightHandle.offsetX;
				rightHandle.y = image.parent.mouseY - rightHandle.offsetY;
			}
			bounds(rightHandle);
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
			leftHandle.removeEventListener(MouseEvent.MOUSE_DOWN, doDown);	
			rightHandle.removeEventListener(MouseEvent.MOUSE_DOWN, doDown);	
			if (downCheck) {
				image.stage.removeEventListener(MouseEvent.MOUSE_MOVE, setBounds);
				image.stage.removeEventListener(MouseEvent.MOUSE_UP, doUp);
			}
		}
		
	}
}