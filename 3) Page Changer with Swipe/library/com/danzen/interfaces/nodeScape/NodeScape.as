package com.danzen.interfaces.nodeScape {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.filters.*;
	import flash.display.GradientType;
	
	import com.adobe.serialization.json.JSON;
	import com.adobe.utils.ArrayUtil;
	
	import com.greensock.TweenLite;	
	import com.greensock.easing.*

	// NodeScape - by inventor Dan Zen - 2011
	// stores a hierarchy in a circle for interface usage
	
	// new NodeScape(data:XML, highlightColor:Number=0xff0000, selectPosition:String="right");
	// pass in XML and it makes circles for each node	
	// highlightColor is also a public property you can set at any time
	// selectPosition is also a public property - can have left, right top, bottom and none values
	// this spins the globe when a node is clicked
	
	// can update the data with the setData(data:XML);
	// can highlight specific nodes with highlightNodes(nodes:Array, color:Number);
	// can highlight branches with highlightBranches(nodes:Array, color:Number);
	// if you want only one branch highlightBranches(["3456"], 0xcc0000);
	// branches will highlight from that node on
	// clear highlighting by passing empty array
	
	// can capture all mouse events or use the NodeScapeEvent which adds a SPIN_DONE event type
	// each node is a MovieClip with an xml property so ask for eventObject.target.xml
	// then you can get anything you want from your XML node like attributes
	// if you have a link attribute then you can use eventObject.target.xml.@link, etc.
	// if you use the NodeScapeEvent then it is just eventObject.xml that you use
	// you can also get access to the node MovieClip as eventObject.obj

	public class NodeScape extends MovieClip {
		
		public const SELECT_LEFT:String = "left";
		public const SELECT_RIGHT:String = "right";
		public const SELECT_TOP:String = "top";
		public const SELECT_BOTTOM:String = "bottom";
		public const SELECT_NONE:String = "none";
				
		public var highlightColor:Number;
		public var selectPosition:String;
		public var lines:MovieClip;
		public var dots:MovieClip;
		public var select:MovieClip;
		public var reorder:Boolean;
		public var spinRate:Number = 70; // degrees per second
						
		private var data:XML;		
		private var diameter:Number;
		private var nodeDiameter:Number;
		private var myNog:Class;
		
		private var nodeInfo:Object = {};
		private var sectors:Array;
		private var totalEndNodeCount:int = 0;
		private var sectorEndNodeCount:int = 0;
		private var endNodes:Array;
		private var maxLevel:int;
		private var totalLevels:int = 0;
		private var nodeCount:Number = 0;
		private var baseID:Number = 1000000;
		private var selectedObject:MovieClip;
		
		private var nodeZeroFillColor:Number = 0xffeeff;
		private var nodeZeroLineColor:Number = 0xbb77bb;
		private var nodeFillColor:Number = 0xffaaff;
		private var nodeLineColor:Number = 0xaa6666;
		private var lineColor:Number = 0xaa6666;
				
		private var minSpacingProportion:Number = 2; // times the node Diameter
		private var maxNodeDiameter:Number = 800;
		private var minRingSpacing:Number = 50; // pixels so max #rings = Math.floor(diameter/minRingSpacing)
		private var spacing:Number;	
		
		private var selectDegrees:Object = {};		
				
		public function NodeScape(theData:XML=null, theDiameter:Number=200, theNodeDiameter:Number=10, theNog:Class=null, theReorder:Boolean=true, theSelectPosition:String=SELECT_RIGHT) {
			
			trace ("hi from NodeScape");
					
			diameter = theDiameter;
			nodeDiameter = Math.min(theNodeDiameter, maxNodeDiameter);
			highlightColor = 0x777777;
			myNog = theNog;
			reorder = theReorder;
			selectPosition = theSelectPosition;			
			
			selectDegrees[SELECT_LEFT]=-90; selectDegrees[SELECT_RIGHT]=90; 
			selectDegrees[SELECT_TOP]=180; selectDegrees[SELECT_BOTTOM]=0;
												
			lines = new MovieClip();				
			lines.graphics.lineStyle(40,lineColor,.5);
			addChild(lines);
			lines.filters = [new GlowFilter(0xffffff,.8,6,6,2,1,false)];
			lines.alpha = .5
			
			dots = new MovieClip();
			addChild(dots);
			// nodeZero is the central node and it gets an extra ring
			dots.graphics.beginFill(nodeZeroFillColor, 1);
			dots.graphics.lineStyle(3,nodeZeroLineColor,1);			
			dots.buttonMode = true;
			dots.filters = [new GlowFilter(0xffffff,.8,20,20,2,1,false)];
			
			//dots.addEventListener(MouseEvent.CLICK, clickGlobe);
			//dots.addEventListener(MouseEvent.ROLL_OVER, rolloverGlobe);
			//dots.addEventListener(MouseEvent.ROLL_OUT, rolloutGlobe);
			
			select = new MovieClip();	
			select.filters = [new GlowFilter(0xffffff,.8,6,6,2,1,false)];
			addChild(select)
						
			setData(theData);					
		}		
		
		// directions vary - translate approach to if node 0 is at top
		private var directionFunctions:Array = [up,left,down,right];
		private var positions:Array = ["top","right","bottom","left"];				
		public function goRight() {
			if (!selectedObject) {	
				goClosest(90);			
			} else {
				directionFunctions[(positions.indexOf(selectPosition)+1)%directionFunctions.length]();		
			}			
		}
		public function goUp() {
			if (!selectedObject) {	
				goClosest(180);			
			} else {
				directionFunctions[(positions.indexOf(selectPosition)+2)%directionFunctions.length]();
			}			
		}
		public function goLeft() {
			if (!selectedObject) {	
				goClosest(270);			
			} else {
				directionFunctions[(positions.indexOf(selectPosition)+3)%directionFunctions.length]();
			}			
		}
		public function goDown() {			
			if (!selectedObject) {	
				goClosest(0);			
			} else {
				directionFunctions[(positions.indexOf(selectPosition))%directionFunctions.length]();
			}
		}
		
		private function left() {
			trace ("left");
			if (selectedObject) {
				// choose the sibling (parent's children) on the left (index-1)
				var currentXML:XML = selectedObject.xml;
				var parentXML:XML = currentXML.parent();
				if (currentXML.childIndex() == 0) {
					if (nodeInfo[selectedObject.id][0] == 1) { // for main sectors, keep spinning
						gotoNode(nodeInfo[currentXML.parent().children()[parentXML.children().length()-1].@ngid][3]);
					}
					return;
				}								
				gotoNode(nodeInfo[currentXML.parent().children()[currentXML.childIndex()-1].@ngid][3]);				
			} 
		}
		private function right() {
			trace ("right");
			if (selectedObject) {
				// choose the sibling (parent's children) on the left (index-1)
				var currentXML:XML = selectedObject.xml;
				var parentXML:XML = currentXML.parent();
				if (currentXML.childIndex() == parentXML.children().length()-1) {
					if (nodeInfo[selectedObject.id][0] == 1) { // for main sectors, keep spinning
						gotoNode(nodeInfo[currentXML.parent().children()[0].@ngid][3]);
					}
					return;
				}
				gotoNode(nodeInfo[currentXML.parent().children()[currentXML.childIndex()+1].@ngid][3]);				
			}		
		}
		private function up() {
			trace ("up");
			if (selectedObject) {
				// we stored the parent node in the node info
				// so get to the parent node's object from its nodeInfo
				gotoNode(nodeInfo[selectedObject.xml.parent().@ngid][3]);
			} 
		}
		private function down() {
			trace ("down");
			if (selectedObject) {
				// choose the "first" child
				var currentXML:XML = selectedObject.xml;
				var children:XMLList = currentXML.elements();
				if (children.length() > 0) {	
					if (selectPosition == SELECT_LEFT || selectPosition == SELECT_BOTTOM) { 
						gotoNode(nodeInfo[children[0].@ngid][3]);
					} else {
						gotoNode(nodeInfo[children[children.length()-1].@ngid][3]);
					}
				}
			} 
		}
		
		private function goClosest(positionAngle:Number) {			
			// go to the left most sector
			// globe may be rotated
			var closest:Number=333333;
			var winner:uint;
			var diff:Number;
			var a:Number;
			for (var i:uint=0; i<sectors.length; i++) {
				a = sectors[i][4]-rotation;
				if (a > 360) {a = a - 360;}
				if (a < 0) {a = 360 + a;}
				diff = Math.abs(positionAngle-a);
				if (diff > 180) {diff = 360-diff;}					
				if (diff < closest) {
					closest = diff;
					winner = i;
				}					
			}			
			gotoNode(nodeInfo[sectors[winner][0]][3]);					
		}
		
		private function clickGlobe(e:MouseEvent) {			
			dispatchEvent(new NodeScapeEvent(NodeScapeEvent.NODE_CLICK, MovieClip(e.target), MovieClip(e.target).xml));
			gotoNode(MovieClip(e.target));
		}
		
		public function gotoNode(clip:MovieClip) {
			
			if (clip.id == baseID) {
				selectedObject = null;
			} else {
				selectedObject = clip;
			}
			if (selectPosition == SELECT_NONE) {
				alignDone(MovieClip(clip));
				return;
			}
			//trace (e.target.angle);
			var a:Number = clip.angle;
			if (isNaN(a)) {a = 360*2;}
			if (a < 0) {a = 360 + a;}
			trace ("a="+a);
			
			var d:Number = a - selectDegrees[selectPosition];
			if (d < 0) {d = 360 + d;}
			if (d-rotation > 180) {d = d-360;}
			
			var dur:Number;
			if (clip.id == baseID) {
				d = rotation+360*2;  // spin twice
				dur = 2;
			} else {
				dur = Math.abs(d-rotation) / spinRate;
			}
			
			if (clip.id == baseID) {
				TweenLite.to(select, 1, {alpha:0, ease:Back.easeIn});
			} else {
				TweenLite.to(select, dur/2, {alpha:0, ease:Back.easeIn});
			}
			if (dur > .5) {
				TweenLite.to(this, dur, {rotation:d, ease:Back.easeInOut, onComplete:alignDone, onCompleteParams:[clip]});			
			} else {
				TweenLite.to(this, dur, {rotation:d, ease:Expo.easeInOut, onComplete:alignDone, onCompleteParams:[clip]});			
			}
		}
				
		private function alignDone(o:MovieClip) {		
			select.graphics.clear();
			dispatchEvent(new NodeScapeEvent(NodeScapeEvent.SPIN_DONE, o, o.xml));
			if (o.id == baseID) {return;}
			select.graphics.lineStyle(2,highlightColor,1);
			//select.graphics.drawRect(o.x,o.y,nodeDiameter);
			select.graphics.drawRect(-nodeDiameter*.9,-nodeDiameter,nodeDiameter*.9*2,nodeDiameter*2);
			select.x = o.x;
			select.y = o.y;
			select.rotation = 90-o.angle;
			TweenLite.to(select, 1, {alpha:1, ease:Back.easeOut});			
		}
		
		public function setData(theData:XML):void {
			data = theData;
			if (reorder) {
				preprocessRecursiveXML(data);
			}
			processXML(data);					
		}
				
		public function highlightNodes(a:Array, c:Number=0x0000cc):void {
			
		}
		
		public function highlightBranches(a:Array, c:Number=0x00cc00):void {
			
		}
		
		public function rolloverGlobe(e:MouseEvent):void {
			dispatchEvent(new NodeScapeEvent(NodeScapeEvent.NODE_ROLLOVER, e.target, e.target.xml));
		}
		
		public function rolloutGlobe(e:MouseEvent):void {
			dispatchEvent(new NodeScapeEvent(NodeScapeEvent.NODE_ROLLOUT, e.target, e.target.xml));
		}		
		
		private function processXML(d:XML):void {
			
			// recursively go through the data and give each node an id and store info in nodeInfo
			// ref: nodeInfo[id] = [level,parentID,o,node]	// node if the node has been made
			
			// also divide the data into sectors (nodes at level 1) storing end node data
			// ref: sectors[i] = [id, sectorEndNodeCount, endNodes.slice(0), maxLevel, angle] // angle added once made
			
			sectors = [];			
			recursiveXML(d,"");	
			
			trace ("Sectorlength="+sectors.length + " totalNodes="+nodeCount);			
			
			nodeDiameter = Math.min(maxNodeDiameter, diameter * Math.PI / (totalEndNodeCount*minSpacingProportion) / 1.2);
			nodeDiameter = Math.min(nodeDiameter, diameter / 2 / totalLevels / 2 );
			dots.graphics.drawCircle(0,0,nodeDiameter);
			spacing = Math.asin(minSpacingProportion*nodeDiameter/(diameter/2)) * 180 / Math.PI;

			
			// some fancy footwork to distribute the sectors based on their end nodes
			// must do this by taking half the previous sector end nodes + half the current
			// wanted the sector to start at 0 so preset the first by technique below
			// by the way, just setting the angle based on individual sector end node count does not work
			
			var weight:Number = sectors[0][1]/totalEndNodeCount;
			var lastWeight:Number = sectors[sectors.length-1][1]/totalEndNodeCount;			
			var sentWeight:Number;
			var lastSentWeight:Number = -(weight+lastWeight)/2;
					
			for (var i:uint=0; i<sectors.length; i++) {						
				if (sectors.length == 2) {
					if (i==0) {
						weight = 0;
						sentWeight = 0;
					} else {
						weight = .5;
						sentWeight = .5;
					}				
				} else {
					weight = sectors[i][1]/totalEndNodeCount;
					sentWeight = lastSentWeight + (weight+lastWeight)/2
				}
				
				// make the sector - most of the work is done here
				// this is the same type of code which would make a branch of XML
				// and all branches the single hierarchy makes
				
				makeSector(sectors[i], sentWeight);
				lastSentWeight = sentWeight;
				lastWeight = weight;								
			}			
			
		}
				
		private function makeSector(s:Array, w:Number) {
			
			// well... let's see...
			// loop through the sectors end nodes and set them around the outside ring
			// makeNode() makes the actual node and positions it based on angles and levels
			
			trace ("sector " + s[0] + " sectorEndNodeCount=" +s[1]+ " end nodes=" + s[2] + " maxLevel=" + s[3] + " w=" + w);			
			var id:String = s[0];
			var endNodes:Array = s[2]		
			var levels:Number = s[3];
			var angle:Number = w * 360;
			var n:MovieClip;
			var a:Number;
			endNodes.sort();
			for (var i:uint=0; i<endNodes.length; i++) {
				id = endNodes[i];
				a = angle + (i*spacing-(endNodes.length-1)*spacing/2);
				n = makeNode(id, nodeInfo[id][2], a, levels, levels);				
			}			
			
			// once the outside ring is set above then work backwards from end nodes to center
			// heirarchy is usually starting with node 0 at the top and 1 level down, 2 levels down, etc.
			// this leads to confusion when terming high levels and low levels
			// high level in terms of height is node 0 but node 0 is numerically the lowest 
			// so... we will stick with high level being node 0 - top level classes in Flash...
			// just to note - that is opposite to low level language and high level language
			// depth is also a problem with hierarchies
			// shallow is usually thought of as the everyday details and as you abstract these you are deep
						
			// loop back through levels from low levels (high level numbers) to 0
			// each time, go through all nodes at this level and process the ones with the same parent
			// this is termed operate below and it is where we add a parent node
			// this parent node is then spliced into the endNodes for processing the next level up
			// in doing so, we add all parent nodes and join them with lines
			// note, sometimes the nodes are operated on due to a change of parent
			// and other times just because the last of the end nodes at that level is reached
			// that is why there are two operating areas - might have refactored to a function
			
			
			var operate:Array = [];
			var lastParent:String;
			var firstTime:Boolean;
			var minAngle:Number;
			var maxAngle:Number;
			var currentClip:MovieClip;
			var parentClip:MovieClip;
			var nn:uint;
			var processedNod:uint;
			var tempParent:String;
			var lastLevel:Number=levels; 
			var pseudoLevel:Number = levels; // compact nodes as outward as possible
			// ref: nodeInfo[id] = [level,parentID,o,node]	// node if the node has been made					
			for (var lev:int=levels; lev >= 1; lev--) {				
				firstTime = true;
				endNodes.sort();
				for (var nod:uint=0; nod < endNodes.length; nod++) {
					if (nodeInfo[endNodes[nod]][0] != lev) {continue;}
					processedNod = nod;
					if (firstTime){
						lastParent = nodeInfo[endNodes[nod]][1];
						firstTime = false;
					} 
					if (nodeInfo[endNodes[nod]][1] != lastParent) {
						
						//operate(nod);
						// trace ("inner operating on : " + operate + " (currentParent = " + nodeInfo[endNodes[nod]][1] + " lastParent = " + lastParent + ")");			
						minAngle=3333;
						maxAngle=-3333;
						for (nn=0; nn<operate.length; nn++) {
							currentClip = nodeInfo[operate[nn]][3]
							minAngle = Math.min(minAngle, currentClip.angle);
							maxAngle = Math.max(maxAngle, currentClip.angle);							
						}
						pseudoLevel = nodeInfo[endNodes[nod]][3].pseudoLevel-1;
						pseudoLevel = lev-1;
						n = makeNode(lastParent, nodeInfo[lastParent][2], (maxAngle+minAngle)/2, pseudoLevel, levels);
						
						for (nn=0; nn<operate.length; nn++) {
							currentClip = nodeInfo[operate[nn]][3];
							parentClip = nodeInfo[lastParent][3];
							lines.graphics.moveTo(currentClip.x, currentClip.y); 						
							lines.graphics.lineTo(parentClip.x, parentClip.y);							
						}						
						
						operate = [];
						operate.push(endNodes[nod]);	
						tempParent = lastParent;
						lastParent = nodeInfo[endNodes[nod]][1];
						endNodes.splice(nod,1,tempParent);								
					} else {
						operate.push(endNodes[nod]);					
					}
					
				}
				if (operate.length > 0) {
					// trace ("operating on : " + operate + " (currentParent = " + nodeInfo[endNodes[processedNod]][1] + " lastParent = " + lastParent + ")");			
					minAngle=3333;
					maxAngle=-3333;
					for (nn=0; nn<operate.length; nn++) {
						currentClip = nodeInfo[operate[nn]][3]
						minAngle = Math.min(minAngle, currentClip.angle);
						maxAngle = Math.max(maxAngle, currentClip.angle);
					}
					
					pseudoLevel = ((nodeInfo[endNodes[processedNod]][3].pseudoLevel-1) + lev)/2;
					pseudoLevel = lev-1;
					n = makeNode(lastParent, nodeInfo[lastParent][2], (maxAngle+minAngle)/2, pseudoLevel, levels);
					
					for (nn=0; nn<operate.length; nn++) {
						currentClip = nodeInfo[operate[nn]][3];
						parentClip = nodeInfo[lastParent][3];
						lines.graphics.moveTo(currentClip.x, currentClip.y); 						
						lines.graphics.lineTo(parentClip.x, parentClip.y);
						
					}
									
					tempParent = lastParent;
					lastParent = nodeInfo[endNodes[processedNod]][1];
					endNodes.splice(nod,1,tempParent);		
					
					operate = [];	
				}
			}
			s.push(Math.round(nodeInfo[endNodes[processedNod]][3].angle));
			trace ("done sector");		
		}
		
		private function operate(n:Number,etc:Object)  {
			
		
		}
		
		private function makeNode(id:String, xml:XML, angle:Number, pseudoLevel:Number, levels:Number):MovieClip {
			var node:MovieClip = new myNog() as MovieClip;
			
			//var node:MovieClip = new MovieClip();
			node.id = id;			
			node.xml = xml
			node.pseudoLevel = pseudoLevel
			nodeInfo[id][3] = node;
			node.angle = angle;		
			node.graphics.beginGradientFill(GradientType.RADIAL, [(id==String(baseID)) ? nodeZeroFillColor : nodeFillColor, (id==String(baseID)) ? nodeZeroFillColor : nodeLineColor], [1,1], [0,nodeDiameter*1.6], null, "pad", "rgb", -.01);
			node.graphics.lineStyle(3,(id==String(baseID)) ? nodeZeroLineColor : nodeLineColor,1);
			node.graphics.drawCircle(0,0,nodeDiameter/2);
			var d:Number = diameter * pseudoLevel / levels / 2;		
			
			node.x = Math.sin(angle * Math.PI / 180) * d;
			node.y = Math.cos(angle * Math.PI / 180) * d;
			
			dots.addChild(node);			
			return node;
		}
							
		private function recursiveXML(xml:XML, parentID:String, level:int=0):void {		
			//trace ("-------"+xml.@id);
			var xmlList:XMLList = xml.children();						
			var id:String = String(baseID + nodeCount);
			xml.@ngid=id;
			nodeCount++;
			
			if (level == 1) {
				maxLevel = 0;
				endNodes = [];
				sectorEndNodeCount=0;
			}
			
			nodeInfo[id] = [level,parentID,xml];
			if (xml.hasComplexContent()) {				
				for each (var i:* in xmlList){					
					if (i.nodeKind() == "element") {						
						recursiveXML(i,id,level+1);
					}
				}								
			} else {						  	
 				sectorEndNodeCount++
			 	totalEndNodeCount++;			  
			 	endNodes.push(id);
			}
				
			maxLevel = Math.max(maxLevel, level);	
			totalLevels = Math.max(totalLevels, level);
			if (level == 1) {				
				sectors.push([id, sectorEndNodeCount, endNodes.slice(0), maxLevel]);
			}
			return;
		}		
		
		private function preprocessRecursiveXML(xml:XML,level:Number=0):void {
			// currently, in recursiveXML() NodeScape recursively goes through the data
			// and stores info about the xml such as sectors and end nodes
			// then it works backwards from end nodes to place parent nodes
			// in doing so it averages angles to the center but this could lead to overlapping lines
			// when there are other-level nodes going to that parent
			// There is probably some sort of iterative / energy balance calculation
			// or we can reduce overlapping lines by placing nodes with less children in the middle			
			// this preprocessRecursiveXML is that cheat to reaorder the nodes 
			// first we store each node along with its number of children
			// (we are chosing to count first level children
			// it could be all descendants - but I think either way still is not perfect)
			// then sort by largest number of children
			// loop through the sorted list and alternatively place nodes at front and back
			// then we replace the originals with the adjusted
			// don't bother doing the first level as that gets sectored proportionaly anyway
						
			if (xml.hasComplexContent()) {
				if (level != 0) {					
					var info:Array = [];
					var kids:XMLList = xml.children();
					if (kids.length() == 0) {return;}
					var grandKids:XMLList;
					for each (var k:* in kids){						
						grandKids = k.elements();						
						info.push({node:k, num:grandKids.length()});
					}
					info.sortOn("num", Array.NUMERIC);
					var newXML:XML = <temp />;
					for (var i:uint=0; i<info.length; i++) {						
						if (i%2==0) {
							newXML.appendChild(info[i].node);
						} else {
							newXML.prependChild(info[i].node);
						}
					}					
					xml.setChildren(newXML.children());										
				}
				var xmlList:XMLList = xml.children();
				for each (var n:* in xmlList){					
					if (n.nodeKind() == "element") {						
						preprocessRecursiveXML(n,level+1);
					}
				}			
			}
			
			return;			
		}
	}
}
