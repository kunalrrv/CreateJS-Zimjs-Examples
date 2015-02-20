package com.danzen.utilities {
	public class ScaleTool	{
		
		// ScaleTool by Dan Zen - http://danzen.com - free to use - 2011
		
		// Simple Class to help handle different screen sizes in mobile devices
		
		// DO NOT use with an applicationDPI parameter set in ViewNavigatorApplication tag
		// this is for manual scaling, the applicationDPI setting is for automatic scaling
		// DPI scaling does not take into account screen size, only DPI therefore, it seems useless
		
		// ScaleTool provides a scale based on width / baseWidth and a closest "scale Letter" 
		// this allows you you load different graphics for different scales
		// for instance myImage_b.png if the scale is closest to 1 and myImage_s.png if the scale is closest to .5
		// use in conjunction with ScaleAssets class
		
		// CONSTRUCTOR PARAMETERS
		// pass in the object with a stage (usually just pass in the keyword 'this') (might need to use an ADDED_TO_STAGE event)
		// pass in the baseWidth - for instance 768 for an iPad 2
		// pass in a set of scales that you would like to provide graphics for such as [1, .66, .5]
		// pass in a set of letters that match those scales such as ["b", "m", "s"]
		
		// PUBLIC PROPERTIES
		// provides a scale property (read only) and a matching scaleLetter property (read only)
		// the ScaleAssets class will use the scale property to scale text 
		// the ScaleAssets class will use the scaleLetter property to load suitable images	
		
		
		private var s:Number;
		private var sL:String;
		
		public function ScaleTool(obj:Object, baseWidth:Number, scales:Array, scaleLetter:Array)	{
			
			// watch out, sometimes width is wider than height
			s = Math.min(obj.stage.stageWidth, obj.stage.stageHeight) / baseWidth;
			var closestValue:Number = 100000;
			var closestIndex:Number;
			for (var i:uint=0; i< scales.length; i++) {
				if (Math.abs(scales[i]-scale) < closestValue) {
					closestValue = Math.abs(scales[i]-s);
					closestIndex = i;
				}
			}				
			sL = scaleLetter[closestIndex];
		}
		public function get scale():Number {
			return s;
		}
		public function get scaleLetter():String {
			return sL;
		}
	
	
	}
}