package com.danzen.frameworks {
	
	/*	
	ZenPage - by Inventor Dan Zen - http://danzen.com - free to use and change
	Used in Touchy and Tilty mobile apps: http://touchy.mobi http://tilty.mobi	
	Sample file http://danzen.com/zenpage/zenpage.zip
	More AS Classes at http://flashfeathers.com http://easyactionscript.wordpress.com
	
	ZenPage is a light framework class to handle pages, buttons and navigation
	
	ASSETS
	Stack pages in a single MovieClip with instance names for each page.
	Optionally, also stack background clips with instance names (helps to reuse backrounds)
	Separating backgrounds allows for different background graphics for multiple screen sizes
	and different scaling and positioning for content and backgrounds (common in mobile).
	All your buttons should be in the pages clips with instance names along with the content.
	
	CODE
	See the ZenPageExample file for how to use ZenPage.
	In general, how it works is you pass ZenPage the assets 
	From then on you access the pages through ZenPage if you have to	
	You also pass ZenPage XML that identifies your pages and buttons
	and sets which page a button goes to or what command to call if it is a function.
	If you have no commands, your navigation is complete - you don't have to do a thing.
	If you do have commands, you have to specify actions for the commands like navigateToURL	
	
	*/
	
	import flash.display.MovieClip;
	import flash.events.*;
	
	public class ZenPage extends MovieClip	{
		
		private var assets:MovieClip;
		private var pagesXML:XML;		
		private var pages:Object = {};
				
		public static const COMMAND:String = "command"; // event for command call
		public var command:String; // command event puts command string here
		public var param:String; // command puts param value here
		
		public function ZenPage(theAssets:MovieClip, thePagesXML:XML) {	
			
			trace ("hi from ZenPage");
			
			assets = theAssets;
			pagesXML = thePagesXML;				
			preparePages();			
		}
		
		private function preparePages():void {
					
			var page:XML;
			var p:MovieClip;
			var button:XML;
			var b:MovieClip;
			
			for each (page in pagesXML.page) {
				pages[page.@name] = MovieClip(assets[page.@name]);	
			}
						
			for each (page in pagesXML.page) {
				p = MovieClip(pages[page.@name]);	
				if (page.@backing) {
					p.backing = MovieClip(assets[page.@backing]);
				} 
				for each (button in page.button) {
					b = MovieClip(p[button.@name]);
					b.buttonMode = true;	
					// add info to button clip
					b.go = ("@go" in button) ? button.@go : null;
					b.command =  ("@command" in button) ? button.@command: null;
					b.param = ("@param" in button) ? button.@param : null;
					b.addEventListener(MouseEvent.CLICK, goPage);
				}
			}			
		}
		
		private function goPage(e:MouseEvent):void {			
			var b:MovieClip = MovieClip(e.currentTarget);	// button		
			if (b.go) {
				go(pages[b.go]);
			} 
			if (b.command) {
				command = b.command
				param = b.param;
				dispatchEvent(new Event(ZenPage.COMMAND));
			} 
		}
		
		public function go(p:MovieClip):void {			
			while (numChildren > 0) {
				removeChildAt(0);				
			}	
			if (p.backing) {
				addChild(p.backing);
			}
			addChild(p);			
		}
		
		public function getPages():Object {
			return pages;
		}
		
	}
}