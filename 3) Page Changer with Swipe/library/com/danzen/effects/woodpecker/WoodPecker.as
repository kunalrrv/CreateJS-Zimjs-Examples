
package com.danzen.effects.woodpecker {

	// WOODPECKER INTRODUCTION  
	// WoodPecker lets you animate MovieClips in your Library to sound frequency
	// http://woodpeckerflash.wordpress.com - by inventor Dan Zen - http://www.danzen.com
	// if you are using WoodPecker for commercial purposes, you are welcome to donate to Dan Zen
	// donations can be made to agency@danzen.com at http://www.paypal.com
	
	// INSTALLING CLASSES
	// suggested installation:
	// create a "classes" folder on your hard drive - for example c:\classes
	// add the classes folder to your Flash class path:
	// Flash menu choose Edit > Preferences > ActionScript - ActionScript 3 Settings 
	// then use the + sign for the source path box to add the path to your classes folder	
	// put the provided com/danzen/ directory with its folders and files in the classes folder
	// the readme has more information if you need it

	// USING WOODPECKER
	// please make sure that com/danzen/effects/woodpecker/ is in a folder in your class path
	// WoodPecker uses the com/danzen/utilities/DynamicObject.as file as well - so put that there too

	// 1. make a MovieClip in the library and under properties/linkage name set the Class name
	// 2. pass that class name as well as other parameters to the new WoodPecker() (set dragable=true)
	// 3. run your Flash and you will see objects created by WoodPecker
	// 4. drag them around to the right places and then call the recordBeat() method
	// 5. see the examples for how to do this with a KeyPress event
	// 6. copy the traced setBeatObject() method call to the line after your WoodPecker object
	// 7. run your Flash again and you will see that your settings are saved
	// 8. from then on, you can make modifications to the individual beats
	// 9. for instance, using a different Class, setting unique sizes or filters, etc.
	//    (if you are animating the alpha, make sure you have different beatSize and startSize)
	
	// there is a list of methods, events and properties below for reference	
	// see the example files that come with WoodPecker to see how to do the steps above		


	import flash.display.*	
	import flash.events.*
	import flash.utils.Timer;
	import flash.filters.*;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;
	import flash.geom.Matrix;
	import fl.motion.Color;
	
	import com.danzen.utilities.DynamicObject;
	
	public class WoodPecker extends Sprite {
		
		// CONSTRUCTOR
		// WoodPecker(theClip:Class, theType:Array, theNumBeats:Number=1, theSize:Number=100, theFrequency:Boolean=true, theDragable:Boolean=true):void
		//	constructor to start animating clips to sound
		//	PARAMETERS:
		//		theClip:Class
		//			a class such as a MovieClip in the library with its Class set under properties > linkage
		//		theType:Array
		//			an array of three Booleans for scale width, height, alpha based on beat amplitude i.e. [true, true, false]
		//		theNumBeats
		//			the number of instances that will be made from theClip Class
		//		theSize
		//			the size of theClip's largest animated width or height dimension
		//		theFrequency
		//			set to true if a frequency spectrum is tested - base, mid, treble
		//			set to false if a wave form is tested - provides more an even undulating effect
		//		theDragable:Boolean
		//			you can drag the clips around - this can be for interactivity or to record their positions
		//		theMic:Boolean
		//			do you want to process sound from the mic - you need to make a microphone object in your code

		// EVENTS
		// no events
		
		// METHODS
		// setBeat(what:String, which:Number, amount:Object):void
			// sets the specified property (what) for the specified beat (which) to the specified value
			// properties to choose from are:
			// "clip","x","y","alpha","color","blendMode","filters","beatSize","startSize"
		// setAllBeats(what:String, amount:Object):void
			// sets the specified property (what) of every beat to the specified value - see above for properties
		// getBeats():Array
			// gets an array of the beat clips
		// getBeatValues():Array
			// gets an array of beat values before scaled - right from the divided compute spectrum
		// getBeatAt(w:Number):Object
			// gets a specific beat in the array
		// setBeatObject(o:Object):void
			// receives an object with all the properties above holding an Array each containing the values for the beats
			// example: {clip:[Class1, Class2], x:[12, 34], y:[29, 44], alpha:[1, 1], etc. }
		// getBeatObject():Object
			// returns the object that holds all the properties above as arrays of values per beat
		// recordBeat():void
			// traces the code for the BeatObject so that you can hard code your initialized object
		// dispose():void
			// stops tracking beats and removes listeners, etc.
		
		// PROPERTIES 	
		// displayOn:Boolean
			// sets the alpha of each surregate clip to .5 so you can see them better during set up
			
		// PRIVATE VARIABLES			
		private var myClip:Class;
		private var myNumBeats:Number;
		private var mySize:Number;
		private var myType:Array;
		private var myFrequency:Boolean;
		private var myDragable:Boolean;
		private var myBeat:SoundBeat;
		private var myHolder:Sprite;
		private var myBeats:Sprite;
		private var myMenus:Sprite;		
		private var menuArray:Array = [];
		private var myTimer;Timer;		
		private var beatArray:Array = [];
		private var beatObject:Object;
		private var myValues:Array = [];
		private var bList:Array = ["clip","x","y","alpha","color","blendMode","filters","beatSize","startSize"];		
		private var currentDrag:Object;
		private var myDisplayOn:Boolean = false;
		private var myMic:Boolean = false;
		private var mySlow:Number;
		private var myGain:Number;
		private var myDamp:Number;
		private var myCount:Number=0;				

		public function WoodPecker (
					theClip:Class,
					theType:Array,
					theNumBeats:Number=1,
					theSize:Number=100,					
					theFrequency:Boolean=true,
					theDragable:Boolean=true,
					theMic:Boolean=false,
					theGain:Number=50,
					theSlow:Number=1,
					theDamp:Number=0) {			
			
			trace ("hi from WoodPecker");
			
			myClip = theClip;
			myNumBeats = theNumBeats;
			mySize = theSize;
			myType = theType;
			myFrequency = theFrequency;
			myDragable = theDragable;	
			myMic = theMic;	
			myGain = theGain;
			mySlow = theSlow;
			myDamp = theDamp;
	
			tabChildren = false;
			tabEnabled = false;
			
			myHolder = new Sprite();			
			myBeats = new Sprite();
			myMenus = new Sprite();
			myHolder.addChild(myBeats);
			myHolder.addChild(myMenus);
						
			var space = 10;
			for (var i:uint=0; i<myNumBeats; i++) {
				var clip = new myClip();
				var clip2 = new myClip();
				clip.x = space * i;
				clip2.x = space * i;
				clip2.alpha = 0;				
				beatArray.push(clip);
				menuArray.push(clip2);				
				myBeats.addChild(clip);	
				myMenus.addChild(clip2);
				if (myDragable) {					
					clip2.mouseChildren = false;
					clip2.addEventListener(MouseEvent.MOUSE_DOWN, drag);
					clip2.addEventListener(MouseEvent.MOUSE_UP, drop);
					clip2.buttonMode = true; 
					clip2.mate = clip;
				}			
				clip.num = i;
				clip2.num = i;		
			}
			
			setBeatProperties();
			
			myTimer = new Timer(50,0);
			myTimer.addEventListener(TimerEvent.TIMER, follow);
			
			addChild(myHolder);				
			
			myBeat = new SoundBeat(myNumBeats, myFrequency, mySize, mySize + 10, true, 5, myMic, myGain);			
			myBeat.addEventListener(SoundBeatEvent.PROCESS_SOUND, processBeat);				
			
			if (myDamp > 0) {
				addEventListener(Event.ENTER_FRAME, animate);
			}

		}		
		
		private function animate(e:Event):void {		
			var thisBeat:MovieClip;
			var diff:Number;			
			for (var i:uint=0; i<beatArray.length; i++) {				
				thisBeat = MovieClip(beatArray[i]);
				if (thisBeat.desiredW) {
					diff = thisBeat.desiredW-thisBeat.width;					
					thisBeat.width = thisBeat.width + diff*myDamp;
					diff = thisBeat.desiredH-thisBeat.height;					
					thisBeat.height = thisBeat.height + diff*myDamp;
				} 
				if (thisBeat.desiredR) {
					diff = thisBeat.desiredR-thisBeat.rotation;					
					thisBeat.rotation = thisBeat.rotation + diff*myDamp;
				} 
			}				
		}
		
		private function processBeat(e:SoundBeatEvent) {		
			myCount++;
			if (myCount % mySlow != 0) {return;}
			myCount = 0;
			myValues = e.processArray;
			var oldW:Number;
			var oldH:Number;
			for (var i:uint = 0; i < myValues.length; i++) {		
				var startFactor = beatObject["startSize"][i];
				var scaleFactor = beatObject["beatSize"][i] - startFactor;	
				if (myDamp > 0) {
					if (myType[0] && myType[1]) { // keep proportion
						if (menuArray[i].width > menuArray[i].height) {
							oldW = menuArray[i].width;
							beatArray[i].desiredW = startFactor + myValues[i] * scaleFactor / mySize;
							beatArray[i].desiredH = menuArray[i].height * beatArray[i].desiredW / oldW;						
						} else {
							oldH = menuArray[i].height;
							beatArray[i].desiredH = startFactor + myValues[i] * scaleFactor / mySize;
							beatArray[i].desiredW = menuArray[i].width * beatArray[i].desiredH / oldH;							
						}
					} else {
						if (myType[0]) {
							beatArray[i].desiredW = startFactor + myValues[i] * scaleFactor / mySize;
						}
						if (myType[1]) {
							beatArray[i].desiredW = beatArray[i].width;
							beatArray[i].desiredH = startFactor + myValues[i] * scaleFactor / mySize;
						}
						if (myType[3]) {
							beatArray[i].desiredR = startFactor + myValues[i] * scaleFactor / mySize;
						}
					}
				} else {
					if (myType[0] && myType[1]) { // keep proportion
						if (menuArray[i].width > menuArray[i].height) {
							oldW = menuArray[i].width;
							beatArray[i].width = startFactor + myValues[i] * scaleFactor / mySize;
							beatArray[i].height = menuArray[i].height * beatArray[i].width / oldW;						
						} else {
							oldH = menuArray[i].height;
							beatArray[i].height = startFactor + myValues[i] * scaleFactor / mySize;
							beatArray[i].width = menuArray[i].width * beatArray[i].height / oldH;							
						}
					} else {
						if (myType[0]) {
							beatArray[i].width = startFactor + myValues[i] * scaleFactor / mySize;
						}
						if (myType[1]) {
							beatArray[i].height = startFactor + myValues[i] * scaleFactor / mySize;
						}
						if (myType[3]) {
							beatArray[i].rotation = startFactor + myValues[i] * scaleFactor / mySize;
						}
					}
				}
				
				
				if (myType[2]) {
					beatArray[i].alpha = (startFactor + myValues[i] * scaleFactor) / beatObject["beatSize"][i] / mySize;
				}				
			}			
		}					

		private function setClip(w:Number, a:Object) {
			if (!a) {return;}
			var tempTransform;		
			var clip;
			var clip2;
			tempTransform = beatArray[w].transform.matrix;					
			clip = new a();
			clip2 = new a();					
			if (myDragable) {
				menuArray[w].removeEventListener(MouseEvent.MOUSE_DOWN, drag);
				menuArray[w].removeEventListener(MouseEvent.MOUSE_UP, drop);
			}						
			myBeats.removeChild(beatArray[w]);
			myMenus.removeChild(menuArray[w]);					
			beatArray[w] = clip;
			menuArray[w] = clip2;								
			clip.transform.matrix = tempTransform;
			clip2.transform.matrix = tempTransform;						
			clip2.alpha = 0;						
			myBeats.addChild(clip);	
			myMenus.addChild(clip2);						
			if (myDragable) {				
				clip2.mouseChildren = false;
				clip2.addEventListener(MouseEvent.MOUSE_DOWN, drag);
				clip2.addEventListener(MouseEvent.MOUSE_UP, drop);
				clip2.buttonMode = true; 
				clip2.mate = clip;							
			}									
			clip.num = w;
			clip2.num = w								
		}		
		
		private function setBeatProperties() {
			
			var b = {};
			for (var i:uint=0; i<bList.length; i++) {
				b[bList[i]] = [];
			}
			for (i=0; i< myNumBeats; i++) {
				b.clip.push(myClip);
				b.x.push(beatArray[i].x);
				b.y.push(beatArray[i].y);
				b.alpha.push(1);
				b.color.push(null);
				b.blendMode.push(null);
				b.filters.push([]);
				b.beatSize.push(mySize);
				b.startSize.push(0);
			}			
			beatObject = b;
		}		
	
		private function drag(e:MouseEvent) {
			var container = e.target.parent;
			container.setChildIndex(e.target, container.numChildren-1);
			e.target.startDrag();
			currentDrag = e.target;
			myTimer.start();			
		}
		
		private function follow(e:TimerEvent) {						
			currentDrag.mate.x = currentDrag.x;
			currentDrag.mate.y = currentDrag.y;			
			e.updateAfterEvent();
		}
		
		private function drop(e:MouseEvent) {
			e.currentTarget.stopDrag();
			beatObject["x"][currentDrag.num] = currentDrag.x;
			beatObject["y"][currentDrag.num] = currentDrag.y;
			myTimer.stop();
		}
		
		// ------------------------  Public Properties  -----------------------

		public function set displayOn(b:Boolean):void {
			myDisplayOn = b;
			var i:uint;
			if (b) {
				for (i=0; i<menuArray.length; i++) {
						menuArray[i].alpha = .5;
				}
			} else {
				for (i=0; i<menuArray.length; i++) {
					menuArray[i].alpha = 0;
				}				
			}			
		}

		public function get displayOn():Boolean {
			return myDisplayOn;
		}
		

		// ------------------------  Public Methods  -----------------------

		
		public function setBeat(what:String, which:Number, amount:Object):void {
		
			if (beatObject[what]) {
				if (which < myNumBeats) {
					beatObject[what][which] = amount;
					if (what == "x" || what == "y") {
						beatArray[which][what] = amount;
						menuArray[which][what] = amount;
					} else if (what == "color") {
						if (amount != null) {
							var ct = beatArray[which].transform.colorTransform;
							ct.color = uint(amount);							
							beatArray[which].transform.colorTransform = ct;			
						}
					} else if (what == "filters" || what == "blendMode" || what == "alpha") {
						beatArray[which][what] = amount;
					} else if (what == "clip") {
						setClip(which,amount);		
					}
				}
			}		
		}
		
		public function setAllBeats(what:String, amount:Object):void {
			
			if (beatObject[what]) {
				for (var i:uint=0; i< beatArray.length; i++) {
					beatObject[what][i] = amount;
					if (what == "x" || what == "y") {
						beatArray[i][what] = amount;
						menuArray[i][what] = amount;
					} else if (what == "color") {			
						if (amount != null) {					
							var ct = beatArray[i].transform.colorTransform;
							ct.color = uint(amount);
							beatArray[i].transform.colorTransform = ct;			
						}
					} else if (what == "filters" || what == "blendMode" || what == "alpha") {
						beatArray[i][what] = amount;
					} else if (what == "clip") {																
						setClip(i,amount);		
					}					
				}
			}		
		}		
				
		public function getBeats():Array {
			return beatArray;
		}
		
		public function getBeatValues() {
			return myValues;
		}
		
		public function getBeatAt(w:Number):Object {
			return beatArray[w];
		}

		public function setBeatObject(o:Object):void {
			beatObject = o;

			for (var i:uint=0; i<bList.length; i++) {		
				var what = bList[i];
				for (var j:uint=0; j<myNumBeats; j++) {																	
					var amount = beatObject[what][j];
					if (amount !== "") {
						if (what == "x" || what == "y") {
							beatArray[j][what] = amount;
							menuArray[j][what] = amount;
						} else if (what == "color") {			
							if (amount != null) {
								var ct = beatArray[j].transform.colorTransform;
								ct.color = uint(amount);
								beatArray[j].transform.colorTransform = ct;			
							}
						} else if (what == "filters" || what == "blendMode" || what == "alpha") {
							if (amount) {
								beatArray[j][what] = amount;									
							}
						} else if (what == "clip") {																	
							setClip(j,amount);			
						}										
					}
				}	
			}
		}
		
		public function getBeatObject():Object {
			return beatObject;
		}			

		public function recordBeat():void {
			var output = "myWoodPecker.setBeatObject({\n\t\t\t\t\t";
			var beatConverted = DynamicObject.copy(beatObject);
			var i:uint;
			var temp;
			for (i=0; i<myNumBeats; i++) {
				temp = beatObject["clip"][i].toString().split(" ");
				if (temp.length > 1) {
					temp = temp[1].substr(0,-1);
				} else {
					temp = "";
				}
				beatConverted["clip"][i] = temp;
				if ( beatObject["filters"][i]) {					
					temp = beatObject["filters"][i].toString().split(" ");
					if (temp.length > 1) {
						temp = "[new "+temp[1].substr(0,-1)+"()]";
					} else {
						temp = "";
					} 
				} else {
					temp = "";
				}
				beatConverted["filters"][i] = temp;	
			}
			for (i=0; i<bList.length; i++) {						
				var what = bList[i];
				if (what == "blendMode") {
					output += what + ":['" + beatConverted[what].join("','");				
					output += "'],\n\t\t\t\t\t";					
				} else {
					output += what + ":[" + beatConverted[what].join(",");				
					output += "],\n\t\t\t\t\t";					
				}
			}
			output = output.substr(0,output.length-7);
			output += "\n\t\t\t\t\t});"
			trace (output);
		}
		
		public function setGain(g:Number=50):void {
			myBeat.setGain(g);
		}
		
		public function setDamp(d:Number=.1):void {
			myDamp = d;
			if (hasEventListener(Event.ENTER_FRAME)) {
				removeEventListener(Event.ENTER_FRAME, animate);
			}
			if (myDamp > 0) {
				addEventListener(Event.ENTER_FRAME, animate);
			}
		}
	
		public function dispose():void {				
			trace ("bye from WoodPecker");
			myTimer.removeEventListener(TimerEvent.TIMER, follow);
			myBeat.removeEventListener(SoundBeatEvent.PROCESS_SOUND, processBeat);	
			myBeat.dispose()
		}		

	}	
}