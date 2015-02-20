
package com.danzen.interfaces.dodo {
	
	// DODO INTRODUCTION  
	// Dodo lets you track light objects on a dark background or dark objects on a light background
	// It puts blobs where it finds objects
	
	// http://dodoflash.wordpress.com - by inventor Dan Zen - http://www.danzen.com
	// if you are using Dodo for commercial purposes, you are welcome to donate to Dan Zen
	// donations can be made to agency@danzen.com at http://www.paypal.com
	// also be aware that Gesture Tek and perhaps others hold patents in these areas
			
	// FEATURES
	// Dodo generates XML as ManyML and this can be fed to multitouch classes of Goose
	// ManyML - http://manyml.wordpress.com
	// Goose Multitouch for Flash - http://gooseflash.wordpress.com
	// this allows you to pick things up and resize them etc. with multiple fingers or wands
		
	// WORKINGS
	// Dodo uses a threshold system and you can set the sensitivity with DodoConfig
	// if the background is dark and the sensitivity is 5 then anything lighter than middle grey will show
	// if the sensitivity is 2 then it needs to be lighter than light grey (fewer objects)
	// if the sensitivity is 8 then it needs to be lighter than dark grey (more objects)
	
	// COMPARISON
	// the Flash Feathers series also provides Ostrich at http://ostrichflash.wordpress.com
	// Ostrich captures and tracks video motion and also has blobs
	// Ostrich works well under general ambient light as it is locating motion only
	// Dodo does not locate motion but rather opposite shades and thus does not work well under ambient light
	// it is best to have high contrast or at least a solid background 
	// with only the blobs you want to detect being visible
	// as such, if there is too much detected then the recursive calculations bog the application
	
	// PHYSICAL SYSTEMS
	// there are all sorts of multitouch table designs - you can search on YouTube
	// generally, you want a single background with the opposite shade as items of touch
	// so the surface might be a light vellum and then your fingers are dark
	// or make a dark box with a black plastic duotang cover and shine pen lights at it
		
	// INSTALLING CLASSES  
	// suggested installation:
	// create a "classes" folder on your hard drive - for example c:\classes
	// add the classes folder to your Flash class path:
	// Flash menu choose Edit > Preferences > ActionScript - ActionScript 3 Settings 
	// then use the + sign for the source path box to add the path to your classes folder
	// put the provided com/danzen/ directory with its folders and files in the classes folder
	// the readme has more information if you need it

	// USING DODO  
	// please make sure that the following director is in a folder in your class path:
	// com/danzen/interfaces/dodo/
	// see the samples for how to use the Dodo classes
	
	// DodoCamera - sets up the Web cam - macs may need to adjust their active camera setting in Flash
	// DodoBlob - detects for a blob in a single location
	// DodoBlobs - runs a series of DodoBlobs to detect for blobs across the whole camera
	// DodoConfig - sets up a config panel for sensitivity and light or dark background
	// DodoData - outputs location of blobs in ManyML XML format - can use with Goose Multitouch	
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.Timer;
	
	public class DodoData extends Sprite {
		
		// CONSTRUCTOR  
		// DodoData(theBlobs:DodoBlobs):void
		// 		DodoConfig lets you set the sensitivity and background of DodoBlobs
		//		It is a little panel that you can turn off and on with SHIFT D
		
		// 		PARAMETERS:
		//		theBlobs:DodoBlobs - the blobs to get the x, y data from		

		// EVENTS 
		// Event.CHANGE - triggers on ENTER_FRAME not really on change...
		
		// METHODS (in addition to constructor)
		// dispose():void - stops data from dispatching

		// PROPERTIES 
		// xmlData:XML - the data in the ManyML XML format http://manyml.wordpress.com
		
		// CONSTANTS 
		
		// USAGE
		// myDodoData = new DodoData(myBlobs);
		// myDodoData.addEventListener(Event.CHANGE, giveData);	
		// function giveData(e:Event) {
		// 	trace (myDodoData.xmlData);
		// }
		
		private var myBlobs:DodoBlobs;
		public var xmlData:XML;
		private var myTimer:Timer;
				
		public function DodoData(theBlobs:DodoBlobs) {
			myBlobs = theBlobs;
			myTimer = new Timer(300);
			myTimer.start();
			myTimer.addEventListener(TimerEvent.TIMER, doData);
		}
		
		private function doData(e:TimerEvent) {
						
			var theXML:String = "<manyml>\n";
			
			var len:Number = myBlobs.blobs.length;			
			for (var i:uint=0; i<len; i++) {
				if (myBlobs.blobs[i].x > -1000) {					
					theXML += '<item id="' + i + '" x="' + myBlobs.blobs[i].x + '" y="' + myBlobs.blobs[i].y + '" z="1" />\n';
				} else {
					// it appears that Goose has a bug 
					// it gets confused if the cursors do not hang around "unpressed"
					// will correct this one day...
					if (i < 10) {
						theXML += '<item id="' + i + '" x="' + myBlobs.blobs[i].x + '" y="' + myBlobs.blobs[i].y + '" z="-100" />\n';
					}					
				}
			}
			theXML += "</manyml>";
			xmlData = XML(theXML);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function dispose() {		
			removeEventListener(Event.ENTER_FRAME, doData);
			xmlData = null;
		}				
		
	}	
}