
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
	
	import flash.display.MovieClip;
	import flash.events.*;
	import fl.controls.Slider;
	import fl.controls.RadioButton;
	import flash.text.TextField;

	import com.danzen.interfaces.Pane;

	
	public class DodoConfig extends MovieClip {
		
		// CONSTRUCTOR  
		// DodoConfig(theBlobs:DodoBlobs):void
		// 		DodoConfig lets you set the sensitivity and background of DodoBlobs
		//		It is a little panel that you can turn off and on with SHIFT D
		
		// 		PARAMETERS:
		//		theCam:DodoCamera - the cam used for blob detection		

		// EVENTS 
		
		// METHODS (in addition to constructor)
		// dispose():void - stops and removes cursor

		// PROPERTIES 
		
		// CONSTANTS 
		
		// USAGE
		// myConfig = new DodoConfig(myBlobs);
		// addChild(myConfig);		
		
		private var myBlobs:DodoBlobs;
		private var myPane:Pane;
		private var myIcon:DodoIcon;
		private var mySlider:Slider;
		private var myRadioButtons:RadioButton;
		private var myText:TextField;
				
		public function DodoConfig(theBlobs:DodoBlobs) {
			myBlobs = theBlobs;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event) {
			
			trace ("hi from DodoConfig");
			
			myPane = new Pane(500,80,true,0xFFFFFF,.8,true);
			myPane.x = 70; 
			myPane.y = 370;
			addChild(myPane);
			myPane.addEventListener(Pane.EXIT, togglePane);			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, checkKey);
			
			myIcon = new DodoIcon();
			myIcon.x = 10;
			myIcon.y = 10;
			myPane.addChild(myIcon);			
			
			myText = new TextField();
			myText.text = "SENSITIVITY";
			myText.x = 144;
			myText.y = 6;
			myText.alpha = .5;
			myText.selectable = false;
			myPane.addChild(myText);
			
			mySlider = new Slider();
			mySlider.x = 144;
			mySlider.y = 34;
			mySlider.maximum = 10;
			mySlider.minimum = 0;
			mySlider.tickInterval = 1;
			mySlider.snapInterval = .5;
			mySlider.liveDragging = true;
			mySlider.width = 300;
			mySlider.value = myBlobs.sensitivity;
			mySlider.addEventListener(Event.CHANGE, doSlider);
			myPane.addChild(mySlider);
						
			var radio1:RadioButton = new RadioButton();
			radio1.label = "DARK BACKGROUND";
			radio1.move(144, 52);
			radio1.width = 200;
			radio1.addEventListener(MouseEvent.CLICK, doRadio);
			myPane.addChild(radio1);
			
			var radio2:RadioButton = new RadioButton();
			radio2.label = "LIGHT BACKGROUND";
			radio2.move(282, 52);
			radio2.width = 200;
			radio2.addEventListener(MouseEvent.CLICK, doRadio);
			myPane.addChild(radio2);
			
			radio1.alpha = .5;
			radio2.alpha = .5;
			
			if (myBlobs.background == "dark") {
				radio1.selected = true;
			} else {
				radio2.selected = true;
			}			
		}
		
		private function doRadio(e:MouseEvent) {
			if (e.currentTarget.label == "DARK BACKGROUND"){
				myBlobs.background = "dark";
			} else {
				myBlobs.background = "light";
			}
		}
		
		private function doSlider(e:Event) {
			myBlobs.sensitivity = e.currentTarget.value;
		}
		
		private function togglePane(e:Event) {
			if (contains(myPane)) {
				removeChild(myPane);			
			} else {
				addChild(myPane);	
			}
			stage.focus = null;								
		}
		
		private function checkKey(e:KeyboardEvent) {	
			if (e.shiftKey && e.keyCode==68) { // SHIFT D for Dodo
				togglePane(new Event(Pane.EXIT));
			}
		}
		
		public function dispose() {
			mySlider.removeEventListener(Event.CHANGE, doSlider);			
			myPane.removeEventListener(Pane.EXIT, togglePane);		
			if (contains(myPane)) {
				removeChild(myPane);
			}
			myPane.dispose();			
			myPane = null;
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, checkKey);
		}
	}	
}