package com.danzen.frameworks.zenmvc {
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.*;
	import com.danzen.utilities.HummingBird;
	import com.danzen.interfaces.Pane;
	
	public class ZenView extends Sprite {
		
		private var paneHolder:Array = [];
		
		public function ZenView() {
			trace ("hi from ZenView Abstract Class");
		}
		
		public function pane(theW:Number=300,
					theH:Number=200,
					theExit:Boolean=true,
					theDrag:Boolean=true,
					theColor:Number=0xFFFFFF,
					theAlpha:Number=.7,
					theCurve:Boolean=true,
					theBar:Boolean=false,
					theModal:Boolean=false) {			
			var p:Pane = new Pane(theW,theH,theDrag,theColor,theAlpha,theCurve,theBar,theModal);
			if (!theExit) {p.myExit.x = -2000;}
			p.addEventListener(Pane.EXIT, function(e:Event) {p.x=-2000; p.dispose();});
			paneHolder.push(p);			
			return p;		
		}
		
		public function parallax(theObject:DisplayObject,
					theShiftX:Number=10,
					theShiftY:Number=10,
					theShiftZ:Number=10,
					theDamping:Number=.1) {
			return new HummingBird(theObject,theShiftX,theShiftY,theShiftZ,theDamping);
		}
		
	}	
	
}