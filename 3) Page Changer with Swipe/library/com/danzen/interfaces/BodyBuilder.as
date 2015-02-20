package com.danzen.interfaces {
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.net.*;

	public dynamic class BodyBuilder extends MovieClip {
		
		private var myControlX:Number = 0;
		private var myControlY:Number = 0;
		
		private var interactive:Boolean;
		private var sW:Number;
		private var sH:Number;
		private var mySprite:Sprite;
		private var top:Point;
		private var bottom:Point;
		private var startCursorPoint:Point;		
		private var startLeftLobePoint:Point;
		private var startRightLobePoint:Point;		
		private var lastLeftLobePoint:Point;	
		private var lastRightLobePoint:Point;		
		
		private var myH:Number; // height
		private var myC:Number; // color
		private var myF:Array; // filters
		
		// assume symetry and using right side as control point
		private var minX:Number;
		private var maxX:Number;
		private var minY:Number;
		private var maxY:Number;
		

		public function BodyBuilder(theInteractive:Boolean=true, theSW:Number=200, theSH:Number=200, h:Number=100, c:Number=0x000000, f:Array=null) {
			
			interactive = theInteractive;
			myH = h;
			myC = c;
			myF = f;
			sW = theSW;
			sH = theSH;
			
			minX = 0;
			maxX = sW;
					
			minY = (sH-myH) /2;
			maxY = sH - minY;
			
			trace("hi from BodyBuilder");
			if (interactive) {
				addEventListener(Event.ADDED_TO_STAGE, init);
			} else {
				init(new Event(""));
			}
		}
		
		private function init(e:Event) {
			if (interactive) {
				removeEventListener(Event.ADDED_TO_STAGE, init);
			} 
			
			mySprite = new Sprite();
						
			top=new Point(sW/2,minY);
			bottom=new Point(sW/2,minY+myH);
			
			controlX = sW;
			controlY = sH/2;
			
			//drawHeart(new Point(top.x - 100, top.y + (bottom.y - top.y) / 2), new Point(top.x + 100, top.y + (bottom.y - top.y) / 2));
			drawHeart(new Point(sW/2-(controlX-sW/2), controlY), new Point(controlX, controlY));
						
			addChild(mySprite);
			
			if (interactive) {
				mySprite.buttonMode=true;
				mySprite.addEventListener(MouseEvent.MOUSE_DOWN, dragHeart);	
			}

		}
		
		
		private function dropHeart(event:MouseEvent) {
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, animate);
			stage.removeEventListener(MouseEvent.MOUSE_UP, dropHeart);
			dispatchEvent(new Event(Event.CHANGE));
		}

		private function animate(event:MouseEvent) {
			var _loc_2:* =new Point(startCursorPoint.x-mouseX,startCursorPoint.y-mouseY);
			if (startCursorPoint.x>sW/2) {
				drawHeart(new Point(startLeftLobePoint.x + _loc_2.x, startLeftLobePoint.y - _loc_2.y), new Point(startRightLobePoint.x - _loc_2.x, startLeftLobePoint.y - _loc_2.y));
			} else {
				drawHeart(new Point(startLeftLobePoint.x - _loc_2.x, startLeftLobePoint.y - _loc_2.y), new Point(startRightLobePoint.x + _loc_2.x, startLeftLobePoint.y - _loc_2.y));
			}

		}

		private function drawHeart(param1:Point, param2:Point) {
			
			controlY = param2.y;
			param1.y = param2.y = controlY;			
			
			controlX = Math.max(param1.x, param2.x);
			param2.x = controlX;
			param1.x = sW/2-(controlX-sW/2);			
						
			mySprite.graphics.clear();
			mySprite.graphics.beginFill(myC, 1);
			mySprite.graphics.moveTo(top.x, top.y);
			mySprite.graphics.curveTo(param1.x, param1.y, bottom.x, bottom.y);
			mySprite.graphics.curveTo(param2.x, param2.y, top.x, top.y);
			lastLeftLobePoint=param1;
			lastRightLobePoint=param2;
			mySprite.filters=myF;

		}

		private function dragHeart(event:MouseEvent) {
			startCursorPoint=new Point(mouseX,mouseY);
			startLeftLobePoint=lastLeftLobePoint;
			startRightLobePoint=lastRightLobePoint;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, animate);
			stage.addEventListener(MouseEvent.MOUSE_UP, dropHeart);

		}		
		
		public function get controlX():Number {
			return myControlX;
		}
		public function set controlX(num:Number):void {
			myControlX = Math.min(Math.max(num, minX), maxX);
			if (Math.abs(myControlX) > 90 && Math.abs(myControlX) < 110) {
				myControlX = 110;
			}
			trace (controlX);
		}
		public function get controlY():Number {
			return myControlY;
		}
		public function set controlY(num:Number):void {
			myControlY = Math.min(Math.max(num, minY), maxY);
		}
		public function remoteDraw() {
			drawHeart(new Point(sW/2-(controlX-sW/2), controlY), new Point(controlX, controlY));
		}

			
	
		
	}
}
