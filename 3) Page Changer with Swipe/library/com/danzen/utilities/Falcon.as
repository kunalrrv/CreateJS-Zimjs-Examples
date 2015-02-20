
package com.danzen.utilities {

	// FALCON INTRODUCTION  
	// Falcon lets you send and receive data with one class
	// use Falcon to read in text or XML or communicate with a server script like PHP
	// See FalconProvider to see how you can easily get server data into a DataProvider (DataGrid, List, etc.)

	// http://falconflash.wordpress.com - by inventor Dan Zen - http://www.danzen.com
	// if you are using Falcon for commercial purposes, you are welcome to donate to Dan Zen
	// donations can be made to agency@danzen.com at http://www.paypal.com
	
	// INSTALLING CLASSES
	// suggested installation:
	// create a "classes" folder on your hard drive - for example c:\classes
	// add the classes folder to your Flash class path:
	// Flash menu choose Edit > Preferences > ActionScript - ActionScript 3 Settings 
	// then use the + sign for the source path box to add the path to your classes folder	
	// put the provided com/ directory with its folders and files in the classes folder
	// the readme has more information if you need it
	
	// USING FALCON
	// See the samples for how to call Falcon from a document class for instance	
	// you basically, create a new Falcon Object and pass it the URL, dataType and variables to send (optional)
	// addEventListener to receive the Event.COMPLETE event and ask for your Falcon object's data property
	// make a new Object each time you want to send or receive data
	// if you just want to send data to a server script you still must receive data in cgi-format
	// so just have your server script return status=good or some such key=value pair

	// CONSTRUCTOR
	// new Falcon(serverFile:String, type:String = Falcon.VARIABLES, myVars:Object = {});
	//		Parameters:
	//		serverFile is the name of your XML or txt file or server script like a php file
	//		type is Falcon.VARIABLES, Falcon.TEXT, Falcon.XML_DATA, Falcon.BINARY
	//		you can't write to TEXT, XML_DATA or BINARY files 
	//		use VARIBLES and a server script to write to these types of files
	
	//  METHODS
	//	none
	
	//  PROPERTIES
	//	data:*	populated just before the COMPLETE event is dispatched
	//			holds your XML, Text, Binary or Variable data
	//			for XML it is XML
	//			for Variables just ask for data.yourVariable
	//  error:Boolean
	//			whether there was an error or not
	//			will not capture an error if 
	
	//  CONSTANTS
	//  Falcon.VARIABLES:String
	//	Falcon.TEXT:String
	//	Falcon.XML_DATA:String
	//	Falcon.BINARY:String	

	import flash.display.Sprite;
	import flash.events.*;

	// classes for server script connection
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.events.IOErrorEvent;
	
	public class Falcon extends Sprite {

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

		public function Falcon(theURL:String, theDataType:String=Falcon.VARIABLES, theSendObject:Object=null) {
			
			//trace ("hi from Falcon");
			
			myDataType = theDataType;
			
			// set up the objects to send and receive data
			
			myVars = new URLVariables(); // this holds variables to send (as dynamic properties)
			if (theSendObject) {
				for (var i:Object in theSendObject) {
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
			try {
				myLoader.load(myRequest);// this sends the variables and loads new data from php
			} catch (e:Error) {
				trace ("oops"); // does not seem to catch!
			}
				
			
		}
		
		private function getData(e:Event):void {
			// the data comes into the e.target.data property
			// if the data is of the format URLLoaderDataFormat.TEXT then just use the data
			// if the data is VARIABLES then convert the data into variable form like so:
			
			if (myDataType == Falcon.VARIABLES) {				
				data = new URLVariables(e.target.data);
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
		
		private function getError(e:IOErrorEvent):void {
			error = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}

	}
}