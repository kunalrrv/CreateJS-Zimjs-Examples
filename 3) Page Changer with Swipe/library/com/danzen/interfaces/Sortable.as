package com.danzen.interfaces {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import flash.geom.Rectangle;	
	
	public class Sortable extends MovieClip {
		
		private var holder:MovieClip;
		private var positions:Array = new Array();
		public var current:MovieClip;
		private var ave:Number;
		private var constantY:Number;
		private var garbage:MovieClip;
		public var sensitivity:Number;
		public static const GARBAGE:String = "garbage";
		public static const DROP:String = "drop";
		private var dragCheck:Boolean = true;
		private var lastNum:Number = -1;
		private var myDraggable:Boolean = true;
		
		public function Sortable(theHolder:MovieClip, theGarbage:MovieClip=null, theSensitivity:Number=.5) {
			
			trace ("hi from Sortable");
			holder = theHolder;
			garbage = theGarbage;
			sensitivity = theSensitivity;
			holder.buttonMode = true;
			var clip:MovieClip;
			for (var i:uint=0; i<holder.numChildren; i++) {
				clip = MovieClip(holder.getChildAt(i));
				clip.mouseChildren=false;
				positions.push({clip:clip,x:clip.x});
			}			
			positions.sortOn("x", Array.NUMERIC);
			for (i=0; i<positions.length; i++) {
				positions[i].clip.sortableNum = i;
			}
			ave = (positions[positions.length-1].x-positions[0].x)/(positions.length-1);
			constantY = clip.y;
			holder.addEventListener(MouseEvent.MOUSE_DOWN, dragMe);			
		}
		public function set draggable(theDrag:Boolean) {
			if (theDrag != myDraggable) {
				if (theDrag) {
					holder.addEventListener(MouseEvent.MOUSE_DOWN, dragMe);	
					holder.buttonMode = true;
				} else {
					holder.removeEventListener(MouseEvent.MOUSE_DOWN, dragMe);	
					holder.buttonMode = false;
				}
			}
			myDraggable = theDrag;
		}
		public function get draggable():Boolean {
			return myDraggable;
		}
		private function dragMe(e:MouseEvent) {
			if (!dragCheck) {return;}
			current = MovieClip(e.target);
			trace(current.sortableNum);
			holder.setChildIndex(current,holder.numChildren-1);
			holder.stage.addEventListener(MouseEvent.MOUSE_UP, dropMe);
			holder.stage.addEventListener(MouseEvent.MOUSE_MOVE, sortMe);
			current.startDrag(false, new Rectangle(positions[0].x,current.y,positions[positions.length-1].x-positions[0].x+20,current.y+200));
		}
		public function replaceCurrent() {
			current.y = constantY;
			current.x = positions[current.sortableNum].x;
			TweenLite.to(current,.3,{alpha:1, onComplete:setDragable});					
		}
		private function setDragable() {
			dragCheck = true;
			holder.buttonMode = true;
		}
		private function dispatchGarbage() {
			dispatchEvent(new Event(Sortable.GARBAGE));
		}
		private function dropMe(e:MouseEvent) {
			current.stopDrag();
			//snap
			for (var i:uint=0; i<positions.length; i++) {
				if (Math.abs(current.x-positions[i].x) < ave*sensitivity) {
					//current.x = positions[i].x;
					if (garbage && current.border.hitTestObject(garbage)) {
						dragCheck = false;	
						holder.buttonMode = false;
						TweenLite.to(current,.3,{alpha:0, onComplete:dispatchGarbage});
					} else {
						TweenLite.to(current,.2,{x:positions[i].x, y:constantY, ease:Quad.easeInOut, onComplete:dispatchDrop});									
					}
					break;
				}
			}
			lastNum = -1;
			holder.stage.removeEventListener(MouseEvent.MOUSE_UP, dropMe);			
			holder.stage.removeEventListener(MouseEvent.MOUSE_MOVE, sortMe);			
		}
		private function dispatchDrop() {
			dispatchEvent(new Event(Sortable.DROP));
		}
		
		private function sortMe(e:MouseEvent) {
			
			var clip:MovieClip;
			var clipX:Number;
			var newX:Number=-1;
			
			for (var i:uint=0; i<positions.length; i++) {				
				if (i == current.sortableNum) {continue;}
				clip = positions[i].clip;
				clipX = positions[i].x;
				if (current.x > clipX - ave*sensitivity && current.x <= clipX) {
					newX = positions[i-1].x;						
					positions[i-1].clip = clip;
					positions[i].clip = current;
					clip.sortableNum = i-1;
					current.sortableNum = i;
					break;
				}		
				if (current.x < clipX + ave*sensitivity && current.x >= clipX) {
					//clip.x = positions[i+1].x;
					newX = positions[i+1].x;
					positions[i+1].clip = clip;
					positions[i].clip = current;
					clip.sortableNum = i+1;
					current.sortableNum = i;
					break;
				}								
			}
			if (newX>=0 && current.sortableNum != lastNum) {
				trace (current.sortableNum);
				trace ("new="+newX);
				//clip.x = newX;
				TweenLite.to(clip,.2,{x:newX, ease:Quad.easeInOut});
				lastNum = current.sortableNum;
			}
		}
		public function dispose() {
			holder.removeEventListener(MouseEvent.MOUSE_DOWN, dragMe);
			holder.buttonMode = false;
			holder.positions = null;
		}
	}
	
}
