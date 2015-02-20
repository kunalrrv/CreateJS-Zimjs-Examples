package com.danzen.interfaces.oracle {

    import flash.display.Sprite;
    import flash.events.*;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	
    public class OracleArm extends Sprite {

		private var myDescriptor:String;
		private var myRadius:Number;
		private var myAngle:Number;
		private var myAmount:Number;
		private var myDescriptorImage:Sprite;
		private var myRotateIcons:Boolean;
		private var myArmImage:String;		
		
		private var myOrbX:Number;
		private var myOrbY:Number;
		private var myPercent:Number = 0;
		private var myPercentFull:Number = 0;
		
		private var myArm:Sprite = new Sprite();
		private var myInnerArm:Sprite = new Sprite(); // handle rotation
		private var myOrb:Sprite = new Sprite();
		private var myInnerOrb:Sprite = new Sprite(); // handle rotation
		
		private var myArmLoader:Loader;
		private var myOrbLoader:Loader;
		
		private var myTextHolder:Sprite;
		private var myText:TextField;
		private var myTextFormat:TextFormat;
		private var myDText:TextField;
		private var myDTextFormat:TextFormat;		
		
		public function OracleArm (
					theDescriptor:String,
					theRadius:Number,
					theAngle:Number,
					theAmount:Number,
					theDescriptorImage:Sprite=null,
					theRotateIcons:Boolean=false,
					theArmImage:String=""
					) {

			myDescriptor = theDescriptor;
			myRadius = theRadius;
			myAmount = theAmount;
			myAngle = theAngle;
			myDescriptorImage = theDescriptorImage;
			myRotateIcons = theRotateIcons
			myArmImage = theArmImage;

			if (myDescriptorImage) {
				myOrb.addChild(myDescriptorImage);
			} 
			
			if (myArmImage) {
				myArmLoader = new Loader();
				myArmLoader.load(new URLRequest(myArmImage));
				myArmLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, fixArm);
				myInnerArm.addChild(myArmLoader);
				myArm.addChild(myInnerArm);
			} 
			
			myText = new TextField();
			myText.embedFonts = true;			
			myText.alpha = .5;
			myText.selectable = false;
			myText.autoSize = TextFieldAutoSize.CENTER;
			myTextFormat = new TextFormat("Arial",10,0xCC0000);		
			myTextFormat.align = TextFormatAlign.CENTER;
			
			myDText = new TextField();
			myDText.embedFonts = true;			
			myDText.alpha = .25;
			myDText.selectable = false;
			myDText.autoSize = TextFieldAutoSize.CENTER;
			myDTextFormat = new TextFormat("Agency FB",16,0x000000);		
			myDTextFormat.align = TextFormatAlign.CENTER;			
			
						
			setPosition();
						
			addChild(myArm);
			addChild(myOrb);
			addChild(myText);	
			addChild(myDText);
			
		}
		
		private function fixArm(e:Event) {
			myInnerArm.x = - myArmLoader.width / 2;
			myInnerArm.height = myAmount - myInnerOrb.height/2;
			trace (myInnerArm.x);
		}
		
		private function fixOrb(e:Event) {
			myInnerOrb.x = - myOrbLoader.width / 2;
			myInnerOrb.y = - myOrbLoader.height / 2;
		}		
		
		private function setPosition() {
			
			myOrb.x = myAmount * Math.sin(myAngle * Math.PI / 180);
			myOrb.y = myAmount * Math.cos(myAngle * Math.PI / 180);
			
			var myOrbAngle:Number = Math.atan2(myOrb.y, myOrb.x);

			if (myDescriptorImage) {
				if (myRotateIcons) {
					myOrb.rotation = myOrbAngle * 180 / Math.PI + 90;
				}
			} else {
				myOrb.graphics.clear();
				myOrb.graphics.beginFill(0xDDDDDD, 1);
				myOrb.graphics.lineStyle(1,0xBBBBBB, 1);
				myOrb.graphics.drawCircle(0,0,20);		
				
			}

			
			if (myArmImage) {
				myArm.rotation = myAngle - 180;						
			} else {
				myArm.graphics.clear();
				myArm.graphics.lineStyle(2,0x000000,.1);
				myArm.graphics.lineTo(myOrb.x, myOrb.y);	
			}
			
			myText.x = myOrb.x / 2;
			myText.y = myOrb.y / 2;
			myText.text = String(myPercent)+"%";
			myText.setTextFormat(myTextFormat);			
			
			myDText.text = myDescriptor;
			myDText.x = myOrb.x-3;
			myDText.y = myOrb.y+30;			
			myDText.setTextFormat(myDTextFormat);						
			
			
		}
		
		// getter setter methods
		
		
		public function set amount (theAmount:Number) {
			myAmount = theAmount;
			setPosition();
		}
		
		public function get amount () {
			return myAmount;
		}		
		
		public function set angle (theAngle:Number) {
			myAngle = theAngle * -1 - 180;
			setPosition();
		}
		
		public function get angle () {
			return (myAngle + 180) * -1;
		}
		
		public function get orbX () {
			return myOrb.x;
		}
		
		public function get orbY () {
			return myOrb.y;
		}		
		
		public function set percent (thePercent:Number) {
			myPercent = thePercent;
		}
		
		public function get percent () {
			return myPercent;
		}		
		
		public function set percentFull (thePercent:Number) {
			myPercentFull = thePercent;
		}
		
		public function get percentFull () {
			return myPercentFull;
		}			
		
		
    }
} 