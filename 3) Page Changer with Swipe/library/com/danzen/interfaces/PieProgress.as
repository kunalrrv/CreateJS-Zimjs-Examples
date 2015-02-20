package com.danzen.interfaces {
	
	
	import flash.display.Sprite;
	import flash.filters.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class PieProgress extends Sprite {
		
		private var proportion:Number = 0;		
		
		private var maskSprite:Sprite = new Sprite();
		private var angleSprite:Sprite = new Sprite();
		private var rad:Number;
		private var left:Number;	
		private var tot:Number;
		private var myText:TextField;
		private var myFormat:TextFormat
		private var don:Boolean = false;
		
		public function PieProgress(theRadius:Number, totalTime:Number=-1) {
			
			trace ("hi from PieProgress");
			
			//filters = [new BevelFilter(2, 45, 0x000000, 1, 0x999999, 1, 3, 3, .6, 1,"inner")];
			//filters = [new GlowFilter(0xdddddd, 1, 46, 46, 2, 1,true)];
			//filters = [new DropShadowFilter(4, 45, 0, .8, 12, 12, 1, 1, true)];
									
			addChild(maskSprite);
			addChild(angleSprite);
			
			angleSprite.filters = [new DropShadowFilter(4, 45, 0, 1, 10, 10, 1, 1, true)];
			
			tot = totalTime;			
			
			if (tot >= 0) {
				myFormat = new TextFormat();
				myFormat.color = 0xDDDDDD;
				myFormat.size = 40;		
				myFormat.font = "_sans";
				myText = new TextField();
				myText.autoSize = "right";
				myText.width = 200;	
				myText.text = String(tot);
				addChild(myText);	
				radius = theRadius;
				myText.x = radius - myText.width - 10;
				myText.y = radius/8;		
				
				myText.setTextFormat(myFormat);
			} else {
				radius = theRadius;
			}
					
		}
		
		public function set done(b:Boolean):void {			
			if (b) {				
				angleSprite.graphics.clear();
				angleSprite.graphics.beginFill(0xff0000, .8);
				angleSprite.graphics.lineStyle(3,0,1);
				angleSprite.graphics.drawRect(-2,-2,rad*2+2,rad*2+2);
				myText.text = "";
			} 
			don = b;
		}
		public function get done():Boolean {
			return don;
		}
		
		public function set total(t:Number):void {			
			tot = t;
			if (tot < 0) {tot = 0;}
			if (tot*10 % 10 == 0) {
				myText.text = String(tot) + ".0";
			} else {
				myText.text = String(tot);
			}
			myText.setTextFormat(myFormat);
		}
		public function get total():Number {
			return tot;
		}
				
		public function set radius(r:Number):void {
			rad = r;
			if (rad < 0) {rad = 0;}
			
			// backing sprite
			graphics.clear();
			graphics.beginFill(0x000000, 1);
			graphics.lineStyle(3,0,1);
			graphics.drawCircle(rad,rad,rad);
			
			// mask sprite
			maskSprite.graphics.clear();
			maskSprite.graphics.beginFill(0x000000, 1);
			maskSprite.graphics.drawCircle(rad,rad,rad);
			angleSprite.graphics.clear();
			angleSprite.mask = maskSprite;
			
			percent = proportion;		
			
		}
		public function get radius():Number {
			return rad;
		}
		
		public  function set percent(p:Number):void {
			proportion = p;	
			if (proportion < 0) {proportion = 0;}
			
			angleSprite.graphics.clear();
			angleSprite.graphics.beginFill(0x888888, 1);
			angleSprite.graphics.lineStyle(3,0,1);
			angleSprite.graphics.moveTo(rad,-1);
			angleSprite.graphics.lineTo(rad, rad);
			
			var ang:Number = p * Math.PI * 2;
			var h:Number = rad + 1;
			var a:Number = h * Math.cos(ang);
			var o:Number = h * Math.sin(ang);
			
			angleSprite.graphics.lineTo(rad+o, rad-a);
			
			if (p <= .5) {
				angleSprite.graphics.lineTo(rad*2+1, rad-a);
				angleSprite.graphics.lineTo(rad*2+1, -1);
			} else {
				angleSprite.graphics.lineTo(-1, rad-a);
				angleSprite.graphics.lineTo(-1, rad*2+1);
				angleSprite.graphics.lineTo(rad*2+1, rad*2+1);
				angleSprite.graphics.lineTo(rad*2+1, -1);
			}	
			
			if (tot >= 0) {
				var left:Number = Math.round((tot - tot*percent) * 10) / 10;
				if (left*10 % 10 == 0) {
					myText.text = String(left) + ".0";
				} else {
					myText.text = String(left);
				}
				myText.setTextFormat(myFormat);
			}
							
		}
		public function get percent():Number {
			return proportion;
		}
	}
}