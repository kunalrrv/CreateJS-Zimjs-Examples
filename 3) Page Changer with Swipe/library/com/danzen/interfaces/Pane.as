
package com.danzen.interfaces {
    
    import flash.display.Sprite;
    import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.filters.BitmapFilterQuality
	
	import com.danzen.interfaces.ExitButton;
    
    public class Pane extends Sprite {
		
		public static const EXIT:String = "exit";
		
		private var myW:Number;
		private var myH:Number;
		private var myDrag:Boolean;
		private var myColor:Number;
		private var myAlpha:Number;
		private var myCurve:Boolean;
		private var myBar:Boolean;
		private var myModal:Boolean;
		private var myModalColor:Number;
		private var myModalAlpha:Number;
		
		private var myBack:Sprite;
		private var myFront:Sprite;
		public var myExit:ExitButton;
		
		public var bar:Sprite;
		public var backing:Sprite;
		
	
		public function Pane (
					theW:Number=300,
					theH:Number=200,
					theDrag:Boolean=true,
					theColor:Number=0xFFFFFF,
					theAlpha:Number=1,
					theCurve:Boolean=false,
					theBar:Boolean=false,
					theModal:Boolean=false,
					theModalColor:Number=0xffffff,
					theModalAlpha:Number=.6) {
	
			myW = theW;
			myH = theH;
			myDrag = theDrag;
			myColor = theColor;
			myAlpha = theAlpha;
			myCurve = theCurve;
			myBar = theBar;
			myModal = theModal;
			myModalColor = theModalColor;
			myModalAlpha = theModalAlpha;
			
			trace ("hi from Pane");
			
			myBack = new Sprite();
			myFront = new Sprite();
			
			if (myModal) {
				backing = new Sprite();			
				with (backing.graphics) {
					beginFill(myModalColor, myModalAlpha);				
					drawRect(-2000,-2000,4000,4000);				
				}
				addChild(backing);
			}
			
			var myShapes:Array = [myBack, myFront];
			var temp:Sprite;
			for (var i:uint=0; i < myShapes.length; i++) {
				temp = myShapes[i];
				with (temp.graphics) {
					lineStyle(2, 0x000000, .04);
					if (i==0) {
						beginFill(this.myColor);
					} else {
						beginFill(this.myColor, this.myAlpha);
					}
					var miter:Number = 12;
					if (this.myCurve) {
						moveTo(0,theH);
						lineTo(0,miter);
						curveTo(0,0,miter,0);
						lineTo(this.myW-miter,0);
						curveTo(this.myW,0,this.myW,miter);
						lineTo(this.myW,this.myH);						
					} else {					
						drawRect(0,0,this.myW,this.myH);
					}
				}
				addChild(temp);
			}
			myBack.filters = [new DropShadowFilter(10, 45, 0x666666, 1, 17, 17, .7, BitmapFilterQuality.HIGH, false, true, false)];		
			
			
			bar = new Sprite();
			var barHeight = 34;
			with (bar.graphics) {
				beginFill(0, .2);
				if (this.myCurve) {
					moveTo(0,barHeight);
					lineTo(0,miter);
					curveTo(0,0,miter,0);
					lineTo(this.myW-miter,0);
					curveTo(this.myW,0,this.myW,miter);
					lineTo(this.myW,barHeight);						
				} else {					
					drawRect(0,0,this.myW,barHeight);
				}
			}
			addChild(bar);

			if (myDrag) {
				bar.buttonMode = true;
				bar.addEventListener(MouseEvent.MOUSE_DOWN, dragWindow);	
			}

			if (myBar) {bar.alpha = 1;} else {bar.alpha = 0;}
			
			myExit = new ExitButton(16);
			var spacing:Number = 10;
			myExit.x = myW - spacing - myExit.width;
			myExit.y = spacing;
			myExit.alpha = .6;
			addChild(myExit);
			myExit.addEventListener(MouseEvent.CLICK, exitClick);			
			
						
			
		}	

		private function dragWindow(e:MouseEvent) {
			this.startDrag()
			stage.addEventListener(MouseEvent.MOUSE_UP, dropWindow);
		}
		
		private function dropWindow(e:MouseEvent) {
			this.stopDrag()
			stage.removeEventListener(MouseEvent.MOUSE_UP, dropWindow);
		}				

		private function exitClick(e:MouseEvent) {
			dispatchEvent(new Event(Pane.EXIT));
		}

		public function dispose() {
			if (myDrag) {
				bar.removeEventListener(MouseEvent.MOUSE_DOWN, dragWindow);	
			}
			myExit.removeEventListener(MouseEvent.CLICK, exitClick);
			myExit.dispose();
		}
        
    }
    
} 

