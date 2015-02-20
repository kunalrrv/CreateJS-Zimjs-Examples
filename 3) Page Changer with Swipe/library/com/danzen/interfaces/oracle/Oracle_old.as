package interfaces.oracle {

    import flash.display.Sprite;
    import flash.events.*;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.URLRequest;	
	
    public class Oracle extends Sprite {

		private var myDescriptorList:Array;
		private var myRadius:Number;
		private var myAngleList:Array;
		private var myValueList:Array;
		private var myFactor:Object; // total pixel length of all arms
		private var myStartX:Number;
		private var myStartY:Number;
		private var myCenterImage:String;
		private var myDescriptorImage:String;
		private var myArmImage:String;
		
		private var myHubLoader:Loader;	
		private var myHub:Sprite = new Sprite();
		private var myInnerHub:Sprite = new Sprite();
		private var currentHub:Object = null;
		
		private var armHolder:Sprite = new Sprite();
		
		private var currentDrag:Object = null;
		private var huX:Number;
		private var huMouseX:Number;
		private var huY:Number;
		private var huMouseY:Number;
		
		private var oracleArms:Array = [];
		private var defaultValues:Boolean = true;
		
		private var centerX:Number;
		private var centerY:Number;
		private var hubX:Number;
		private var hubY:Number;

		public function Oracle (
					theDescriptorList:Array=null,
					theRadius:Number=200,
					theCenterImage:String="",
					theDescriptorImage:String="",
					theArmImage:String="",
					
					theAngleList:Array=null,
					theValueList:Array=null,
					theFactor:Object=null, 
					theStartX:Number=.5,
					theStartY:Number=.5
					) {

			myDescriptorList = theDescriptorList;
			myRadius = theRadius;
			myAngleList = theAngleList;
			myValueList = theValueList;
			myFactor = theFactor;
			myStartX = theStartX;
			myStartY = theStartY;
			myCenterImage = theCenterImage;
			myDescriptorImage = theDescriptorImage;
			myArmImage = theArmImage;
			
			addEventListener(Event.ADDED_TO_STAGE, init);			
		}
		
		private function init(e:Event) {

			centerX = stage.stageWidth / 2;
			centerY = stage.stageHeight / 2;
			
			hubX = centerX - myRadius + myRadius*2*myStartX;
			hubY = centerY - myRadius + myRadius*2*myStartY;	
			
			myHub = new Sprite();
			myHub.x = hubX;
			myHub.y = hubY;	
			myHub.buttonMode = true;
			
			trace (myCenterImage);
			
			if (myCenterImage == "") {
				myHub.graphics.clear();
				myHub.graphics.beginFill(0x000000, .2);
				myHub.graphics.drawCircle(0,0,25);	
				addChild(myHub);
			} else {			
				myHubLoader = new Loader();
				myHubLoader.load(new URLRequest(myCenterImage));
				myHubLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, fixHub);
				myInnerHub.addChild(myHubLoader);
				myHub.addChild(myInnerHub);			 				
			}
			
			myHub.addEventListener(MouseEvent.MOUSE_DOWN, dragHub);
			stage.addEventListener(MouseEvent.MOUSE_UP, dropHub);
			
			if (myDescriptorList) {
				
				stage.addEventListener(MouseEvent.MOUSE_UP, dropArm);
				
				var i:uint;
				// check to see if we can use supplied values, angles and startX and Y
				if (myValueList && myAngleList) {
					if (myStartX && myStartY && myFactor) {
						for (i=0; i<myDescriptorList.length; i++) {
							if (myValueList[i] >= 0 && myAngleList[i] >= 0) {
								defaultValues = false;
							}
						}
					}
				}
									
				var angle:Number;
				var amount:Number;
				var arm:OracleArm;
				
				for (i=0; i<myDescriptorList.length; i++) {
					if (!defaultValues) {
						angle = myAngleList[i];
						amount = myValueList[i] * Number(myFactor);
					} else {
						myFactor = myDescriptorList.length * myRadius;
						angle = i / myDescriptorList.length * 360;
						amount = 1/myDescriptorList.length * Number(myFactor);
					}
					arm = new OracleArm(myDescriptorList[i], myRadius, angle, amount, myDescriptorImage)
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
				total += oracleArms[i].amount;
			}
			for (i=0; i<oracleArms.length; i++) {
				recipricalTotal += total - oracleArms[i].amount;
			}
			for (i=0; i<oracleArms.length; i++) {
				oracleArms[i].percent = percent = Math.round((total-oracleArms[i].amount) / recipricalTotal * 1000)/10;
				if (percent > maxPercent) {
					maxPercent = percent;
					maxPercentIndex = i;
				}
				percentTotal += percent;
			}			
			if (percentTotal != 100) {
				oracleArms[maxPercentIndex].percent = maxPercent + (percentTotal - 100);
			}		
		}
		
		private function fixHub(e:Event) {
			myInnerHub.x = - myHubLoader.width / 2;
			myInnerHub.y = - myHubLoader.height / 2;
			addChild(myHub);
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
			myHub.x = hubX = huX + mouseX - huMouseX;
			myHub.y = hubY = huY + mouseY - huMouseY;
			
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
			var dX:Number = mouseX - centerX;
			var dY:Number = mouseY - centerY;
			var mR:Number = Math.sqrt((Math.pow(dX, 2) + Math.pow(dY, 2)));
			var tX:Number = dX * myRadius / mR;
			var tY:Number = dY * myRadius / mR;			
			
			var hX:Number = centerX - hubX;
			var hY:Number = centerY - hubY;
			
			var oX:Number = hX + tX;
			var oY:Number = hY + tY;
			
			var amount:Number = Math.sqrt((Math.pow(oX, 2) + Math.pow(oY, 2)));						
			var angle:Number = Math.atan2(oY, oX) * 180 / Math.PI + 90;			
			
			currentDrag.angle = angle;
			currentDrag.amount = amount;		
			
			updateStats();
			trace (currentDrag.percent);
			
		}
		
    }
} 