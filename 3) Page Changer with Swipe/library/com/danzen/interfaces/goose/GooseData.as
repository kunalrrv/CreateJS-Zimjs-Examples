package com.danzen.interfaces.goose {
	
	import flash.display.Sprite;
    import flash.events.*;
	import flash.utils.Timer;
	
	// GOOSE OVERVIEW  
	// In general, Goose lets you work with multiple cursor inputs - like multitouch
	// Goose splits into two parts:
	
	// 1. A multitouch emulator (GooseData, GooseRobin, Online Mouse Nodes)
	// 		with the Goose Emulator you run the online Mouse Nodes on two or more computers
	//		each mouse then feeds data through GooseRobin to GooseData
	//		you then feed the data from GooseData into Goose (part 2)	
	
	// 2. A custom class to process the data (Goose, GooseEvent)
	//		Goose takes in multitouch data (like from the emulator in part 1)
	//		and shows multiple cursors in your application
	//		so if you use the Goose Emulator then each mouse shows up as a cursor
	//		Goose and GooseEvent provide a set of methods and events for using the cursors
	//      You continue to use Goose when going from an emulator to real multitouch data
	
	// GOOSEDATA  	
	// GooseData uses GooseRobin to receive multiple mouse data from different computers
	// mouse nodes are available at http://www.danzen.com/goose/node.html
	// or if you set up Robin yourself then you can make and administer your own nodes
	// Robin is available at http://robinflash.wordpress.com
	// if you do use your own Robin then you need to change the server address
	// in GooseRobin and the MultiuserEmulator
	// this would make sure that you have control over maintenance of the system
	// it also lets you try out Robin - the PHP multiuser server
	
	// you can also write your own data class to send data into Goose
	// Goose is set up so that once you emulate, you can switch over to real data
	// so if you run your own Blob Detect table, you can feed that data in to Goose
	// see http://dodoflash.wordpress.com for a Blob Detection option
	// the format of the data is quite simple and is available at http://multiml.wordpress.com
	// if you have a different data format, it will be quite easy for you to convert it
	
	// USING GOOSEDATA
	// make sure that you have the provided com folder in a folder that is in your class path
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
	// see Goose for more information on how to use Goose
	
		
	public class GooseData extends Sprite {
		
		public var xmlData:XML;
		
		private var myRobin:GooseRobin;		
		private var myAppName:String = "goose"; // leave this as goose
		
		private var lastX:Number=0;
		private var lastY:Number=0;
		private var lastType
		
		private var myTimer:Timer;
		private var dataPath:String;		
		private var period:Number = 200;
				
        public function GooseData(theAppName:String) {
			trace ("hi from GooseData");
			myAppName += "_" + theAppName;
			myAppName = myAppName.replace(/[\n\r]/g,"");
			myAppName = myAppName.replace(/\s/g,"");
			myRobin = new GooseRobin(myAppName);			
			myRobin.addEventListener(Event.CONNECT, myRobinConnected);			
			myRobin.addEventListener(DataEvent.DATA, myRobinChange);			
        }		
		private function myRobinConnected(e:Event) {			
			trace ("connected");
			dispatchEvent(new Event(Event.CONNECT));			
		}
				
		private function myRobinChange(e:Event) {
			var theXML:String = "<manyml>\n";
			if (myRobin.getProperties("x")) {
				for (var i:uint = 0; i < myRobin.getProperties("x").length; i++) {	
					if (myRobin.getProperties("id")[i] == "") {continue;}
					theXML += '<item id="' + myRobin.getProperties("id")[i] + '" x="' + myRobin.getProperties("x")[i] + '" y="' + myRobin.getProperties("y")[i] + '" z="' + myRobin.getProperties("z")[i] + '" />\n';
				}
			}
			theXML += "</manyml>";
			xmlData = XML(theXML);
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function dispose() {
			myRobin.removeEventListener(Event.CONNECT, myRobinConnected);			
			myRobin.removeEventListener(DataEvent.DATA, myRobinChange);	
			myRobin.dispose();
		}		
    }
} 