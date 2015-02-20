package com.danzen.effects
{	
	import com.danzen.frameworks.Easy;
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.Timer;
	
	public class TartanShow extends Sprite
	{
		private var timer:Timer;
		private var keepPercent:Number = 70; // how often we overlay tartans in percent		
		private var colors:Array;
		private var speed:Number;
		private var numTartans:Number = 100;
		private var tartanIndex:Number = 0; 		
		
		// tartans hold all the tartan patterns that make up one tartan
		public var tartans:Sprite;
		// tartans always have same color order but varying widths and overlay of widths
		public var tartanList:Array = []; // holds tartan widths including overlays
		// [ [[widths]], [[widths],[widths]], [[widths],[widths],[widths]], [[widths]] ]		
		public var currentTartan:Array = [];
		// [ [colors],[[widths],[widths]] ]
		public var running:Boolean = true;
		
		public const MIN_MIN_WIDTH:Number = 3; // smallest the small width gets
		public const MAX_MIN_WIDTH:Number = 13; // largest the small width gets
		public const MIN_MAX_WIDTH:Number = 50; // smallest the large width gets
		public const MAX_MAX_WIDTH:Number = 200; // largest the large width gets
		
		private var sW:Number;
		private var sH:Number;
		
		public function TartanShow(theColors:Array, theWidth:Number, theHeight:Number, theSpeed:uint=2)
		{
			
			colors = theColors;			
			sW = theWidth;
			sH = theHeight;
			speed = theSpeed;
			
			makeTartanData();			
			
			timer = new Timer(speed*1000);			
			timer.addEventListener(TimerEvent.TIMER, timerGo);		
			timer.start();			
			
			// holder for tartans
			tartans = new Sprite();
			addChild(tartans);
			
			goTartan(0); 
			
		}
		
		private function makeTartanData():void {
			// loop through numTartans make random data for tartan
			// tartans can blend over top of one another and then clear
			var numColors:Number = colors.length;
			var curTart:Array = [];
			var curWidths:Array;
			var count:uint = 0;				
			tartanList = [];
			
			for (var i:uint = 0; i < numTartans; i++) {								
				curWidths = [];
				for (var j:uint = 0; j < numColors; j++) {
					if (Easy.random(2) > 1) {
						curWidths.push(Easy.randomRound(MIN_MIN_WIDTH,MAX_MIN_WIDTH));
					} else {
						curWidths.push(Easy.randomRound(MIN_MAX_WIDTH,MAX_MAX_WIDTH));
					}
				}				
				curTart.push(curWidths.slice());
				count++;	
				tartanList.push(curTart.slice());
				if (Easy.random(100) > keepPercent || count >= 4) {					
					curTart = [];
					count = 0;
				}				
			}			
		}		
		public function next():void {
			tartanIndex++;
			if (tartanIndex > numTartans - 1) {
				tartanIndex--; // end rather than loop
				return;
				//tartanIndex = 0;
			}
			goTartan(tartanIndex);			
		}
		public function prev():void {
			tartanIndex--;
			if (tartanIndex < 0) {
				tartanIndex++; // end rather than loop
				return;
				//tartanIndex = numTartans - 1;
			}
			goTartan(tartanIndex);
		}
		private function goTartan(n:Number):void {		
			if (tartans) {
				removeChild(tartans);
				tartans = null; // no listeners in Tartan class
				tartans = new Sprite();
				addChild(tartans);
			}
			var widths:Array = tartanList[n];
			currentTartan = [colors, widths];
			for (var i:uint=0; i<widths.length; i++) {
				tartans.addChild(new Tartan(colors, widths[i], sW, sH));
			}
		}
		private function timerGo(e:TimerEvent):void {
			next();
		}		
		
		public function pause():void {
			running = false;
			timer.stop();
		}
		public function resume():void {
			running = true;
			timer.reset();
			timer.start();
		}
		public function dispose():void {
			timer.addEventListener(TimerEvent.TIMER, timerGo);		
		}
		
		
	}
}