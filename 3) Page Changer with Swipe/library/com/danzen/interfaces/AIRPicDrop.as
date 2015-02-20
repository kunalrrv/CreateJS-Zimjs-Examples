package com.danzen.interfaces
{
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.ClipboardTransferMode;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeDragManager;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.filesystem.File;
	import flash.net.URLRequest;		
	
	public class AIRPicDrop extends Sprite
	{
		private var myTargetClip:Sprite;		
		private var myLoader:Loader;
		private var myExtensions:Array;		
		private var myFile:String;		
		private var myFileList:Array;
		private var myFileNum:Number;		
		private var myTempFile:String;		
		private var myTempFileList:Array;
		private var myTempFileNum:Number;
		
		public var fileList:Array;
		public var numFiles:Number;
		public var pic:Sprite;
		
		public static const PIC_READY:String = "picReady";
		
		public function AIRPicDrop(theTargetClip:Sprite, thePicExtensions:Array=null)
		{
			trace ("hi from AIRPicDrop");			
		
			myTargetClip = theTargetClip;
			myExtensions = (thePicExtensions) ? thePicExtensions : ["jpg", "jpeg", "gif", "png"];
		
			pic = new Sprite(); // holds the current picture
			
			myLoader = new Loader();
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, setPic);	
					
			// see if they have dropped a file on the application icon 
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, doInvoke);		   
			
			// check to see stuff dragged onto the ball
			myTargetClip.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, dragEnter);
			myTargetClip.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, dragDrop);
			myTargetClip.addEventListener(NativeDragEvent.NATIVE_DRAG_EXIT, dragExit);
		}
		
		private function doInvoke(e:InvokeEvent):void {
			if (e.arguments.length > 0) {
				var myArray:Array = [];
				// turn the array of strings into File objects 
				for(var i:uint=0; i<e.arguments.length; i++) {
					myArray.push(new File(e.arguments[i]));
				}
				if (getFiles(myArray)) {
					loadMyFile();
				}
			}							
		}
		
		private function dragEnter(e:NativeDragEvent):void {			
			// casting as Array(myData...) does not work because Array() is a global function
			var myArray:Array = e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			if (getFiles(myArray)) {
				// need to call this to accept the drop					
				NativeDragManager.acceptDragDrop(myTargetClip);
			}
		}		
		
		private function dragDrop(e:NativeDragEvent):void {						
			loadMyFile();			
		}		
		
		private function dragExit(e:NativeDragEvent):void {
			trace ("drag exit");
		}
		
		// -------  methods to get the file list (AIR)
		
		// prepares a temporary list of files from an array of filenames
		// if the array has one file, the files in the directory are collected
		// this temporary list will get applied when the file (or files) is dropped
		
		private function getFiles(myArray:Array):Boolean {
			myTempFileList = [];		
			var i:uint;
			for(i=0; i<myArray.length; i++) {
				var file:File = myArray[i];
				if (file.isDirectory) {continue;}
				if (myExtensions.indexOf(file.extension.toLowerCase()) != -1) {
					myTempFileList.push(file);					
				}								
			}			
			if (myTempFileList.length > 0) {
				myTempFile = myTempFileList[0].url
				myTempFileNum = 0;				
				if (myTempFileList.length == 1) {
					// get other files in directory
					myTempFileList = getDirectoryFiles(myTempFileList[0]);
				}						
				return true;
			} else {
				return false;
			}
		}
		
		private function getDirectoryFiles(f:File):Array {
			var directoryList:Array = f.parent.getDirectoryListing();		
			var addFiles:Array = [];
			var count:Number = 0;
			for (var i:uint=0; i<directoryList.length; i++) {
				var file:File = directoryList[i];				
				if (file.isDirectory) {continue;}
				if (myExtensions.indexOf(file.extension.toLowerCase()) != -1) {
					if (f.url == file.url) {
						myTempFileNum = count;
					}
					addFiles.push(file);	
					count++;
				}				
			}
			return addFiles;
		}		
		
		// -------  loader method and prev next public methods 
		
		private function loadMyFile():void {
			myFileList = myTempFileList;
			myFile = myTempFile;					
			myFileNum = myTempFileNum;
			myLoader.load(new URLRequest(myFile));
		}
		
		public function prev():void {			
			var newFile:Number = myFileNum - 1;
			if (newFile < 0) {
				newFile = myFileList.length-1;
			}
			myFile = myFileList[newFile].url;
			myFileNum = newFile;
			myLoader.load(new URLRequest(myFile));
			
		}
		public function next():void {
			var newFile:Number = myFileNum + 1;
			if (newFile > myFileList.length-1) {
				newFile = 0;
			}
			myFile = myFileList[newFile].url;
			myFileNum = newFile;
			myLoader.load(new URLRequest(myFile));			
		}						
		
		// -------  loader event
		
		private function setPic(e:Event):void {			
			pic.addChild(myLoader);
			dispatchEvent(new Event(AIRPicDrop.PIC_READY));
		}
		
	}
}