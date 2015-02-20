package com.danzen.interfaces {
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Quad;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class TwoFace extends MovieClip	{
		public static const VERTICAL:String = "vertical";
		public static const HORIZONTAL:String = "horizontal";
		public static const UP:String = "up";
		public static const DOWN:String = "down";
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const CENTER:String = "center";
		public static const MOTION_COMPLETE:String = "complete";
		
		public var direction:String;
				
		private var outer:MovieClip;
		private var clip1:MovieClip;
		private var clip2:MovieClip;
		private var speed:Number;
		private var offset:Number;
		
		private var sW:Number;
		private var sH:Number;
		
		private var upStart:Number;
		private var downStart:Number;	
		private var centerAdjust:Number;
		
		private var clip1H:Number;
		private var clip2H:Number;
		
		private var _state:String = "center";
		
		public function TwoFace(theParent:MovieClip, theClip1:MovieClip, theClip2:MovieClip, theSpeed:Number=.5, theOffset:Number=0, theDirection:String="vertical") {
			trace ("hi from TwoFace");
			
			outer = theParent;
			
			// set up stage and bring in assets
			if (outer.stage.fullScreenWidth > 0) {
				sW = outer.stage.fullScreenWidth;
				sH = outer.stage.fullScreenHeight;
			} else {
				sW = outer.stage.stageWidth;
				sH = outer.stage.stageHeight;
			}			
			
			speed = theSpeed;
			
			clip1 = theClip1;
			clip2 = theClip2;
			clip1H = (clip1.desiredHeight) ? clip1.desiredHeight : clip1.height;
			clip2H = (clip2.desiredHeight) ? clip2.desiredHeight : clip2.height;
						
			offset = theOffset;
			direction = theDirection;
			clip1.y = (sH - (clip1H + clip2H)) / 2;
			clip2.y = clip1.y + clip1H;
						
			centerAdjust = clip1.y;
						
			addChild(clip2);
			addChild(clip1);
			
			upStart = -clip1.y;
			downStart = sH - clip1H - clip2H - centerAdjust;
			
			
		}
		public function up():void {
			_state = TwoFace.UP;
			TweenLite.to(this,speed,{y:upStart-offset, ease:Quad.easeInOut, onComplete:doneMove})
		}
		public function down():void {
			_state = TwoFace.DOWN;
			TweenLite.to(this,speed,{y:downStart+offset, ease:Quad.easeInOut, onComplete:doneMove})
		}
		public function center():void {
			_state = TwoFace.CENTER;
			TweenLite.to(this,speed,{y:0, ease:Quad.easeInOut, onComplete:doneMove})
		}
		private function doneMove():void {
			dispatchEvent(new Event(TwoFace.MOTION_COMPLETE));
		}
		public function get state():String {
			return _state;
		}
		
	
	}
}
