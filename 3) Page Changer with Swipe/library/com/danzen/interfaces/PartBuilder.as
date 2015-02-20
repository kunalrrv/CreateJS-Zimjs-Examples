package com.danzen.interfaces{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.utils.getDefinitionByName;
	
	import com.greensock.*;
	import com.greensock.easing.*;	

	public class PartBuilder extends MovieClip {

		private var myClasses:Array;
		private var myClasses2:Array;
		private var myBuilderClass:Class;
		private var myAlpha:Number;
		private var myResizeMin:Number;
		private var myResizeMax:Number;
		private var myBody:MovieClip;

		private var b:MovieClip; // builder stage		
		private var current:MovieClip;
		private var currentBut:MovieClip;
		private var so:SharedObject;
		private var currentSide:String;

		public function PartBuilder(
		theBuilderClass:Class,
		theClasses:Array,
		theClasses2:Array,
		theAlpha:Number=.8,
		theResizeMin:Number=.5,
		theResizeMax:Number=1.5,
		theBody:MovieClip=null) {

			trace("hi from PartBuilder");

			myBuilderClass=theBuilderClass;
			myClasses=theClasses;
			myClasses2=theClasses2;
			myAlpha = theAlpha;
			myResizeMin=theResizeMin;
			myResizeMax=theResizeMax;
			myBody=theBody;

			b = new myBuilderClass();
			addChild(b);
			b.addEventListener(Event.ADDED_TO_STAGE, init);

			so=SharedObject.getLocal("nano2030");			

		}

		private function init(e:Event) {
			b.x=240;
			b.y=150;

			if (myBody) {
				myBody.className="BodyBuilder";
				b.bStage.addChild(myBody);
				myBody.addEventListener(MouseEvent.CLICK, bodyClick);
			}

			var spacing:Number=44;

			var temp:MovieClip;
			
			for (var i:uint=0; i<myClasses.length; i++) {
				trace (i, myClasses[i]);
				temp = MovieClip(new myClasses[i]());
				temp.classRef=myClasses[i];
				temp.className=temp.classRef.toString().split(" ")[1].split("]")[0];
				b.scrollLeft.addChild(temp);
				temp.mouseChildren = false;
				temp.x=75/2;
				temp.y=spacing/1.5+i*spacing;
				temp.buttonMode=true;
				temp.addEventListener(MouseEvent.CLICK, transfer);
			}
			for (i=0; i<myClasses2.length; i++) {
				temp = MovieClip(new myClasses2[i]());
				temp.classRef=myClasses2[i];
				temp.className=temp.classRef.toString().split(" ")[1].split("]")[0];
				b.scrollRight.addChild(temp);
				temp.mouseChildren = false;
				temp.x=75/2;
				temp.y=spacing/1.5+i*spacing;
				temp.buttonMode=true;
				temp.addEventListener(MouseEvent.CLICK, transfer2);
			}			
			b.buttons.addEventListener(MouseEvent.MOUSE_OVER, bright);
			b.buttons.addEventListener(MouseEvent.MOUSE_OUT, dim);
			b.buttons.addEventListener(MouseEvent.CLICK, manage);
			b.buttons.addEventListener(MouseEvent.MOUSE_DOWN, high);
			b.buttons.addEventListener(MouseEvent.MOUSE_UP, low);
			stage.addEventListener(MouseEvent.MOUSE_UP, low);

			//so.data.currentSetting = null;			
			//so.data.undoList = null;
			//so.data.redoList = null;
			
			if (so.data.currentSetting) {
				setState(so.data.currentSetting);
			} else {
				so.data.currentSetting=[];
				so.data.undoList=[];
				so.data.redoList=[];
			}
			
			getState();
			
			if (b.scrollLeft.height + 10 > b.backingSlider.height) {
				b.leftBar.knob.addEventListener(MouseEvent.MOUSE_OVER, bright);
				b.leftBar.knob.addEventListener(MouseEvent.MOUSE_OUT, dim);			
				b.leftBar.knob.addEventListener(MouseEvent.MOUSE_DOWN, dragBar);
				b.leftBar.knob.buttonMode = true;
			}
			
			if (b.scrollRight.height + 10 > b.backingSlider.height) {
				b.rightBar.knob.addEventListener(MouseEvent.MOUSE_OVER, bright);
				b.rightBar.knob.addEventListener(MouseEvent.MOUSE_OUT, dim);			
				b.rightBar.knob.addEventListener(MouseEvent.MOUSE_DOWN, dragBar);
				b.rightBar.knob.buttonMode = true;		
			}
			
			stage.addEventListener(MouseEvent.MOUSE_UP, dropBar);
			stage.addEventListener(Event.ENTER_FRAME, slideBar);			
			
		}
		
		public function bodyChanged() {
			getState();
		}

		
		private function dragBar(e:MouseEvent) {
			var knob:MovieClip = MovieClip(e.currentTarget);
			var bar:MovieClip = MovieClip(knob.parent).bar;
			knob.startDrag(false, new Rectangle(bar.x, 0, 0, bar.height-knob.height));
			knob.filters=[new GlowFilter(0x66CCFF,.3,20,20,2,3,true)];
			if (knob == b.leftBar.knob) {
				currentSide = "left";
				TweenMax.to(b.glowlineLeft, .8, {yoyo:true, alpha:1, repeat:1, glowFilter:{color:0x3399ff, alpha:.6, blurX:2, blurY:2}, ease:Sine.easeInOut});					

			} else {
				currentSide = "right";
				TweenMax.to(b.glowlineRight, .8, {yoyo:true, alpha:1, repeat:1, glowFilter:{color:0x3399ff, alpha:.6, blurX:2, blurY:2}, ease:Sine.easeInOut});					

			}			
		}
		
		private function dropBar(e:MouseEvent) {
			b.leftBar.knob.stopDrag();
			b.leftBar.knob.filters=[];
			b.rightBar.knob.stopDrag();
			b.rightBar.knob.filters=[];
		}
		
		private function slideBar(e:Event) {
			var easing:Number = .2;
			var bar:MovieClip;
			var knob:MovieClip;
			var slider:MovieClip;
			if (currentSide == "left") {				
				bar = b.leftBar.bar;
				knob = b.leftBar.knob;
				slider = b.scrollLeft;
			} else {
				bar = b.rightBar.bar;
				knob = b.rightBar.knob;
				slider = b.scrollRight;
			}
			var newY:Number = -knob.y * (slider.height*1.14-bar.height) / bar.height;
			var diff:Number = slider.y - newY;			
			if (diff < 1) {
				slider.y = slider.y - diff;
			} else {
				slider.y = slider.y - diff * easing;
			}
				
		}
		
		private function transfer(e:MouseEvent) {
			currentSide = "left";
			doTransfer(MovieClip(e.currentTarget));
		}
		
		private function transfer2(e:MouseEvent) {
			currentSide = "right";
			doTransfer(MovieClip(e.currentTarget));
		}
		
		private function doTransfer(t:MovieClip) {
			trace ("transfer");			
			var temp:MovieClip = MovieClip(t);			
			var part:MovieClip = MovieClip(new temp.classRef());
			part.classRef=temp.classRef;
			part.className=temp.classRef.toString().split(" ")[1].split("]")[0];
			b.bStage.addChild(part);
			if (currentSide == "left") {				
				part.x = 26;
				TweenMax.to(b.electricityLeft, .8, {alpha:1, yoyo:true, repeat:1, glowFilter:{color:0x3399ff, alpha:.6, blurX:20, blurY:20}, ease:Sine.easeInOut});					
			} else {
				part.x = 174;
				TweenMax.to(b.electricityRight, .8, {alpha:1, yoyo:true, repeat:1, glowFilter:{color:0x3399ff, alpha:.6, blurX:20, blurY:20}, ease:Sine.easeInOut});					
			}
			part.y = 30;
			part.alpha = myAlpha;
			part.buttonMode = true;
			part.mouseChildren = false;
			part.addEventListener(MouseEvent.MOUSE_DOWN, dragMe);
			current = part;
			getState();			
		}
		
		private function setState(s:Array) {	
			var temp:Array;											
			var cur:MovieClip;						
			var len:Number = b.bStage.numChildren;
			var min:Number = 0;
			if (myBody) {				
				min=1;
				b.bStage.setChildIndex(myBody,0);				
			}
			if (len > 0) { // children other than body
				for (var i:Number=len-1; i>=min; i--) {
					cur = MovieClip(b.bStage.getChildAt(i));
					cur.removeEventListener(MouseEvent.MOUSE_DOWN, dragMe);				
					b.bStage.removeChild(cur);
					cur = null;
				}		
			}
			var newCurrent:Number = -1;
			if (s) {
				for (i=1; i<s.length; i++) {				
					temp = s[i];				
					if (temp[0] == "BodyBuilder") {
						b.bStage.setChildIndex(myBody, b.bStage.numChildren-1);
						myBody.controlX = temp[6];
						myBody.controlY = temp[7];	
						myBody.remoteDraw();
						continue;
					}					
					
					cur = new (getDefinitionByName(temp[0]))();				
					cur.classRef=getDefinitionByName(temp[0]);
					cur.className=temp[0];
					
					b.bStage.addChild(cur);
					cur.x=temp[1];
					cur.y=temp[2];
					cur.rotation=temp[3];
					cur.scaleX=temp[4];
					cur.scaleY=temp[5];
					cur.buttonMode=true;
					cur.mouseChildren = false;
					cur.alpha = myAlpha;
					cur.addEventListener(MouseEvent.MOUSE_DOWN, dragMe);
				}
				newCurrent = Number(s[0]);	
			}
			
			if (newCurrent >= 0) {
				current = b.bStage.getChildAt(newCurrent);
			} else {
				current = null;
			}
			
		}		


		private function getState() {
			// [currentIndex,[p,x,y,r,sX,sY,cX(only for body),cY(only for body)],[]]
								
			var partsArray:Array;
			var part:MovieClip;
			if (current) {
				partsArray=[b.bStage.getChildIndex(current)];
			} else {
				partsArray=[-1];
			}
			for (var i:uint = 0; i<b.bStage.numChildren; i++) {
				part=b.bStage.getChildAt(i);
				var arr:Array=[];

				arr.push(part.className);
				arr.push(String(dec(part.x, 2)));
				arr.push(String(dec(part.y, 2)));
				arr.push(String(dec(part.rotation, 2)));
				arr.push(String(dec(part.scaleX, 2)));
				arr.push(String(dec(part.scaleY, 2)));

				if (arr[0]=="BodyBuilder") {
					arr.push(String(dec(part.controlX, 2)));
					arr.push(String(dec(part.controlY, 2)));
				}
				partsArray.push(arr);				
			}
			if (so.data.currentSetting.length > 0) {
				so.data.undoList.push(so.data.currentSetting);
				if (so.data.undoList.length > 100) {
					so.data.undoList.shift();
				}
			}
			so.data.currentSetting=partsArray;
			so.data.redoList=[];	
			
		}

		private function manage(e:MouseEvent) {
			
			var newState:Array;
						
			if (e.target.name == "bUndo") {
				
				if (so.data.undoList.length > 0) {
					newState = so.data.undoList.pop();
					setState(newState);				
					so.data.redoList.push(so.data.currentSetting);
					so.data.currentSetting = newState;					
				}
				return;
			} else if (e.target.name == "bRedo") {	
				if (so.data.redoList.length > 0) {
					newState = so.data.redoList.pop();
					setState(newState);				
					so.data.undoList.push(so.data.currentSetting);
					so.data.currentSetting = newState;					
				}
				return;
			} else if (e.target.name == "bClear") {	
				setState([]);	
				getState()
				
				return;				
			} else if (e.target.name == "bSave") {												
				dispatchEvent(new Event(Event.COMPLETE));						
				return;
			}			
			
			if (!current) {
				return;
			}
			switch (e.target.name) {
				case "bRotate" :
					if (current.className=="BodyBuilder") {
						break;
					}
					current.rotation+=5;
					break;
				case "bRotate2" :
					if (current.className=="BodyBuilder") {
						break;
					}
					current.rotation-=5;
					break;					
				case "bFlip" :
					if (current.className=="BodyBuilder") {
						break;
					}
					current.scaleX=- current.scaleX;
					break;
				case "bUp" :
					b.bStage.setChildIndex(current, Math.min(b.bStage.getChildIndex(current)+1, b.bStage.numChildren-1));
					break;
				case "bDown" :
					b.bStage.setChildIndex(current, Math.max(b.bStage.getChildIndex(current)-1, 0));
					break;
				case "bPlus" :
					if (current.className=="BodyBuilder") {
						break;
					}
					
					current.scaleX*=1.1;					
					current.scaleY*=1.1;
					if (Math.abs(current.scaleX)>myResizeMax) {
						current.scaleX/=1.1;
						current.scaleY/=1.1;
					}
					break;
				case "bMinus" :
					if (current.className=="BodyBuilder") {
						break;
					}
					current.scaleX/=1.1;
					current.scaleY/=1.1;
					if (Math.abs(current.scaleX)<myResizeMin) {
						current.scaleX*=1.1;
						current.scaleY*=1.1;
					}
					break;
				case "bDelete" :
					if (current.className=="BodyBuilder") {
						break;
					}
					b.bStage.removeChild(current);
					current=null;
					break;					
			}

			getState();
		}




		private function dec(num:Number, dec:Number) {
			return Math.round(num * Math.pow(10, dec)) / Math.pow(10, dec);
		}

		private function bright(e:MouseEvent) {
			e.target.alpha=.8;
			if (currentBut) {
				currentBut.filters=[new GlowFilter(0x66CCFF,.3,20,20,2,3,true)];
			}
		}

		private function dim(e:MouseEvent) {
			e.target.alpha=.5;
			if (currentBut) {
				currentBut.filters=[];
			}
		}

		private function high(e:MouseEvent) {
			currentBut=MovieClip(e.target);
			currentBut.filters=[new GlowFilter(0x66CCFF,.3,20,20,2,3,true)];
		}

		private function low(e:MouseEvent) {
			if (currentBut) {
				currentBut.filters=[];
			}
			currentBut=null;
		}

		private function dragMe(e:MouseEvent) {
			stage.addEventListener(MouseEvent.MOUSE_UP, dropMe);
			current=MovieClip(e.target);
			current.startDrag(false,new Rectangle(0,0,200,200));
		}

		private function dropMe(e:MouseEvent) {
			current.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, dropMe);
			getState();
		}

		private function bodyClick(e:MouseEvent) {
			current=MovieClip(e.currentTarget);
			getState();
		}

	}
}