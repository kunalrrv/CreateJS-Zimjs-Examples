package com.danzen.utilities {
	public class ScaleAssets {
				
		// ScaleAssets by Dan Zen - http://danzen.com - free to use - 2011
		
		// Class to dynamically load images and scale objects based on scale determined from ScaleTool class
		
		// DO NOT use with an applicationDPI parameter set in ViewNavigatorApplication tag
		// this is for manual scaling, the applicationDPI setting is for automatic scaling
		// DPI scaling does not take into account screen size, only DPI therefore, it seems useless
		
		
		// CONSTRUCTOR PARAMETERS
		// pass in object with the stage (usually just pass in the keyword 'this')
		// pass in an array of image names as strings that match the file name of your images (less size suffix) and your image tag ids
		// 		example: ["name1", "name2", "name3"] where the images are in an assets folder with _b.png, _s.png, etc. on the end
		// 		also the image tag must have an id that matches the name
		// pass in an array of objects (as strings matching the ids) such as textFields or spacers that should be resized 
		// pass in an optional holder to make visible once the images are loaded
	
		// ADDITIONAL STATIC METHODS
		// Static methods ScaleAssets.contain() and ScaleAssets.cover() are provided
		// these help scale a graphic to be contained in or to cover a target area
		// they are not part of the ScaleTool / ScaleAssets system - but just found them useful
		
		public function ScaleAssets(obj:Object, folder:String, extension:String, images:Array, toScale:Array, scale:Number, scaleLetter:String) {
			var imageName:String;
			for (var i:uint=0; i<images.length; i++) {
				imageName = images[i];
				var added:String = "";
				if (folder != "") {
					added = "/";
				}
				var added2:String = "";
				if (extension.charAt(0) != ".") {
					added2 = ".";
				}
				obj[imageName].source = folder+added+imageName+"_"+scaleLetter+added2+extension;
				
			}	
			var textName:String;
			for (i=0; i<toScale.length; i++) {
				textName = toScale[i];
				obj[textName].scaleX = obj[textName].scaleY = scale;
			}					
		}
		
		// couple separate functions to help scaling picture within an area
		public static function contain(realWidth:Number, realHeight:Number, targetWidth:Number, targetHeight:Number):Object {
			var realAspect:Number = realWidth / realHeight;
			var targetAspect:Number = targetWidth / targetHeight;
			var o:Object = {};
			if (realAspect > targetAspect) {
				o.width = targetWidth;
				o.height = o.width / realAspect;  
			} else {
				o.height = targetHeight;
				o.width = o.height * realAspect;
			}
			return o;
		}
		
		public static function cover(realWidth:Number, realHeight:Number, targetWidth:Number, targetHeight:Number):Object {
			var realAspect:Number = realWidth / realHeight;
			var targetAspect:Number = targetWidth / targetHeight;
			var o:Object = {};
			if (realAspect > targetAspect) {
				o.height = targetHeight;
				o.width = o.height * realAspect;				
			} else {
				o.width = targetWidth;
				o.height = o.width / realAspect;  
			}
			return o;
		}
		
	}
}