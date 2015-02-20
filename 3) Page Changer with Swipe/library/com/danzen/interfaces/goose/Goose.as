
package com.danzen.interfaces.goose {

	// GOOSE INTRODUCTION  
	// Goose lets you work with multiple cursor inputs - like multitouch
	// http://gooseflash.wordpress.com - by inventor Dan Zen - http://www.danzen.com
	// if you are using Goose for commercial purposes, you are welcome to donate to Dan Zen
	// donations can be made to agency@danzen.com at http://www.paypal.com
	
	// INSTALLING CLASSES  
	// suggested installation:
	// create a "classes" folder on your hard drive - for example c:\classes
	// add the classes folder to your Flash class path:
	// Flash menu choose Edit > Preferences > ActionScript - ActionScript 3 Settings 
	// then use the + sign for the source path box to add the path to your classes folder	
	// put the provided com/ directory with its folders and files in the classes folder
	// the readme has more information if you need it	
		
	// GOOSE OVERVIEW  
	// Goose splits into two parts:
	
	// 1. A multitouch emulator (GooseData, GooseRobin, Online Mouse Nodes)
	// 		with the Goose Emulator you run the online Mouse Nodes on two or more computers
	//		each mouse then feeds data through GooseRobin to GooseData
	//		you then feed the data from GooseData into Goose (part 2)	
	
	// 2. A multitouch processor (Goose, GooseEvent)
	//		Goose takes in multitouch data (like from the emulator in part 1)
	//		and shows multiple cursors in your application
	//		if you use the Goose Emulator then each mouse shows up as a cursor
	//		Goose and GooseEvent provide a set of methods and events for using the cursors
	//      You continue to use Goose when going from an emulator to real multitouch data

	// USING GOOSE  
	// see the sample as file for an example of how to use Goose
	// import com.danzen.interfaces.goose.* in your document class
	// create a new GooseData object and pass it the name of your application
	// create a Goose object in your document class
	// add an Event.CHANGE event to your GooseData object and have it call a method
	// in the method pass the GooseData's xmlData property to the Goose update() method
	
	// this separation allows you to easily change from the emulator to real multitouch data
	// when you are ready to do so, just pass the real data to the Goose update() method
	// the data must be in the form of ManyML:
	
	// <manyml>
	// <item id="1000" x="984" y="1" z="-100" />
	// <item id="2000" x="243" y="7" z="0" />
	// </manyml>
	
	// if z >= 0 then the item is treated as a touch in Goose
	// if z < 0 then the item is ignored by all events in Goose
	
	// Goose has a few methods and many properties described below
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.display.InteractiveObject;
	import flash.utils.getTimer;
	import flash.utils.Dictionary;
	import flash.geom.Matrix;
	import fl.motion.MatrixTransformer;

	public class Goose extends Sprite {

		// CONSTRUCTOR  
		// public function Goose(theShowCursors:Boolean = true):void 
		//		constructor to start your multitouch processor
		//		PARAMETERS:
		//			theShowCursors:Boolean
		//				do you want to see the cursors - defaults to true
		//				but remember, in multitouch you do not see cursors usually
		//				as they are not there for rollovers and under the fingers for presses
							
		// EVENTS
		// GooseEvent.TOUCH
		//		a touch up and down (see the touchDelay property) - cursor z property will be >= 0
		// GooseEvent.TOUCH_DOWN
		//		a touch down (like a MOUSE_DOWN) - cursor z property will be >= 0
		// GooseEvent.TOUCH_UP
		//		a touch up (like a MOUSE_UP) - cursor z property will be < 0
		// GooseEvent.TOUCH_MOVE
		//		moving while touching (like a MOUSE_MOVE)	
		//		will be automatically removed on TOUCH_UP
		// GooseEvent.PRESS
		//		a press up and down on a specified item (see the pressDelay property) - cursor z >= 0
		// GooseEvent.PRESS_DOWN
		//		a press down on a specified item - cursor z >= 0
		// GooseEvent.PRESS_UP
		//		a press up on a specified item - cursor z < 0
		// GooseEvent.PRESS_MOVE
		//		moving after pressing down on a specified item
		//		continues to register even if cursor is no longer on item
		//		will be automatically removed on PRESS_UP		
		// GooseEvent.PICK_UP
		//		the first time an item has been picked up for a follow or size
		// GooseEvent.PUT_DOWN
		//		the last time an item has been put down for last follow or size
		
		// METHODS
		//	update(d:XML):void
		//		receives the XML data in the form of ManyML (http://manyml.wordpress.com)
		//		makes the cursors move and dispatches the touch and press events
		//	addPressListener(e:String, obj:InteractiveObject, fun:Function):void
		//		e:String - a GooseEvent press-type event
		//		obj:InteractiveObject - a MovieClip for instance on which you want to track the event
		//		fun:Function - the function you want to call when the event on the obj happens
		//		this will pass to the function a GooseObject with the following properties:
		//			cursor:Sprite - a reference to the cursor object	
		//			cursorZ:Number - the z value of the cursor
		//			cursorID:String - the id value of the cursor			
		//			obj:InteractiveObject - a reference to the object that triggered the event
		// removePressListener(e:String, obj:InteractiveObject, fun:Function):void
		//		removes the specified event from the specified object having related function				
		// startFollow(cursor:Sprite, obj:InteractiveObject, damp:Number=.1, type:String=Goose.DRAG_AVERAGE):void
		// 		make the specified cursor partake in the moving of specified object
		//		when the cursor is no longer pressing, its effect on the follow is removed
		// 		damp is the speed at which the object follows - 1 instant, 0 not at all (.1 is nice)
		// 		type is the rules for your follow:
		// 		Goose.DRAG_LOCKED exclusive drag for life of cursor except if already locked
		// 		Goose.DRAG_OVERRIDE latest drag is the only drag (unless DRAG_LOCKED)
		// 		Goose.DRAG_AVERAGE (default) all drags are averaged (unless DRAG_OVERRIDE or DRAG_LOCKED)
		// stopFollow(cursor:Sprite, obj:InteractiveObject):void
		//		stop following the specified cursor with the specified object
		// stopAllFollows():void
		//		stop all current following - future follows will still run
		// startScale(cursor:Sprite, obj:InteractiveObject, damp:Number=.1, proportional:Boolean=true, registration:String=Goose.REGISTRATION_AVERAGE):void
		//		make the specified cursor partake in the scaling of the specified object
		//		when the cursor is no longer pressing, its effect on the scaling is removed	
		// 		damp is the speed at which the object scales - 1 instant, 0 not at all (.1 is nice)
		// 		the Boolean is proportional scaling (true - default) or not (false)
		// 		the last parameter is where it scales from
		// 		Goose.REGISTRATION_CENTER - from the object center
		// 		Goose.REGISTRATION_POINT - from the registration point
		// 		Goose.REGISTRATION_AVERAGE (default) - from the average starting point of the cursors				
		// stopScale(cursor:Sprite, obj:InteractiveObject):void
		//		stop scaling the specified object with the specified cursor
		// stopAllScales():void
		//		stop all current scaling - future scales will still run
		// dispose():void
		//		removes listeners, closes socket, deletes data objects
		
		// PROPERTIES 
		// showCursors:Boolean - do you want to see the cursors (true) or not (false)
		// touchDelay:Number = .5 - max seconds until a touch is not a touch 
		// pressDelay:Number = .5 - max seconds until a press is not a press
		// touchRadius:Number = 10 - max pixel movement until a touch is not a touch 
		// pressRadius:Number = 10 - max pixel movement until a press is not a press
		
		// STATIC CONSTANTS
		// Goose.DRAG_LOCKED - see startFollow() method
		// Goose.DRAG_OVERRIDE - see startFollow() method
		// Goose.DRAG_AVERAGE - see startFollow() method		
		// Goose.REGISTRATION_CENTER - see startScale() method
		// Goose.REGISTRATION_POINT - see startScale() method
		// Goose.REGISTRATION_AVERAGE - see startScale() method			

		public static const DRAG_LOCKED:String = "dragLocked";
		public static const DRAG_OVERRIDE:String = "dragOverride";
		public static const DRAG_AVERAGE:String = "dragAverage";
		
		public static const REGISTRATION_CENTER:String = "registrationCenter";
		public static const REGISTRATION_POINT:String = "registrationPoint";
		public static const REGISTRATION_AVERAGE:String = "registrationAverage";

		public var xmlData:XML;
		public var touchDelay:Number = .5;// max seconds until a touch is not a touch 
		public var pressDelay:Number = .5;// max seconds until a press is not a press
		public var touchRadius:Number = 10;// max pixel movement until a touch is not a touch 
		public var pressRadius:Number = 10;// max pixel movement until a press is not a press

		private var myShowCursors:Boolean;
		private var myCursors:Sprite;
		private var currentCursors:Object = {};
		
		// Dictionaries to record and track addPressEvent listeners		
		private var press:Dictionary = new Dictionary(true);
		private var pressDown:Dictionary = new Dictionary(true);
		private var pressUp:Dictionary = new Dictionary(true);
		private var pressMove:Dictionary = new Dictionary(true);
		private var pickUp:Dictionary = new Dictionary(true);
		private var putDown:Dictionary = new Dictionary(true);
		private var currentPresses:Dictionary = new Dictionary(true);
		private var cursorLookup:Dictionary = new Dictionary(true);
		private var follow:Dictionary = new Dictionary(true);
		private var scale:Dictionary = new Dictionary(true);
		
		public function Goose(theShowCursors:Boolean = true) {
	
			trace("hi from Goose");
			myCursors = new Sprite();
			addChild(myCursors);
			showCursors = theShowCursors;
			addEventListener(Event.ENTER_FRAME, runFollow);
			addEventListener(Event.ENTER_FRAME, runScale);
		}

		public function update(d:XML) {	
			/*var d:XML = <manyml>
				<item id="1000" x="50" y="20" z="-100" />
				<item id="2000" x="500" y="80" z="0" />
			</manyml>;*/
			
			// move cursors and determine cursor joins and leaves
			// dispatch cursor events
			var newCursor:Sprite;
			var newCursors:Object = {};
			var theseCursors:Object = {};
			var deltaX:Number;
			var deltaY:Number;
			var downCheck:Boolean = false;

			for each (var i:XML in d.item) {
				theseCursors[i.@id] = 1;
				if (! currentCursors[i.@id]) {
					newCursor = new Sprite();
					newCursor.graphics.lineStyle(2,0x888888,1,false,"none");
					newCursor.graphics.beginFill(0xffff00, .7);
					newCursor.graphics.drawCircle(0,0,10);
					newCursor.x = i.@x;
					newCursor.y = i.@y;
					myCursors.addChild(newCursor);
					newCursors[i.@id] = [newCursor,i.@z,getTimer(),i.@x,i.@y];
					cursorLookup[newCursor] = i.@id;
					if (i.@z >= 0) {
						newCursor.scaleX = newCursor.scaleY = 2;
						// -------------------TOUCH_DOWN PRESS_DOWN
						dispatchEvent(new GooseEvent(GooseEvent.TOUCH_DOWN, newCursor, Number(i.@z), i.@id));
						dispatchPressEvent(GooseEvent.PRESS_DOWN, newCursor, Number(i.@z), i.@id);
						downCheck = true;
					}
				} else {
					currentCursors[i.@id][0].x = i.@x;
					currentCursors[i.@id][0].y = i.@y;

					if (currentCursors[i.@id][1] < 0 && i.@z >= 0) {
						// -------------------TOUCH_DOWN PRESS_DOWN
						dispatchEvent(new GooseEvent(GooseEvent.TOUCH_DOWN, currentCursors[i.@id][0], Number(i.@z), i.@id));
						dispatchPressEvent(GooseEvent.PRESS_DOWN, currentCursors[i.@id][0], Number(i.@z), i.@id);
						currentCursors[i.@id][2] = getTimer();
						currentCursors[i.@id][3] = i.@x;
						currentCursors[i.@id][4] = i.@y;
						downCheck = true;
					} else if (currentCursors[i.@id][1] >= 0 && i.@z < 0) {
						// -------------------TOUCH TOUCH_UP PRESS PRESS_UP
						if ((getTimer() - currentCursors[i.@id][2]) < touchDelay * 1000) {
							deltaX = Math.pow((currentCursors[i.@id][3]-currentCursors[i.@id][0].x),2);
							deltaY = Math.pow((currentCursors[i.@id][4]-currentCursors[i.@id][0].y),2);
							if (Math.sqrt(deltaX + deltaY) < touchRadius) {
								dispatchEvent(new GooseEvent(GooseEvent.TOUCH, currentCursors[i.@id][0], Number(i.@z), i.@id));
								dispatchPressEvent(GooseEvent.PRESS, currentCursors[i.@id][0], Number(i.@z), i.@id);
							}
						}
						dispatchEvent(new GooseEvent(GooseEvent.TOUCH_UP, currentCursors[i.@id][0], Number(i.@z), i.@id));
						dispatchPressEvent(GooseEvent.PRESS_UP, currentCursors[i.@id][0], Number(i.@z), i.@id);
					}

					currentCursors[i.@id][1] = i.@z;

					// -------------------TOUCH_MOVE PRESS_MOVE
					if (currentCursors[i.@id][1] >= 0) {
						currentCursors[i.@id][0].scaleX = currentCursors[i.@id][0].scaleY = 2;
						dispatchEvent(new GooseEvent(GooseEvent.TOUCH_MOVE, currentCursors[i.@id][0], Number(i.@z), i.@id));
						dispatchPressEvent(GooseEvent.PRESS_MOVE, currentCursors[i.@id][0], Number(i.@z), i.@id);
						downCheck = true;
					} else {
						currentCursors[i.@id][0].scaleX = currentCursors[i.@id][0].scaleY = 1;
					}
				}

			}
			if (! downCheck) {
				// reset the current presses in case the cursor just left
				// this is important for real blob detection
				// when every press might get a unique id
				// the Dictionary should clear itself as cursors are deleted
				for (var p:* in currentPresses) {
					currentPresses[p] = {};
				}
			}			

			// remove any missing cursors and add any new ones
			for (var c:String in currentCursors) {
				if (! theseCursors[c]) {
					delete cursorLookup[currentCursors[c][0]];
					myCursors.removeChild(currentCursors[c][0]);
					delete currentCursors[c];
				}
			}
			for (var n:String in newCursors) {
				currentCursors[n] = newCursors[n].concat();
			}

		}

		private function dispatchPressEvent(e:String, c:Sprite, cZ:Number, cID:String) {
									
			var o:*;
			
			// watch out here as they may not have registered a PRESS_DOWN
			// yet we still need to know for the other events if we started on the object
			// this stores that we have a press on the object
			if (e == GooseEvent.PRESS_DOWN) {
				for (o in currentPresses) {
					if (o.hitTestPoint(c.x,c.y)) {
						currentPresses[o][cID] = 1;
					}
				}
			} 			
			
			// here we dispatch the event with one amazing line ;-)
			for (o in this[e]) {
				if (!o.mouseEnabled) {continue;}
				if (!currentPresses[o]) {continue;}
				if (currentPresses[o][cID]!=1) {continue;}
				
				if (o.hitTestPoint(c.x,c.y)) {										
					// call the function stored in the dictionary for the object
					this[e][o](new GooseEvent(e,c,cZ,cID,o)); // beautiful
				}
			}
			
			// remove the tracking of the press on the object
			if (e == GooseEvent.PRESS_UP) {
				for (o in currentPresses) {					
					delete currentPresses[o][cID];
					stopFollow(c, o);
					stopScale(c, o);
				}
			}		
		}

		public function addPressListener(e:String, obj:InteractiveObject, fun:Function) {
			this[e][obj] = fun;
			if (!currentPresses[obj]) {
				currentPresses[obj] = {};
			}
		}

		public function removePressListener(e:String, obj:InteractiveObject, fun:Function) {
			delete this[e][obj];
		}

		//----  FOLLOW  ---------------------------------------------------		
		
		public function startFollow(cursor:Sprite, obj:InteractiveObject, damp:Number=.1, type:String=Goose.DRAG_AVERAGE) {
			// might have nesting problems here unless do local to global...
			// write into follow array or object to loop through in the enter frame
			damp = Math.max(0, Math.min(1, damp));			
			if (follow[obj]) {
				if (follow[obj][0][2] == Goose.DRAG_LOCKED) {return;}
				if (type == Goose.DRAG_LOCKED || type == Goose.DRAG_OVERRIDE) {
					// overwrite the current followings whatever they are
					follow[obj] = [[cursor, damp, type, obj.x, obj.y, cursor.x, cursor.y]];
				} else {
					follow[obj].push([cursor, damp, type, obj.x, obj.y, cursor.x, cursor.y]);
				}
			} else {
				follow[obj] = [[cursor, damp, type, obj.x, obj.y, cursor.x, cursor.y]];
				if (scale[obj]) {return;}
				if (!this[GooseEvent.PICK_UP]) {return;}
				if (!this[GooseEvent.PICK_UP][obj]) {return;}
				var cID:String = cursorLookup[cursor];
				var cZ:Number = currentCursors[cID][1];
				this[GooseEvent.PICK_UP][obj](new GooseEvent(GooseEvent.PICK_UP,cursor,cZ,cID,obj));
			}			
		}
		
		private function runFollow(e:Event) { // called by ENTER_FRAME
			var curs:Sprite;
			var damp:Number;
			var objStartX:Number;
			var objStartY:Number;
			var cursStartX:Number;
			var cursStartY:Number;
			var cursEndX:Number;
			var cursEndY:Number;
			
			var totDamp:Number;
			var totObjStartX:Number;
			var totObjStartY:Number;
			var totCursStartX:Number;
			var totCursStartY:Number;
			var totCursX:Number;
			var totCursY:Number;
						
			var newX:Number;
			var newY:Number;
			var diffX:Number;
			var diffY:Number;
			
			var i:uint;
			var len:Number;
			
			for (var f:* in follow) {				
				totDamp=0;
				totObjStartX=0;
				totObjStartY=0;
				totCursStartX=0;
				totCursStartY=0;
				totCursX=0;
				totCursY=0;
				// take averages
				len = follow[f].length;
				for (i=0; i<len; i++) {
					curs = follow[f][i][0];
					totCursX+=curs.x;
					totCursY+=curs.y;
					totDamp+=follow[f][i][1];
					totObjStartX+=follow[f][i][3];
					totObjStartY+=follow[f][i][4];
					totCursStartX+=follow[f][i][5];
					totCursStartY+=follow[f][i][6];					
				}
								
				damp = totDamp/len;				
				objStartX = totObjStartX/len;
				objStartY = totObjStartY/len;
				cursStartX = totCursStartX/len;
				cursStartY = totCursStartY/len;
				cursEndX = totCursX/len;
				cursEndY = totCursY/len;
				
				newX = objStartX + (cursEndX - cursStartX);
				newY = objStartY + (cursEndY - cursStartY);
				diffX = newX - f.x;
				diffY = newY - f.y;
				if (Math.abs(diffX) >= 2) {			
					f.x = f.x + diffX * damp; 
				}
				if (Math.abs(diffY) >= 2) {
					f.y = f.y + diffY * damp;
				}				
			}
		}		

		public function stopFollow(cursor:Sprite, obj:InteractiveObject) {
			// update the follow array or object
			if (follow[obj]) {
				var len:Number = follow[obj].length;				
				for (var i:uint=0; i<len; i++) {
					if (follow[obj][i][0] == cursor) {
						follow[obj].splice(i,1);
						if (follow[obj].length == 0) {
							delete follow[obj];
							if (scale[obj]) {return;}
							if (!this[GooseEvent.PUT_DOWN]) {return;}
							if (!this[GooseEvent.PUT_DOWN][obj]) {return;}
							var cID:String = cursorLookup[cursor];
							var cZ:Number = currentCursors[cID][1];
							this[GooseEvent.PUT_DOWN][obj](new GooseEvent(GooseEvent.PUT_DOWN,cursor,cZ,cID,obj));							
						}
						break;
					}
				}
			}
		}

		public function stopAllFollows() {
			// clear the follow array or object					
			if (!this[GooseEvent.PUT_DOWN]) {
				follow = new Dictionary();
				return;
			}
			var o:*;
			var c:Sprite;
			var cID:String;
			var cZ:Number;
			for (o in follow) {
				if (scale[o]) {return;}
				if (!this[GooseEvent.PUT_DOWN][o]) {continue;}
				c = follow[o][0][0]; // just get the first cursor as the cursor that puts down
				cID = cursorLookup[c];
				cZ = currentCursors[cID][1];
				this[GooseEvent.PUT_DOWN][o](new GooseEvent(GooseEvent.PUT_DOWN,c,cZ,cID,o));							
			}
			follow = new Dictionary();
		}
		

		//----  SCALE  ---------------------------------------------------		
		
		
		public function startScale(cursor:Sprite, obj:InteractiveObject, damp:Number=.1, proportional:Boolean=true, registration:String=Goose.REGISTRATION_AVERAGE) {
			
			damp = Math.max(0, Math.min(1, damp));			
			if (scale[obj]) {				
				scale[obj].push([cursor, damp, proportional, registration, obj.x, obj.y, cursor.x, cursor.y, obj.width, obj.height]);				
			} else {
				scale[obj] = [[cursor, damp, proportional, registration, obj.x, obj.y, cursor.x, cursor.y, obj.width, obj.height]];
				if (follow[obj]) {return;}
				if (!this[GooseEvent.PICK_UP]) {return;}
				if (!this[GooseEvent.PICK_UP][obj]) {return;}
				var cID:String = cursorLookup[cursor];
				var cZ:Number = currentCursors[cID][1];
				this[GooseEvent.PICK_UP][obj](new GooseEvent(GooseEvent.PICK_UP,cursor,cZ,cID,obj));
			}			
		}

		private function runScale(e:Event) { // called by ENTER_FRAME
			var curs:Sprite;
			var damp:Number;
			var prop:Boolean;
			var reg:String;
			var objStartX:Number;
			var objStartY:Number;
			var objStartW:Number;
			var objStartH:Number;
			var cursStartX:Number;
			var cursStartY:Number;	
			
			var totDamp:Number;
			var totObjStartX:Number;
			var totObjStartY:Number;
			var totObjStartW:Number;
			var totObjStartH:Number;
			var totCursStartX:Number;
			var totCursStartY:Number;
			var totCursX:Number;
			var totCursY:Number;
						
			var newW:Number;
			var newH:Number;
			var diffW:Number;
			var diffH:Number;
			
			var i:uint;
			var len:Number;
			
			for (var obj:* in scale) {				
				totDamp=0;
				totObjStartX=0;
				totObjStartY=0;
				totObjStartW=0;
				totObjStartH=0;
				totCursStartX=0;
				totCursStartY=0;
				totCursX=0;
				totCursY=0;
				// take averages
				len = scale[obj].length;
				if (len <2) {continue;}
				for (i=0; i<len; i++) {
					totDamp+=scale[obj][i][1];
					totObjStartX+=scale[obj][i][4];
					totObjStartY+=scale[obj][i][5];
					totCursStartX+=scale[obj][i][6];
					totCursStartY+=scale[obj][i][7];
					totObjStartW+=scale[obj][i][8];
					totObjStartH+=scale[obj][i][9];
					// take the last prop and reg
					prop = scale[obj][i][2];	
					reg = scale[obj][i][3];	
				}
												
				damp = totDamp/len;							
				objStartX = totObjStartX/len;
				objStartY = totObjStartY/len;
				cursStartX = totCursStartX/len;
				cursStartY = totCursStartY/len;
				objStartW = totObjStartW/len;
				objStartH = totObjStartH/len;
				
				var maxDiffX:Number = -100000;
				var minDiffX:Number = 100000;
				var maxDiffY:Number = -100000;
				var minDiffY:Number = 100000;
				
				var currentMaxX:Number;
				var currentMaxY:Number;
				var currentMinX:Number;
				var currentMinY:Number;
				
				for (i=0; i<len; i++) {
					curs = scale[obj][i][0];
					if (curs.x-scale[obj][i][6] > maxDiffX) {
						maxDiffX = curs.x-scale[obj][i][6];
						currentMaxX = scale[obj][i][6];
					}
					if (curs.y-scale[obj][i][7] > maxDiffY) {
						maxDiffY = curs.y-scale[obj][i][7];
						currentMaxY = scale[obj][i][7];
					}
					if (curs.x-scale[obj][i][6] < minDiffX) {
						minDiffX = curs.x-scale[obj][i][6];
						currentMinX = scale[obj][i][6];
					}
					if (curs.y-scale[obj][i][7] < minDiffY) {
						minDiffY = curs.y-scale[obj][i][7];
						currentMinY = scale[obj][i][7];
					}										
				}
				
				var diffWidth:Number;
				var diffHeight:Number;
				
				if (currentMaxX >= currentMinX) {
					diffWidth = maxDiffX - minDiffX;
				} else {
					diffWidth = minDiffX - maxDiffX;
				}
				
				if (currentMaxY >= currentMinY) {
					diffHeight = maxDiffY - minDiffY;
				} else {
					diffHeight = minDiffY - maxDiffY;
				}
				
				if (prop) { // find largest proportional difference
					if (Math.abs(diffWidth / obj.width) > Math.abs(diffHeight / obj.height)) {
						diffHeight = diffWidth / obj.width * obj.height;
					} else {
						diffWidth = diffHeight / obj.height * obj.width;
					}					
				}
				
				newW = objStartW + diffWidth;
				newH = objStartH + diffHeight;
				diffW = newW - obj.width;
				diffH = newH - obj.height;					
				
				if (obj.width + diffW * damp < 10 || obj.height + diffH * damp < 10) {
					continue;
				}
				if (obj.width + diffW * damp > 2880 || obj.height + diffH * damp > 2880) {
					continue;
				}				
				
				if (Math.abs(diffW) >= 2) {			
					obj.width = obj.width + diffW * damp; 
				}
				if (Math.abs(diffH) >= 2) {
					obj.height = obj.height + diffH * damp;
				}
				if (reg == Goose.REGISTRATION_CENTER) {
					obj.x -= diffW/2 * damp;
					obj.y -= diffH/2 * damp;
				} else if (reg == Goose.REGISTRATION_AVERAGE) {
					obj.x -= diffW * (cursStartX-objStartX) / objStartW  * damp;
					obj.y -= diffH * (cursStartY-objStartY) / objStartH  * damp;
				}
			}
		}	

		public function stopScale(cursor:Sprite, obj:InteractiveObject) {
			// update the scale array or object
			if (scale[obj]) {
				var len:Number = scale[obj].length;				
				for (var i:uint=0; i<len; i++) {
					if (scale[obj][i][0] == cursor) {
						scale[obj].splice(i,1);
						if (scale[obj].length == 0) {
							delete scale[obj];
							if (follow[obj]) {return;}
							if (!this[GooseEvent.PUT_DOWN]) {return;}
							if (!this[GooseEvent.PUT_DOWN][obj]) {return;}
							var cID:String = cursorLookup[cursor];
							var cZ:Number = currentCursors[cID][1];
							this[GooseEvent.PUT_DOWN][obj](new GooseEvent(GooseEvent.PUT_DOWN,cursor,cZ,cID,obj));							
						}
						break;
					}
				}
			}
		}

		public function stopAllScales() {
			// clear the scale array or object					
			if (!this[GooseEvent.PUT_DOWN]) {
				scale = new Dictionary();
				return;
			}
			var o:*;
			var c:Sprite;
			var cID:String;
			var cZ:Number;
			for (o in scale) {				
				if (follow[o]) {return;}
				if (!this[GooseEvent.PUT_DOWN][o]) {continue;}
				c = scale[o][0][0]; // just get the first cursor as the cursor that puts down
				cID = cursorLookup[c];
				cZ = currentCursors[cID][1];
				this[GooseEvent.PUT_DOWN][o](new GooseEvent(GooseEvent.PUT_DOWN,c,cZ,cID,o));							
			}
			scale = new Dictionary();
		}	
		
		
		//-------------------------------------------------------		

			

		public function get showCursors():Boolean {
			return myShowCursors;
		}

		public function set showCursors(b:Boolean) {
			myShowCursors = b;
			if (myShowCursors) {
				myCursors.alpha = 1;
			} else {
				myCursors.alpha = 0;
			}
		}
		
		public function dispose() {
			removeEventListener(Event.ENTER_FRAME, runFollow);
			removeEventListener(Event.ENTER_FRAME, runScale);			
			press=null;
			pressDown=null;
			pressUp=null;
			pressMove=null;
			pickUp=null;
			putDown=null;
			currentPresses=null;
			cursorLookup=null;
			follow=null;
			scale=null;		
			removeChild(myCursors);
			myCursors=null;
			currentCursors=null;
		}


	}
}