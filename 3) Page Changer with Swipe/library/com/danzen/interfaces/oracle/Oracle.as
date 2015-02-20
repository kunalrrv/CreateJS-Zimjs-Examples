package com.danzen.interfaces.oracle {

    import flash.display.Sprite;
    import flash.events.*;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;	
	
    public class Oracle extends Sprite {

		private var myDescriptorList:Array;
		private var myIconList:Array;
		private var myRadius:Number;
		private var myAngleList:Array;
		private var myPercentList:Array;
		private var myAmountList:Array;
		private var myRotateIcons:Boolean;
		private var myCenterX:Number;
		private var myCenterY:Number;		
		private var myStartX:Number;
		private var myStartY:Number;
		private var myCenterImage:Sprite;
		private var myArmImage:String;
		private var myBuffer:Number;
		
		private var myHubLoader:Loader;	
		private var myHub:Sprite = new Sprite();
		private var myInnerHub:Sprite = new Sprite();
		private var currentHub:Object = null;
		
		private var armHolder:Sprite = new Sprite();
		private var ringHolder:Sprite = new Sprite();
		
		private var currentDrag:Object = null;
		private var huX:Number;
		private var huMouseX:Number;
		private var huY:Number;
		private var huMouseY:Number;
		
		private var oracleArms:Array = [];
		private var defaultValues:Boolean = true;
		
		private var hubX:Number;
		private var hubY:Number;

		public function Oracle (
					theDescriptorList:Array=null,
					theIconList:Array=null,					
					theRadius:Number=200,
					theCenterX:Number=300,
					theCenterY:Number=300,
					theBuffer:Number=0,
					theCenterImage:Sprite=null,
					theRotateIcons:Boolean=false,
					theArmImage:String="",
					
					theAngleList:Array=null,
					theAmountList:Array=null,
					theStartX:Number=.5,
					theStartY:Number=.5
					) {

			myDescriptorList = theDescriptorList;
			myIconList = theIconList;
			myRadius = theRadius;
			myCenterX = theCenterX;
			myCenterY = theCenterY;
			myBuffer = theBuffer;
			myCenterImage = theCenterImage;
			myRotateIcons = theRotateIcons;
			myArmImage = theArmImage;			
			
			myAngleList = theAngleList;
			myAmountList = theAmountList;	
			myStartX = theStartX;
			myStartY = theStartY;
			
			addEventListener(Event.ADDED_TO_STAGE, init);			
		}
		
		private function init(e:Event) {

			
			hubX = myCenterX - myRadius + myRadius*2*myStartX;
			hubY = myCenterY - myRadius + myRadius*2*myStartY;	
			
			myHub = new Sprite();
			myHub.x = hubX;
			myHub.y = hubY;	
			myHub.buttonMode = true;
			
			if (!myCenterImage) {
				myHub.graphics.clear();
				myHub.graphics.beginFill(0x000000, .8);
				myHub.graphics.drawCircle(0,0,25);	
			} else {			
				myHub.addChild(myCenterImage);
			}
			addChild(myHub);
			
			myHub.addEventListener(MouseEvent.MOUSE_DOWN, dragHub);
			stage.addEventListener(MouseEvent.MOUSE_UP, dropHub);
			
			if (myDescriptorList) {
				
				stage.addEventListener(MouseEvent.MOUSE_UP, dropArm);
				
				var i:uint;
				// check to see if we can use supplied values, angles and startX and Y
				if (myAmountList && myAngleList) {
					if (myStartX && myStartY) {
						var myCheck:Boolean = true;
						for (i=0; i<myDescriptorList.length; i++) {
							if (!myAmountList[i] || !myAngleList[i]) {
								myCheck = false;
							}
						}
						if (myCheck) {
							defaultValues = false;
						}
					}
				}
				
				//ringHolder.graphics.lineStyle(60,0xFBD1FC,.3);
				//ringHolder.graphics.lineStyle(70,0x339999,.1);
				//ringHolder.graphics.lineStyle(70,0x339999,.2);
				ringHolder.graphics.lineStyle(70,0x6699cc,.2);
				ringHolder.graphics.drawCircle(0,0,200);						
				ringHolder.x = myCenterX;
				ringHolder.y = myCenterY;
				addChild(ringHolder);
									
				var angle:Number;
				var amount:Number;
				var arm:OracleArm;
			
				
				for (i=0; i<myDescriptorList.length; i++) {
					if (!defaultValues) {
						angle = myAngleList[i];
						amount = myAmountList[i];
					} else {						
						angle = i / myDescriptorList.length * 360;
						amount = myRadius;
					}
					var descriptorImage:Sprite = null;
					if (myIconList) {
						if (myIconList[i]) {
							descriptorImage = myIconList[i];
						}
					}
					arm = new OracleArm(myDescriptorList[i], myRadius, (angle-180)*-1, amount, descriptorImage, myRotateIcons)
					armHolder.addChild(arm);					
					addChild(armHolder);
					setChildIndex(myHub, numChildren-1);
					oracleArms.push(arm);
					arm.buttonMode = true;
					arm.addEventListener(MouseEvent.MOUSE_DOWN, dragArm);
					
					
				}				
				armHolder.x = hubX;
				armHolder.y = hubY;
			}			
			
			//updateStats();
			//updateArms();	

		}
		
		private function updateStats() {
			var total:Number = 0;
			var i:uint;
			var maxPercent:Number = 0;
			var maxPercentIndex:Number = -1;
			var percent:Number;
			var percentTotal:Number = 0;
			var recipricalTotal:Number = 0;
			
			for (i=0; i<oracleArms.length; i++) {
				total += myRadius * 2 - myBuffer - oracleArms[i].amount;
			}
			for (i=0; i<oracleArms.length; i++) {
				oracleArms[i].percent = percent = Math.round((myRadius * 2 - myBuffer - oracleArms[i].amount) / total * 1000)/10;
				oracleArms[i].percentFull = (myRadius * 2 - myBuffer - oracleArms[i].amount) / total * 100;
				if (percent >= maxPercent) {
					maxPercent = percent;
					maxPercentIndex = i;
				}
				percentTotal += percent;
			}			
			if (percentTotal != 100) {
				oracleArms[maxPercentIndex].percent = Math.round((maxPercent - (percentTotal - 100)) *10) / 10;
			}		
		}
		
		
		private function dragHub(e:MouseEvent) {
			currentHub = e.currentTarget
			huX = currentHub.x
			huMouseX = mouseX;
			huY = currentHub.y
			huMouseY = mouseY;			
			stage.addEventListener(Event.ENTER_FRAME, moveHub);
		}
		
		private function dropHub(e:MouseEvent) {
			if (currentHub != null) {
				stage.removeEventListener(Event.ENTER_FRAME, moveHub);
			}
			currentHub = null;
		}				
		
		private function moveHub(e:Event) {
			
			var lastHubX = hubX;
			var lastHubY = hubY;
			hubX = huX + mouseX - huMouseX;
			hubY = huY + mouseY - huMouseY;
			
			// don't drag outside the circle's buffer
			var mX:Number = hubX - myCenterX;
			var mY:Number = hubY - myCenterY;			
			var mR:Number = Math.sqrt((Math.pow(mX, 2) + Math.pow(mY, 2)));	
			var oR:Number = myRadius - myBuffer;
			if (mR > oR) { // the mouse is outside the buffer circle
				hubX = oR / mR * (hubX - myCenterX) + myCenterX;
				hubY = oR / mR * (hubY - myCenterY) + myCenterY;
			}			
			myHub.x = hubX;
			myHub.y = hubY;
			
			//loop through each arm and reset angle and amount
			var dX:Number;
			var dY:Number;
			for (var i:uint=0; i<oracleArms.length; i++) {
				dX = lastHubX + oracleArms[i].orbX - hubX;
				dY = lastHubY + oracleArms[i].orbY - hubY;
				oracleArms[i].amount = Math.sqrt((Math.pow(dX, 2) + Math.pow(dY, 2)));						
				oracleArms[i].angle = Math.atan2(dY, dX) * 180 / Math.PI + 90;		
			}
			armHolder.x = hubX;
			armHolder.y = hubY;			
			
			updateStats();
		}		
		
		private function dragArm(e:MouseEvent) {
			currentDrag = e.currentTarget
			armHolder.setChildIndex(Sprite(currentDrag), armHolder.numChildren-1);			
			stage.addEventListener(Event.ENTER_FRAME, moveHand);
		}
		
		private function dropArm(e:MouseEvent) {
			if (currentDrag != null) {
				stage.removeEventListener(Event.ENTER_FRAME, moveHand);
			}
			currentDrag = null;
		}					
		
		private function moveHand(e:Event) {
			var dX:Number = mouseX - myCenterX;
			var dY:Number = mouseY - myCenterY;
			var mR:Number = Math.sqrt((Math.pow(dX, 2) + Math.pow(dY, 2)));
			var tX:Number = dX * myRadius / mR;
			var tY:Number = dY * myRadius / mR;			
			
			var hX:Number = myCenterX - hubX;
			var hY:Number = myCenterY - hubY;
			
			var oX:Number = hX + tX;
			var oY:Number = hY + tY;
			
			var amount:Number = Math.sqrt((Math.pow(oX, 2) + Math.pow(oY, 2)));						
			var angle:Number = Math.atan2(oY, oX) * 180 / Math.PI + 90;			
			
			//loop through each arm and reset angle and amount
			updateArms();
			
			currentDrag.angle = angle;
			currentDrag.amount = amount;		
			
			updateStats();
			
		}
		
		private function updateArms() {
			var dX:Number;
			var dY:Number;
			for (var i:uint=0; i<oracleArms.length; i++) {
				dX = oracleArms[i].orbX;
				dY = oracleArms[i].orbY;
				oracleArms[i].amount = Math.sqrt((Math.pow(dX, 2) + Math.pow(dY, 2)));						
				oracleArms[i].angle = Math.atan2(dY, dX) * 180 / Math.PI + 90;		
			}				
		}		
		
		// get methods - properties
		
		public function get angleList () {
			var a:Array = [];
			for (var i:uint=0; i<oracleArms.length; i++) {
				a.push(oracleArms[i].angle);
			}
			return a;
		}		
		
		public function get percentList () {
			var a:Array = [];
			for (var i:uint=0; i<oracleArms.length; i++) {
				a.push(oracleArms[i].percent);
			}
			//trace (a[0],a[1],a[2],a[3],a[4],a[5]);
			return a;
		}
	
		public function get amountList () {
			var a:Array = [];
			for (var i:uint=0; i<oracleArms.length; i++) {
				a.push(oracleArms[i].amount);
			}
			return a;
		}		
			
		public function get oracleX () {	
			return (hubX - myCenterX + myRadius) / myRadius / 2;
		}
		
		public function get oracleY () {
			return (hubY - myCenterY + myRadius) / myRadius / 2;
		}				

    }
	
} 