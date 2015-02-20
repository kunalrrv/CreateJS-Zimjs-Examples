package com.danzen.interfaces.invisibleInterface {
	
	import com.danzen.interfaces.invisibleInterface.IIEvent;
	import com.danzen.interfaces.invisibleInterface.IIGrid;
	
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class IISet extends MovieClip {
		
		public var activeGrid:String;
		
		private var clip:MovieClip;
		private var currentGrid:IIGrid;
		private var grids:Object = {};
		private var spacing:Number;
		private var rounding:Number;
		
		public function IISet(theClip:MovieClip, theSpacing:Number=20, theRounding:Number=120):void {
			// constructor code			
			trace ("hi from IISet");			
			clip = theClip;			
			spacing = theSpacing;
			rounding = theRounding;			
		}
		
		public function hide():void {
			if (currentGrid) {
				currentGrid.alpha = 0;
			}
		}
		
		public function show():void {
			if (currentGrid) {
				currentGrid.alpha = 1;
			}
		}
		
		public function clear():void {
			var tempGrid:IIGrid;
			for (var i:String in grids) {
				tempGrid = IIGrid(grids[i]);
				tempGrid.dispose();
				tempGrid.removeEventListener(IIEvent.PRESS, doPress);
				tempGrid = null;
			}
			grids = {};			
		}
		
		public function addGrid(grid:String, cols:uint=3, rows:uint=2):void {
			var tempGrid:IIGrid = new IIGrid(clip, cols, rows, spacing, rounding);
			tempGrid.grid = grid;
			grids[grid] = tempGrid;
			tempGrid.addEventListener(IIEvent.PRESS, doPress);
			// need to hook up the events so addeventlistener here to receive event and then dispatch
		}
		
		public function setActiveGrid(grid:String):void {
			activeGrid = grid;	
			var currentAlpha:Number = 1;
			if (currentGrid) {
				currentAlpha = currentGrid.alpha;
				clip.removeChild(currentGrid)
			}
			currentGrid = grids[grid];
			currentGrid.alpha = currentAlpha;
			clip.addChild(currentGrid);			
		}
		
		private function doPress(e:IIEvent):void {	
			dispatchEvent(new IIEvent(IIEvent.PRESS, e.target.grid, e.num));
		}
	
		
	}	
}
