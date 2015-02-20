package com.danzen.interfaces {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import fl.data.DataProvider;
	import fl.controls.TextArea;
		
	public class Export extends MovieClip {
		
		public static const EXIT:String = "exit";
		
		private var myPane:Pane;
		private var myText1:TextArea;
		private var myText2:TextArea;
		private var myText3:TextArea;
		
		public function Export(theTitle:MovieClip, theW:Number, theH:Number, theDrag:Boolean, theColNames:Array, theColWidths:Array, theProvider:DataProvider, theAlpha:Number = .7, theCurve:Boolean = true) {
			
			trace ("hi from Export");
			
			myPane = new Pane(theW, theH, theDrag, 0xFFFFFF, 1, theCurve, false, true);
			addChild(myPane);
			myPane.addChild(theTitle);
			theTitle.x = 0; theTitle.y = 0;
			
			var margin:Number = 24;
			/*myGrid = new DataGrid();
			myGrid.width = theW - 2 * margin;
			myGrid.height = theH - 2 * margin - theTitle.height;
			myPane.addChild(myGrid);
			myGrid.dataProvider = theProvider;
			myGrid.columns = theColNames;
			myGrid.horizontalScrollPolicy = ScrollPolicy.ON;
			for (var i:uint=0; i<theColWidths.length; i++) {
				myGrid.getColumnAt(i).width = theColWidths[i];
			}			
			myGrid.x = margin;
			myGrid.y = 76;		
			myGrid.alpha = theAlpha;			*/
			myPane.addEventListener(Pane.EXIT, exitPane);
		}
		
		private function exitPane(e:Event) {
			dispatchEvent(new Event(Report.EXIT));
		}
		
		public function dispose() {
			myPane.dispose();
		}
		
	}
	
}