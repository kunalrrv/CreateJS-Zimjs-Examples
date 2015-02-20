 package com.danzen.interfaces {

    import flash.display.Sprite;
    import flash.events.*;
	
	import com.danzen.utilities.ShapePlus;
    
    public class ExitButton extends Sprite {
        
		private var mySize:Number;
		private var myColor:Number;
		private var myRollColor:Number;
		private var myAlpha:Number;		
		
		private var exitRollCheck:Boolean = false;
		
        public function ExitButton(theSize:Number = 20, theColor:Number = 0xCCCCCC, theRollColor:Number = 0xFFD9E9, theAlpha:Number = .6) {
			
			mySize = theSize;
			myColor = theColor;
			myRollColor = theRollColor;
			myAlpha = theAlpha;			
			makeExit();
			
		}
		
		private function makeExit() {
			
			var highlightColor:Number;
			if (exitRollCheck) {
				highlightColor = myRollColor;
			} else {
				highlightColor = myColor;
			}
			//lineStyle(scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void 
			var rect = ShapePlus.makeRect(0,0,mySize,mySize,highlightColor,myAlpha,true,1,0x999999);
			rect.graphics.moveTo(0,0);
			rect.graphics.lineStyle(1,0x999999, .8, true, "normal", "square", "miter");
			rect.graphics.lineTo(mySize, mySize);	
			rect.graphics.moveTo(mySize, 0);	
			rect.graphics.lineTo(0, mySize);	
			if (stage) {removeChildAt(0);}
			addChild(rect);					
			buttonMode = true;			
			
			addEventListener(MouseEvent.ROLL_OVER, exitRoll);
			addEventListener(MouseEvent.ROLL_OUT, exitRoll);				
            
        }
		
		private function exitRoll(e:MouseEvent) {
			exitRollCheck = !exitRollCheck;
			makeExit();		
		}		
		
		public function dispose() {
			removeEventListener(MouseEvent.ROLL_OVER, exitRoll);
			removeEventListener(MouseEvent.ROLL_OUT, exitRoll);				
		}
        
    }
    
} 
