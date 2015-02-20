package com.danzen.interfaces
{
	// class to create a grid with totals and worths and average
	// works with existing Flex Spark components
	// currently hardcoded for RANK app setting of colWorth, colTotals, colAve
	// just not enough time to make it generic
	// Dan Zen http://www.danzen.com
	
	import flash.display.Sprite;
	import flash.events.*;
	
	import spark.components.Label;
	
	public class ChartFlex extends Sprite
	{
		private var chartObj:Object; // {array:Array eg [[1,2,3],[4,5,6]], tiler:s:TileGroup, width:Number, height:Number, styleName:String, styleSelected:String}
		private var fillSquares:Number; // want to make a grid still when nothing there - this max cols or rows to fill display + a little extra
		private var colTotalObj:Object; // {tiler:s:TileGroup, width:Number, height:Number, styleName:String, styleSelected:String, type:String eg ChartFlex.PERCENT or ChartFlex.NUMBER}
		private var rowTotalObj:Object; // {tiler:s:TileGroup, width:Number, height:Number, styleName:String, styleSelected:String, type:String eg ChartFlex.PERCENT or ChartFlex.NUMBER}
		private var colAveObj:Object; // {label:s:Label, total:s:Label, type:String eg ChartFlex.PERCENT or ChartFlex.NUMBER}
		private var rowAveObj:Object; // {label:s:Label, total:s:Label, type:String eg ChartFlex.PERCENT or ChartFlex.NUMBER}
		private var colWorthObj:Object; // {array:Array eg [1,2,3], tiler:s:TileGroup, width:Number, height:Number, styleName:String, styleSelected:String}
		private var rowWorthObj:Object; // {array:Array eg [1,2,3], tiler:s:TileGroup, width:Number, height:Number, styleName:String, styleSelected:String}
		
		public static const PERCENT:String = "percent";
		public static const NUMBER:String = "number";
		public static const RANK:String = "rank";
		public static const WORTH_CHANGE:String = "worthChange"; // Event type dispatched when worth changes 
		public static const CHART_CHANGE:String = "chartChange"; // Event type dispatched when chart changes 
		
		//private var fillSquares:int = 50;
		private var numRows:int = 0;
		private var numCols:int = 0;
		private var numFillRows:int;
		private var numFillCols:int;
		private var currentRow:int=-1;
		private var currentCol:int=-1;	
		private var sortHighest:Boolean = true;
		private var sortObject:Array = [];
		
		private var myType:String = RANK;
		
		public function ChartFlex(chartObject:Object,
							  chartFillSquares:Number=40,						   
							  colTotalObject:Object=null, 
							  rowTotalObject:Object=null, 
							  colAveObject:Object=null, 
							  rowAveObject:Object=null,
							  colWorthObject:Object=null, 
							  rowWorthObject:Object=null) {			
			
			chartObj=chartObject;
			fillSquares=chartFillSquares;
			colTotalObj=colTotalObject;
			rowTotalObj=rowTotalObject;
			colAveObj=colAveObject;
			rowAveObj=rowAveObject;
			colWorthObj=colWorthObject;
			rowWorthObj=rowWorthObject;	
			
			if (colAveObject.type == RANK || colAveObject.type == PERCENT || colAveObject.type == NUMBER) { 
				myType = colAveObject.type;
			}
			
			numRows = chartObj.array.length;
			numCols = chartObj.array[0].length;
			
			numFillRows = Math.max(numRows, fillSquares);
			numFillCols = Math.max(numCols, fillSquares);
			
			colWorthObj.tiler.requestedColumnCount=numFillCols;
			colWorthObj.tiler.requestedRowCount=1;
			colTotalObj.tiler.requestedColumnCount = 1;
			colTotalObj.tiler.requestedRowCount=numFillRows;
			chartObj.tiler.requestedColumnCount=numFillCols;
			chartObj.tiler.requestedRowCount=numFillRows;				
			
			setChart();				
			updateChart();			
			
		}		
		
		public function doSort():Array {
			//sortObject = [{num:1, val:44}, {num:2, val:22}, {num:3, val:33}];
			if (sortHighest) {				
				sortObject.sortOn(["val","num"], [Array.NUMERIC | Array.DESCENDING, Array.NUMERIC]);				
			} else {
				sortObject.sortOn(["val","num"], [Array.NUMERIC, Array.NUMERIC]);
			}
			sortHighest = !sortHighest;
			var newChart:Array = [];
			var order:Array = [];
			for (var i:uint=0; i<chartObj.array.length; i++) {
				order.push(sortObject[i].num);
				newChart.push(chartObj.array[sortObject[i].num]);
			}
			chartObj.array = newChart.slice(0);
			updateChart();
			return order;
		}
		
		public function showRank():Array { // auto sort on show - not using...
			sortHighest == false;
			myType = ChartFlex.RANK;
			return doSort();
		}
		
		private function setChart():void {
			
			// function adds NumberPressFlex objects or labels to chart, worth, and totals
			// these may be blank to maintain the grid
			// as rows and cols get added, need to run this again
			// do not want to remake elements so it always adds if necessary
			// it does not take away - there is no real point			
			// on reloading the app it will create the chart with the most efficient layout
			// the updateChart() always redraws the numbers correctly coresponding to data	
			// run setChart at start, when adding rows or cols and changing rank files
			
			var numPress:NumberPresserFlex;
			var lab:Label;
					
			numFillRows = Math.max(numRows, fillSquares);
			numFillCols = Math.max(numCols, fillSquares);
						
			colWorthObj.tiler.requestedColumnCount=numFillCols;
			colWorthObj.tiler.requestedRowCount=1;
			colTotalObj.tiler.requestedColumnCount = 1;
			colTotalObj.tiler.requestedRowCount=numFillRows;
			chartObj.tiler.requestedColumnCount=numFillCols;
			chartObj.tiler.requestedRowCount=numFillRows;	
									
			// chart top 
			if (colWorthObj.tiler.numElements < numFillCols) {
				for (var i:uint=colWorthObj.tiler.numElements; i<numFillCols; i++) {					
					numPress = new NumberPresserFlex(999,0,false);
					numPress.styleName = colWorthObj.styleName;				
					numPress.width = colWorthObj.width;
					numPress.height = colWorthObj.height;	
					numPress.addEventListener(Event.CHANGE, worthDrag);
					numPress.addEventListener(Event.COMPLETE, worthChange);
					numPress.num = i;
					colWorthObj.tiler.addElement(numPress);						
				}
			}
			
			// chart totals
			if (colTotalObj.tiler.numElements < numFillRows) {
				for (i=colTotalObj.tiler.numElements; i<numFillRows; i++) {					
					lab = new Label();
					lab.styleName = colTotalObj.styleName;				
					lab.width = colTotalObj.width;
					lab.height = colTotalObj.height;					
					colTotalObj.tiler.addElement(lab);						
				}	
			}
			
			// chart
			if (chartObj.tiler.numElements < numFillCols*numFillRows) {
				for (i=chartObj.tiler.numElements; i<numFillCols*numFillRows; i++) {					
					numPress = new NumberPresserFlex();					
					numPress.styleName = chartObj.styleName;					
					numPress.width = chartObj.width;
					numPress.height = chartObj.height;	
					numPress.addEventListener(Event.COMPLETE, chartChange);
					numPress.num = i;
					numPress.value = 1;
					chartObj.tiler.addElement(numPress);								
				}		
			}
		}		
		
		private function updateChart():void {
			var numPress:NumberPresserFlex;
			var lab:Label;
			var totalsArray:Array = [];
			var topTotals:Number = 0;
			sortObject = [];
						
			// chart top
			for (var i:uint=0; i<numFillCols; i++) {
				numPress = NumberPresserFlex(colWorthObj.tiler.getElementAt(i));
				if (i < numCols) {					
					numPress.value = colWorthObj.array[i];					
					numPress.active = true;
					topTotals += numPress.value;
				} else {
					numPress.value = -1;
					numPress.active = false;
				}
			}	
			
			// prepare totalsArray
			for (i=0; i<numRows; i++) {
				totalsArray[i] = 0;
			}
			
			// chart				
			var r:Number; var c:Number;			
			for (i=0; i<numFillCols*numFillRows; i++) {
				r = Math.floor(i/numFillCols);
				c = Math.floor(i%numFillCols);
				numPress = NumberPresserFlex(chartObj.tiler.getElementAt(i));
				if (r < numRows && c < numCols) {		
					numPress.maxNumber = colWorthObj.array[c];
					numPress.value = chartObj.array[r][c];					
					numPress.active = true;
					totalsArray[r] += numPress.value;					
				} else {					
					numPress.value = -1;					
					numPress.active = false;
				}
			}			
			
			var tot:Number = 0;
			var val:Number = 0;
			var lastTotal:int = -1;
			var ties:int = 0;
			sortObject = [];
			
			if (myType == RANK) {				
				for (i=0; i<numFillRows; i++) {
					lab = Label(colTotalObj.tiler.getElementAt(i));
					if (i < numRows) {							
						val = Math.round(totalsArray[i]);	
						sortObject[i] = {num:i, val:val}
					}					
				}				
				sortObject.sortOn(["val","num"], [Array.NUMERIC | Array.DESCENDING, Array.NUMERIC]);				
			
				var newChart:Array = [];
				var order:Array = [];
				var ord:int;
				for (i=0; i<sortObject.length; i++) {					
					if (sortObject[i].val == lastTotal) {							
						ties++;
					}	
					ord = i+1-ties;
					order[sortObject[i].num] = ord;
					lastTotal = sortObject[i].val;
				}				
			}
			
			
			/*
			if (sortHighest) {				
				sortObject.sortOn("val", Array.NUMERIC | Array.DESCENDING);				
			} else {
				sortObject.sortOn("val", Array.NUMERIC);
			}
			sortHighest = !sortHighest;
			var newChart:Array = [];
			var order:Array = [];
			for (var i:uint=0; i<chartObj.array.length; i++) {
				order.push(sortObject[i].num);
				newChart.push(chartObj.array[sortObject[i].num]);
			}
			chartObj.array = newChart.slice(0);
			updateChart();
			return order;	
			*/
			
			
			
			
			// chart totals
			tot = 0;
			val = 0;	
			sortObject = [];
			for (i=0; i<numFillRows; i++) {
				lab = Label(colTotalObj.tiler.getElementAt(i));
				if (i < numRows) {	
					if (myType == RANK) {			
						lab.text = String(order[i]);						
						//val = order[i];
						//sortObject[i] = {num:i, val:numRows-val}				
						//lab.text = String(val);						
					} else if (myType == PERCENT) {
						val = Math.round(totalsArray[i]/topTotals*100);
						lab.text = String(val);
					} else {
						val = Math.round(totalsArray[i]);
						lab.text = String(val);
					}		
					// keep a sortObject prepared to help future doSort()
					val = Math.round(totalsArray[i]);	
					sortObject[i] = {num:i, val:val}
					tot += totalsArray[i];
				} else {
					lab.text = "";
				}				
			}	
			//colAveObj.label.text = String(Math.floor(tot/topTotals*1000/numRows)/10);
			if (myType == RANK) {
				colAveObj.label.text = "";
				colAveObj.total.text = "/"+numRows;
			} else if (myType == PERCENT) {
				colAveObj.label.text = "("+String(Math.round(tot/topTotals*100/numRows))+")";
				colAveObj.total.text = "/100";
			} else {
				colAveObj.label.text = "("+String(Math.round(tot/numRows))+")";
				colAveObj.total.text = "/" + String(Math.round(topTotals));
			}
		}
		
		private function worthDrag(e:Event):void {
			// update max in selected column
			var numPress:NumberPresserFlex;
			var r:Number; var c:Number;
			for (var i:uint=0; i<numFillCols*numFillRows; i++) {
				numPress = NumberPresserFlex(chartObj.tiler.getElementAt(i));
				r = Math.floor(i/numFillCols);
				c = Math.floor(i%numFillCols);
				if (c == e.target.num) {
					numPress.maxNumber = e.target.value;
				}
			}			
			colWorthObj.array = colWorthArray;			
			updateChart();			
		}			
		
		private function worthChange(e:Event):void {
			trace ("--------------"+e.target.num);	
			// update max in selected column
			var numPress:NumberPresserFlex;
			var r:Number; var c:Number;
			for (var i:uint=0; i<numFillCols*numFillRows; i++) {
				numPress = NumberPresserFlex(chartObj.tiler.getElementAt(i));
				r = Math.floor(i/numFillCols);
				c = Math.floor(i%numFillCols);
				if (c == e.target.num) {
					numPress.maxNumber = e.target.value;
				}
			}			
			colWorthObj.array = colWorthArray;			
			updateChart();
			chartObj.array = chartArray;
			// send back worth change notification 
			dispatchEvent(new Event(ChartFlex.WORTH_CHANGE));
		}	
		
		private function chartChange(e:Event):void {
			trace ("--------------"+e.target.value);	
			// calculate and update totals in selected row only and ave
			// send back chart
			chartObj.array = chartArray;
			updateChart();
			dispatchEvent(new Event(ChartFlex.CHART_CHANGE));
		}		
		
		private function setSelection():void {
			// requires currentRow and currentCol to be set
			var numPress:NumberPresserFlex;
			var r:Number; var c:Number;
			for (var i:uint=0; i<numFillCols*numFillRows; i++) {
				numPress = NumberPresserFlex(chartObj.tiler.getElementAt(i));
				r = Math.floor(i/numFillCols);
				c = Math.floor(i%numFillCols);
				if (r == currentRow || c == currentCol) {
					numPress.styleName = chartObj.styleSelected;
				} else {
					numPress.styleName = chartObj.styleName;
				}							
			}		
		}
	
		
		public function setColSelect(n:Number):void {
			currentCol = n;
			setSelection();
		}
		public function setRowSelect(n:Number):void {
			currentRow = n;
			setSelection();
		}
		
		public function set colWorthArray(a:Array):void {
			// collect array for worth variables eg [1,2,3] and remake col worth
			colWorthObj.array = a;
			updateChart();
			chartObj.array = chartArray; // remove this if you want hungry chart numbers
		}
		public function set rowWorthArray(a:Array):void {
			// collect array for worth variables eg [1,2,3] and remake row worth
		}
		public function set chartArray(a:Array):void {
			// collect multidimensional chart array eg [[1,2,3],[4,5,6]] and remake chart and totals
			chartObj.array = a;
			numRows = chartObj.array.length;			
			numCols = chartObj.array[0].length;
			if (numRows > numFillRows || numCols > numFillCols) {setChart();}			
			updateChart();
		}
		
		public function get colWorthArray():Array {
			// send array for worth variables eg [1,2,3]
			var numPress:NumberPresserFlex;
			// chart top
			var array:Array = [];
			for (var i:uint=0; i<numFillCols; i++) {				
				if (i < numCols) {	
					numPress = NumberPresserFlex(colWorthObj.tiler.getElementAt(i));
					array.push(numPress.value);
				}
			}	
			return array;
		}
		public function get rowWorthArray():Array {
			// send array for worth variables eg [1,2,3] 
			// currently disabled
			return [];
		}
		public function get chartArray():Array {
			// send multidimensional chart array eg [[1,2,3],[4,5,6]] 
			// loop through grid and return nested array			
			var numPress:NumberPresserFlex;							
			var r:Number; var c:Number;
			var array:Array = [];
			for (var i:uint=0; i<numFillCols*numFillRows; i++) {
				r = Math.floor(i/numFillCols);
				c = Math.floor(i%numFillCols);
				numPress = NumberPresserFlex(chartObj.tiler.getElementAt(i));
				if (r < numRows && c < numCols) {
					if (!array[r]) {array[r] = [];}
					array[r][c] = numPress.value;				
				}
			}			
			return array;
		}
		
		public function get type():String {			
			return myType;
		}
		public function set type(a:String):void {
			if (a == RANK || a == NUMBER || a == PERCENT) {
				myType = a;
				updateChart();
			}
		}
		public function dispose():void {
			// did not dispose of all - just got part way through and realized did not need
			var numPress:NumberPresserFlex;		
			for (var i:uint=0; i<numFillCols*numFillRows; i++) {				
				numPress = NumberPresserFlex(chartObj.tiler.getElementAt(i));
				chartObj.tiler.removeElement();
				numPress.dispose();
			}
		}
		
	}
}