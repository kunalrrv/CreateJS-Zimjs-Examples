package com.danzen.frameworks {	

	// Easy - AS3 Helper Class - Dan Zen http://danzen.com free to use (2011)
	// see the sample file available at http://easyActionScript.wordpress.com
	
	// SUMMARY
	// Easy is a helper class that you use directly (like Math)	
	// it wraps a few of the more cumbersome Flash classes
		
	// INSTALLATION
	// put Easy.as in same directory as your document class OR
	// put com/danzen/frameworks/Easy.as in your class path and
	// import com.danzen.frameworks.Easy 
	
	// BACKGROUND
	// the Easy methods focus on your average settings
	// you can look at the method code to see how these were accomplished
	// you can adjust the methods if you want more options
	// if you want to learn how to do this stuff please consider 
	// http://imm.sheridanc.on.ca where Dan Zen teaches
	// if you have more suggestions, please contact door@danzen.com
	
	// EASY OBJECT
	// Easy methods often return and Easy object
	// the Easy object is usually just a MovieClip with some added properties
	// the MovieClip is used because it is dynamic and can dispatch events
	// dynamic means we can add properties to it after it is created
	// a plain Object is dynamic but cannot dispatch
	// and a Sprite can dispatch but is not dynamic
	// so for the most part, you can treat Easy objects as a MovieClip
	// see additional inline notes for any exceptions
	
	/* EASY METHODS
	Easy.random();			// returns Number
	Easy.randomRound();		// returns Number
	Easy.randomElement();	// returns Object	
	Easy.circle();			// returns Easy
	Easy.rectangle();		// returns Easy
	Easy.color();			// returns void
	Easy.scale();			// returns void	
	Easy.text();			// returns Easy
	Easy.font();			// returns void
	Easy.url();				// returns void
	Easy.drag();			// returns void
	Easy.picture();			// returns Easy
	Easy.sound();			// returns Easy
	Easy.volume();			// returns void
	Easy.fadeIn();			// returns void
	Easy.fadeOut();			// returns void
	Easy.xml();				// returns Easy	
	Easy.server();			// returns Easy	
	*/	

	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	public dynamic class Easy extends MovieClip {
		
		// EVENTS
		public var $$:InteractiveObject;
		private var ff:Object;
		private var ee:String;
		public static function $(c:InteractiveObject=null):Easy {			
			var e:Easy = new Easy();
			if (!c) {c=e;}
			e.$$ = c;
			return e;
		}
		public function on(e:String, f:Function):void {
			ee = e;
			ff = f;
			$$.addEventListener(ee, onEvent);
		}
		public function off():void {
			$$.removeEventListener(ee, onEvent);
		}
		private function onEvent(e:Object):void {
			// add what you need to possible event properties
			var eventProperties:Vector.<String> = new <String>[
				"target",
				"currentTarget",
				"keyCode"
			]; 
			var self:Easy = this;
			eventProperties.forEach(function(s:String, i:int, v:Vector.<String>):void {									
				self[s] = (e.hasOwnProperty(s)) ? e[s] : null;				
			});
			ff(this);
		}		
		
		// RANDOM		
		public static function random(a:Number, b:Number=0):Number {			 		
			if (b == 0) {
				return Math.random()*a;
			} else {
				return Math.min(a,b) + Math.random()*(Math.max(a,b)-Math.min(a,b));
			}			
		}
		
		public static function randomRound(a:Number, b:Number=0):Number {
			if (a>b) {a++;} else if (b>a) {b++;}
			return Math.floor(random(a,b));			
		}
		
		public static function randomElement(a:Array):Object {			
			return a[randomRound(a.length-1)];			
		}							

		// SHAPES		
		public static function circle(radius:Number, color:Number=0xDDDDDD, stroke:Number=0, strokeColor:Number=0x333333):Easy {			 		
			var myE:Easy = new Easy();
			myE.graphics.beginFill(color);
			if (stroke > 0) {
				myE.graphics.lineStyle(stroke, strokeColor);
			}
			myE.graphics.drawCircle(0,0,radius);
			return myE;
		}
		
		public static function rectangle(w:Number, h:Number, color:Number=0xDDDDDD, stroke:Number=0, strokeColor:Number=0x333333):Easy {			 		
			var myE:Easy = new Easy();
			myE.graphics.beginFill(color);
			if (stroke > 0) {
				myE.graphics.lineStyle(stroke, strokeColor, 1, false, "normal", "square", "miter");
			}
			myE.graphics.drawRect(0,0,w,h);
			return myE;
		}		
	
		// COLOR		
		public static function color(o:DisplayObject, c:Number):void {
			var myColorTransform:ColorTransform = new ColorTransform();
			myColorTransform.color = c;
			o.transform.colorTransform = myColorTransform;			
		}		
		
		// SCALE
		public static function scale(o:DisplayObject, s:Number):void {
			o.scaleX = o.scaleY = s;
		}
		
		// TEXT AND FONTS		
		public static function text(t:String):Easy {
			var myE:Easy = new Easy();
			var myText:TextField = new TextField();
			myText.autoSize = "left";
			myText.text = t;
			myText.selectable = false;
			myE.addChild(myText);
			myE.textField = myText;
			return myE;
		}
		
		public static function font(t:Object, f:Font, size:Number=12, color:Number=0xaaaaaa):void {
			var tt:TextField;
			if (t is Easy) {
				tt = TextField(t.textField);
			} else if (t is TextField) {
				tt = TextField(t);
			} else {
				trace ("need a TextField or an Easy Text Object");
				return;
			}
			var myFormat:TextFormat = new TextFormat(f.fontName, size, color);
			tt.embedFonts = true;
			tt.setTextFormat(myFormat);
		}				
		
		//URLS
		private static var urlReg:Dictionary = new Dictionary(true);
		public static function url(o:Sprite, url:String, target:String="_self"):void {			
			o.buttonMode = true;
			o.mouseChildren = false;			
			o.addEventListener(MouseEvent.CLICK, goURL);
			urlReg[o] = url;
			function goURL(e:MouseEvent):void {
				navigateToURL(new URLRequest(urlReg[e.currentTarget]), target);
			}
		}				
		
		// DRAG AND DROP		
		private static var currentDrag:Sprite;
		public static function drag(o:Sprite,l:Number=0,t:Number=0,w:Number=0,h:Number=0,corner:Boolean=true,topLevel:Boolean=true):void {
			o.buttonMode = true;
			o.mouseChildren = false;
			o.addEventListener(MouseEvent.MOUSE_DOWN, dragMe);			
			function dragMe(e:MouseEvent):void {
				currentDrag = Sprite(e.currentTarget);	
				if (topLevel) {
					currentDrag.parent.setChildIndex(currentDrag,currentDrag.parent.numChildren-1)
				}
				var boundRect:Rectangle;
				if (w!=0 || h!=0) {
					if (corner) {
						boundRect = new Rectangle(l,t,w-o.width,h-o.height);
					} else {
						boundRect = new Rectangle(l-o.width/2,t-o.height/2,w-o.width/2,h-o.height/2);
					}
				}
				currentDrag.startDrag(false, boundRect);
				o.stage.addEventListener(MouseEvent.MOUSE_UP, dropMe);				
			}
			function dropMe(e:MouseEvent):void {
				currentDrag.stopDrag();
				if (o.stage) {
					o.stage.removeEventListener(MouseEvent.MOUSE_UP, dropMe);
				}
			}
		}
		
		// PICTURE
		public static function picture(u:String):Easy {
			var myE:Easy = new Easy();
			var myL:Loader = new Loader();
			myL.load(new URLRequest(u));
			myE.addChild(myL);
			myL.contentLoaderInfo.addEventListener(Event.COMPLETE, picDone);
			function picDone(e:Event):void {
				myL.contentLoaderInfo.removeEventListener(Event.COMPLETE, picDone);
				myE.dispatchEvent(new Event(Event.COMPLETE));
			}
			return myE;			
		}
		
		// SOUND		
		public static function sound(u:String, loop:Boolean=false):Easy {
			var myE:Easy = new Easy();
			var myS:Sound = new Sound(new URLRequest(u));
			var num:Number;
			if (loop) {num = 1000000;} else {num = 1;}
			var myC:SoundChannel = myS.play(0,num);
			myE.sound = myS;
			myE.channel = myC;
			return myE;
		}
		public static function volume(myE:Easy, v:Number):Easy {						
			if (!verifySound(myE)) {return myE;}
			myE.channel.soundTransform = new SoundTransform(v);
			return myE;
		}
		
		private static var fadeCheck:Boolean = false;
		private static var fades:Dictionary = new Dictionary(true);
		public static function fadeIn(myE:Easy, d:Number):Easy {						
			fade(myE,d);
			return myE;
		}
		public static function fadeOut(myE:Easy, d:Number):Easy {						
			fade(myE,d,false);
			return myE;
		}
		private static function fade(myE:Easy, d:Number, fadeIn:Boolean=true):void {
			
			if (!verifySound(myE)) {return;}
			if (d <= 0) {return;}
			
			var interval:Number = 100;
			
			// calculate fade steps (could have both fade in and out)
			myE.volume = SoundChannel(myE.channel).soundTransform.volume;
			if (fadeIn) {
				Easy.volume(myE,0);
				myE.fadeIn = true;
				myE.fadeInSteps = d * 1000 / interval				
				myE.fadeInVol = myE.volume / myE.fadeInSteps;
				myE.fadeInNum = 0;
				
			} else {
				myE.fadeOut = true;
				myE.fadeOutSteps = d * 1000 / interval				
				myE.fadeOutVol = myE.volume / myE.fadeOutSteps;
				myE.fadeOutNum = 0;
			}
						
			// register for a fade
			fades[myE] = 1;			
						
			// just use one timer to handle all fades
			if (!fadeCheck) {
				fadeCheck = true;
				var myT:Timer = new Timer(interval);
				myT.start();
				myT.addEventListener(TimerEvent.TIMER, fade);
				function fade(e:TimerEvent):void {					
					//o.channel.soundTransform = new SoundTransform(v);								
					for (var i:Object in fades) {
						if (i.sound.length <= 0) {return;}
						if (i.fadeIn) {
							if (i.fadeInNum < i.fadeInSteps) {								
								i.fadeInNum++;
								i.channel.soundTransform = new SoundTransform(i.volume*i.fadeInNum/i.fadeInSteps);
							} else {
								i.fadeIn = false;
								i.channel.soundTransform = new SoundTransform(i.volume);
							}
						}
						
						if (i.fadeOut) { // && (i.fadeOutNum > 0 || (i.sound.length - i.channel.position) < i.fadeOutSteps * interval)) {
							i.fadeIn = false;
							if (i.fadeOutNum < i.fadeOutSteps) {								
								i.fadeOutNum++;
								i.channel.soundTransform = new SoundTransform(i.volume*(i.fadeOutSteps-i.fadeOutNum)/i.fadeOutSteps);
							} else {								
								i.fadeOut = false;
								i.channel.soundTransform = new SoundTransform(0);
							}
						}
					}
				}
			}			
		}
		private static function verifySound(myE:Easy):Boolean {
			if (myE.sound is Sound && myE.channel is SoundChannel) {				
				return true;
			} else {
				trace ("need Easy.sound Object");
				return false;
			}
		}
		
		
		// DATA		
		public static function server(u:String, vars:Object=null):Easy {			
			var myE:Easy = new Easy();
			var myVars:URLVariables = new URLVariables(); 
			if (vars) {
				for (var i:String in vars) {
					myVars[i] = vars[i];
				}
			} 
			var myRequest:URLRequest = new URLRequest();
			myRequest.url=u+"?rand="+Math.random();
			myRequest.method=URLRequestMethod.POST;
			myRequest.data=myVars;			
			
			var myLoader:URLLoader = new URLLoader(); 			
			myLoader.dataFormat = URLLoaderDataFormat.VARIABLES;			
			myLoader.addEventListener(Event.COMPLETE, getData);
			myLoader.addEventListener(IOErrorEvent.IO_ERROR, getError);		
			myLoader.load(myRequest);
			function getData(e:Event):void {						
				myE.data = new URLVariables(e.target.data);				
				myE.error = false;
				myE.dispatchEvent(new Event(Event.COMPLETE));			
			}			
			function getError(e:IOErrorEvent):void {
				myE.error = true;
				myE.dispatchEvent(new Event(Event.COMPLETE));
			}	
			return myE;			
		}
		
		public static function xml(u:String, vars:Object=null):Easy {			
			var myE:Easy = new Easy();
			var myRequest:URLRequest = new URLRequest();
			myRequest.url=u;
			myRequest.method=URLRequestMethod.POST;
			
			var myLoader:URLLoader = new URLLoader(); 		
			myLoader.addEventListener(Event.COMPLETE, getData);
			myLoader.addEventListener(IOErrorEvent.IO_ERROR, getError);		
			myLoader.load(myRequest);
			function getData(e:Event):void {						
				myE.data = e.target.data;				
				myE.error = false;
				myE.dispatchEvent(new Event(Event.COMPLETE));			
			}			
			function getError(e:IOErrorEvent):void {
				myE.error = true;
				myE.dispatchEvent(new Event(Event.COMPLETE));
			}	
			return myE;			
		}					

	}
	
}
