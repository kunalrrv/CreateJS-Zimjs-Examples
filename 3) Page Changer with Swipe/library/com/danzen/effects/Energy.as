package com.danzen.effects {

	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.getDefinitionByName;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.BitmapData;
	import com.danzen.utilities.Positive;

	public class Energy extends MovieClip {
		
		public var holder:MovieClip;
		private var myH:Number;
		private var myV:Number;
		private var myS:Number;		
		
		private var myDark:Array;
		
		public function Energy (pattern:MovieClip, dot:String, myList:Array, spacing=20, horizontal=30, vertical=20) {
			trace ("hi from Energy");
			myH = horizontal;
			myV = vertical;
			myS = spacing;
			holder = new MovieClip();
			addChild(holder);			
			
			var temp:MovieClip;			
			var map:Boolean;			
			
			var sX:Number = 2; // spacing for looking for dark to move dots to
			var sY:Number = 2;		
						
			if (myList.length == 0) {
				map = true;
				myDark = Positive.getPositive(pattern, 0xFFFFFF, sX, sY);
			} else {
				map = false;
			}
			
			var dotRotation:Number;
			
			for (var i:uint=0; i<myV; i++) {
				for (var j:uint=0; j<myH; j++) {
					dotRotation = (Math.round(Math.random())*2-1)*Math.random()*1.6;
					temp = new (getDefinitionByName(dot))(dotRotation);
					temp.rotation = Math.random()*360;
					temp.scaleX=temp.scaleY=Math.random()*4+1;
					temp.gotoAndStop(Math.floor(Math.random()*temp.totalFrames)+1);
					
					holder.addChild(temp);
					temp.x = j * myS;
					temp.y = i * myS;				
					
					if (map) {
						var obj:Object = locateClosest(pattern, temp, myDark, sX, sY);										
						myList.push({x:obj.x, y:obj.y, alpha:obj.alpha});	
						//myList.push({x:obj.x, y:obj.y, alpha:Math.random()});
						trace ("{x:"+obj.x+", y:"+obj.y+", alpha:"+obj.alpha+"},");					
					}
				}
			}					
						
			var t:Object;
			for (var k:uint=0; k<myList.length; k++) {	
				if (!myList[k]) {continue;}
				t = myList[k];
				//t.ease = Bounce.easeIn;
				//t.ease = Cubic.easeInOut;
				t.ease = Back.easeInOut;
				t.alpha = .5;
				t.scaleX = holder.getChildAt(k).scaleX / 2;
				t.scaleY = holder.getChildAt(k).scaleY / 2;
				t.alpha = .5;
				//t.easeParams = [5];
				TweenLite.to(holder.getChildAt(k), 4+Math.random()*4, t);				
			}					
		}
		
		
		private function locateClosest(p:MovieClip, c:MovieClip, a:Array, sX:Number, sY:Number) {
						
			var mX:Number;
			var mY:Number;
			var bestX:Number=-1;
			var bestY:Number=-1;
			var bestD:Number=1000000;
			var tempD:Number;
			
			for (var i:uint = 0; i<a.length; i++) {	
				if (!a[i]) {continue;}
				for (var j:uint = 0; j<a[i].length; j++) {
					if (!a[i][j]) {continue;}
					if (a[i][j] == 1) {
						mX = p.x+j*sX;
						mY = p.y+i*sY;
						tempD = Math.sqrt(Math.pow(mX-c.x, 2) + Math.pow(mY-c.y, 2));
						if (tempD < bestD) {
							bestD = tempD;
							bestX = j;
							bestY = i;							
						}
					}
				}
			}			
			if (bestD == 1000000) {
				return {x:c.x, y:c.y, alpha:0};
			} else {
				a[bestY][bestX] = 0;
				return {x:p.x+bestX*sX, y:p.y+bestY*sY, alpha:0};
			}
			
		}
						
	}

}