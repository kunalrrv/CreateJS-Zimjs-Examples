
package com.danzen.utilities {

	// FALCONPROVIDER INTRODUCTION  
	// FalconProvider lets you send and receive data with one class 
	// the difference between this class and Falcon is that this class puts data into a DataProvider
	// use Falcon if you are not using a DataProvider for a DataGrid, ComboBox, List component etc.

	// http://falconflash.wordpress.com - by inventor Dan Zen - http://www.danzen.com
	// if you are using FalconProvider for commercial purposes, you are welcome to donate to Dan Zen
	// donations can be made to agency@danzen.com at http://www.paypal.com
		
	// INSTALLING CLASSES
	// suggested installation:
	// create a "classes" folder on your hard drive - for example c:\classes
	// add the classes folder to your Flash class path:
	// Flash menu choose Edit > Preferences > ActionScript - ActionScript 3 Settings 
	// then use the + sign for the source path box to add the path to your classes folder	
	// put the provided com/danzen/ directory with its folders and files in the classes folder
	// the readme has more information if you need it
	
	// USING FALCONPROVIDER
	// See the samples for how to call FalconProvider from a document class for instance
	// you must have a component that uses a DataProvider in the library (DataGrid, ComboBox, List)
	// you create a new FalconProvider Object and pass it the URL, dataType and variables to send (optional)
	// addEventListener to receive the Event.COMPLETE event and in the event method
	// you can set the dataProvider property of your component to the FalconProvider's dataProvider property
	// your server script (like PHP) must return a cgi-formated variables with an increasing index number like so:
	// age1=29&name1=Dan&age2=32&name2=Roger&age3=22&name3=Paula etc.
	// make a new Object each time you want to send or receive data
	

	// CONSTRUCTOR
	// new FalconProvider(serverFile:String, type:String = Falcon.VARIABLES, myVars:Object = {});
	//		Parameters:
	//		serverFile is the name of your server script like a php file
	//		type for FalconProvider should be Falcon.VARIABLES (default)
	//		can use FalconProvider for other types if you want
	
	//  METHODS
	//	none
	
	//  PROPERTIES
	//	data:*	populated just before the COMPLETE event is dispatched
	//			holds your Variables just ask for data.yourVariable
	//	dataProvider:DataProvider
	//			holds a DataProvider created based on your script input
	//			script must send back variables with an increasing index
	//  error:Boolean
	//			whether there was an error or not
	//			will not capture an error if 
	
	//  CONSTANTS
	//  Falcon.VARIABLES:String
	//	Falcon.TEXT:String
	//	Falcon.XML_DATA:String
	//	Falcon.BINARY:String		

	import flash.display.MovieClip;
	import flash.events.*;
	import fl.data.DataProvider;

	// classes for server script connection
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.events.IOErrorEvent;
	
	public class FalconProvider extends MovieClip {
		
		// there must be a component that uses a DataProvider in the FLA
		// such as a DataGrid, ComboBox, List, etc.

		public static const VARIABLES:String = "variables";
		public static const TEXT:String = "text";
		public static const BINARY:String = "binary";
		public static const XML_DATA:String = "XML";
		
		private var myRequest:URLRequest;
		private var myVars:URLVariables;
		private var myLoader:URLLoader;
		private var myDataType:String;
		
		public var data:Object;
		public var error:Boolean;
		public var dataProvider:DataProvider = new DataProvider();

		public function FalconProvider(theURL:String, theDataType:String=FalconProvider.VARIABLES, theSendObject:Object=null) {
			
			//trace ("hi from FalconProvider");
			
			myDataType = theDataType;
			
			// set up the objects to send and receive data
			
			myVars = new URLVariables(); // this holds variables to send (as dynamic properties)
			if (theSendObject) {
				for (var i in theSendObject) {
					myVars[i] = theSendObject[i];
				}
			} 
			myRequest = new URLRequest();// this prepares the request for the loader
			myRequest.url=theURL;
			myRequest.method=URLRequestMethod.POST;
			myRequest.data=myVars;
			
			
			myLoader = new URLLoader(); // this is the loader that will send and receive			
			if (myDataType != Falcon.XML_DATA) {
				var myLookup:Object = {
					text:URLLoaderDataFormat.TEXT,
					variables:URLLoaderDataFormat.VARIABLES,
					binary:URLLoaderDataFormat.BINARY
				}
				myLoader.dataFormat = myLookup[myDataType];
			}
			myLoader.addEventListener(Event.COMPLETE, getData);
			myLoader.addEventListener(IOErrorEvent.IO_ERROR, getError);		
			myLoader.load(myRequest);// this sends the variables and loads new data from php
				
			
		}
		
		private function getData(e:Event) {
			// the data comes into the e.target.data property
			// if the data is of the format URLLoaderDataFormat.TEXT then just use the data
			// if the data is VARIABLES then convert the data into variable form like so:
			
			if (myDataType == Falcon.VARIABLES) {
												
				data = new URLVariables(e.target.data);
				
				//-----------------------------------------------------------
				// check for sequential data - name1, age1, name2, age2, etc.
				var mySeries:Object = {};
				var max:Number = 0;
				var min:Number = int.MAX_VALUE;
				for (var d in data) {					
					var re:RegExp = /(\D+)(\d+)$/;
					var myMatches:Object = re.exec(d);
					if (myMatches) {
						var prefix:String = myMatches[1]; // name, age, etc.
						var suffix:Number = Number(myMatches[2]); // 1, 2, etc.
						max = Math.max(max, suffix);
						min = Math.min(min, suffix);
						if (!mySeries[prefix]) {
							mySeries[prefix] = [];
						}
						mySeries[prefix][suffix] = data[d];
					}					
				}				
				// if there is sequential data then put it into a DataProvider
				if (!isNaN(suffix)) {
					var tempDataProvider:Array = [];
					var providerRow:Object;
					for (var i:uint=min; i<=max; i++) {
						providerRow = {};
						for (var j in mySeries) {
							providerRow[j] = (mySeries[j][i]) ? mySeries[j][i] : "";
						}		
						tempDataProvider.push(providerRow);
					}					 
					dataProvider = new DataProvider(tempDataProvider);
				}			
				//-----------------------------------------------------------
				
			} else {
				if (myDataType == Falcon.XML_DATA) {
					data = XML(e.target.data);									
				} else if (myDataType == Falcon.TEXT) {					
					data = e.target.data.replace(/\r/g, "");
				} else {
					data = e.target.data;
				}
			}
			
			error = false;
			dispatchEvent(new Event(Event.COMPLETE));			
		}
		
		private function getError(e:IOErrorEvent) {			
			error = true;
			trace (e);
			for(var i:Object in e) {
				trace(i);
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}

	}
}