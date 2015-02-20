package com.danzen.interfaces {
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	
	import com.adobe.serialization.json.JSON;
	import com.adobe.utils.ArrayUtil;
	import org.papervision3d.core.render.sort.NullSorter;

	// NodeGlobe - by inventor Dan Zen - 2011
	// stores a hierarchy in a circle for interface usage
	
	// new NodeGlobe(data:Object, highlightColor:Number=0xff0000, spin:String="right");
	// pass in XML or a multidimensional Object of Objects
	// XML node names do not matter but must each have a unique id parameter
	// <nodes id="1234"><nodes id="3456"><nodes id="1111" /></nodes></nodes>
	// Objects must have a unique property
	// {1234:{3456:{1111:null}}}
	// highlightColor is also a public property you can set at any time
	// spin is also a public property - can have left, right top, bottom and none values
	// this spins the globe when a node is clicked
	
	// can update the data with the setData(data:Object);
	// can highlight specific nodes with highlightNodes(nodes:Array, color:Number);
	// can highlight branches with highlightBranches(nodes:Array, color:Number);
	// if you want only one branch highlightBranches(["3456"], 0xcc0000);
	// branches will highlight from that node on
	// clear highlighting by passing empty array
	
	// can capture all mouse events
	// each node has an id property so you can ask for eventObject.target.id

	public class NodeGlobe extends MovieClip {
		
		public const SPIN_LEFT:String = "left";
		public const SPIN_RIGHT:String = "right";
		public const SPIN_TOP:String = "top";
		public const SPIN_BOTTOM:String = "bottom";
		public const SPIN_NONE:String = "none";
		
		public var highlightColor:Number;
		public var spin:String;
		public var lines:MovieClip;
		public var dots:MovieClip;
			
		private var data:Object;		
		private var diameter:Number;
		private var nodeDiameter:Number;
		
		private var nodeInfo:Object = {};
		private var tempData:Object;
		private var sectors:Array;
		private var totalEndNodeCount:int = 0;
		private var sectorEndNodeCount:int = 0;
		private var endNodes:Array;
		private var maxLevel:int;
		
		private var nodeFillColor:Number = 0xffaaff;
		private var nodeLineColor:Number = 0xaa6666;
				
		private var minSpacingProportion:Number = 3; // times the node Diameter
		private var minRingSpacing:Number = 50; // pixels so max #rings = Math.floor(diameter/minRingSpacing)
		private var spacing:Number;
		
		public function NodeGlobe(theData:Object=null, theDiameter:Number=200, theNodeDiameter:Number=16, theHighlightColor:Number=0xff0000, theSpin:String=SPIN_RIGHT) {
			
			trace ("hi from NodeGlobe");
			
			diameter = theDiameter;
			nodeDiameter = theNodeDiameter;
			highlightColor = theHighlightColor;
			spin = theSpin;
			
			spacing = Math.asin(minSpacingProportion*nodeDiameter/(diameter/2)) * 180 / Math.PI;
						
			lines = new MovieClip();				
			lines.graphics.lineStyle(2,0xffffff,1);
			addChild(lines);	
			//lines.blendMode = "subtract";
			
			dots = new MovieClip();
			addChild(dots);
			dots.graphics.beginFill(nodeFillColor, 1);
			dots.graphics.lineStyle(3,nodeLineColor,1);
			dots.graphics.drawCircle(0,0,nodeDiameter);
			
			
			setData(theData);					
		}		
		
		public function setData(theData:Object):void {			
			if (theData is XML) {				
				processXML(XML(theData));	
				processObject(tempData);
			} else {
				processObject(theData);
			}						
		}
		
		public function highlightNodes(a:Array, c:Number=0x0000cc):void {
			
		}
		
		public function highlightBranches(a:Array, c:Number=0x00cc00):void {
			
		}
		
		private function processXML(d:XML):void {			
			tempData = {};
			recursiveXML(d,tempData);
		}
		
		private function processObject(o:Object):void {
			for (var id:String in o) {
				break;
			}			
			data = {}; 
			sectors = [];
			recursiveObject(id, o[id], "");
			
			// ref: sectors[i] = [id, sectorEndNodeCount, endNodes.slice(0), maxLevel]			
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
				makeSector(sectors[i], sentWeight);
				lastSentWeight = sentWeight;
				lastWeight = weight;								
			}
		}
		
		private function makeSector(s:Array, w:Number) {
			trace ("sector " + s[0] + " sectorEndNodeCount=" +s[1]+ " end nodes=" + s[2] + " maxLevel=" + s[3] + " w=" + w);			
			var id:String = s[0];
			var endNodes:Array = s[2]		
			var levels:Number = s[3];
			var angle:Number = w * 360;	
			trace ("angle = " + angle)
			var n:MovieClip;
			var a:Number;
			endNodes.sort();
			for (var i:uint=0; i<endNodes.length; i++) {
				endNodes[i] = endNodes[i].split(/__/,2)[1];
				trace (endNodes[i]);
				id = endNodes[i];
				a = angle + (i*spacing-(endNodes.length-1)*spacing/2);
				n = makeNode(id, a, levels, levels);				
			}			
					
			var operate:Array = [];
			var lastParent:String;
			var firstTime:Boolean;
			var minAngle:Number;
			var maxAngle:Number;
			var currentClip:MovieClip;
			var parentClip:MovieClip;
			var nn:uint;
			// ref: nodeInfo[id] = [level,parentID,o]						
			for (var lev:int=levels; lev >= 1; lev--) {				
				firstTime = true;
				for (var nod:uint=0; nod < endNodes.length; nod++) {
					if (nodeInfo[endNodes[nod]][0] != lev) {continue;}
					if (firstTime){
						lastParent = nodeInfo[endNodes[nod]][1];
						firstTime = false;
					}
					if (nodeInfo[endNodes[nod]][1] != lastParent) {
						//trace ("operating on : " + operate);			
						minAngle=3333;
						maxAngle=-3333;
						for (nn=0; nn<operate.length; nn++) {
							currentClip = nodeInfo[operate[nn]][4]
							minAngle = Math.min(minAngle, currentClip.angle);
							maxAngle = Math.max(maxAngle, currentClip.angle);
						}
						
						n = makeNode(lastParent, (maxAngle+minAngle)/2, lev-1, levels);
						
						endNodes.splice(nod,1,lastParent);
						operate = [];
						lastParent = nodeInfo[endNodes[nod]][1];
					} else {
						operate.push(endNodes[nod]);
					}
				}
				if (operate.length > 0) {
					//trace ("operating on : " + operate);
					minAngle=3333;
					maxAngle=-3333;
					for (nn=0; nn<operate.length; nn++) {
						currentClip = nodeInfo[operate[nn]][4]
						minAngle = Math.min(minAngle, currentClip.angle);
						maxAngle = Math.max(maxAngle, currentClip.angle);
					}
										
					n = makeNode(lastParent, (maxAngle+minAngle)/2, lev-1, levels);
					
					for (nn=0; nn<operate.length; nn++) {
						currentClip = nodeInfo[operate[nn]][4];
						parentClip = nodeInfo[lastParent][4];
						lines.graphics.moveTo(currentClip.x, currentClip.y);
						lines.graphics.lineTo(parentClip.x, parentClip.y);
					}
					
					endNodes.splice(nod,1,lastParent);
					operate = [];
					lastParent = nodeInfo[endNodes[nod]][1];
				}
			}				
			trace ("done sector");		
		}
		
		private function makeNode(id:String, angle:Number, level:Number, levels:Number):MovieClip {
			var node:MovieClip = new MovieClip();
			node.id = id;
			nodeInfo[id][4] = node;
			node.angle = angle;
			node.graphics.beginFill(nodeFillColor, 1);
			node.graphics.lineStyle(3,nodeLineColor,1);
			node.graphics.drawCircle(0,0,nodeDiameter/2);
			var d:Number = diameter * level / levels / 2;		
			
			node.x = Math.sin(angle * Math.PI / 180) * d;
			node.y = Math.cos(angle * Math.PI / 180) * d;
			
			dots.addChild(node);			
			return node;
		}
		
		// ref: data = {"0":{"1aa":{"2bb":{},"2aa":{},"2cc":{"3bb":{},"3aa":{}}},"1bb":{"2ff":{},"2ee":{},"2dd":{}}}};
					
		public function recursiveObject(id:String, o:Object, parentID:String, level:int=0):void {			
			if (level == 1) {
				maxLevel = 0;
				endNodes = [];
				sectorEndNodeCount=0;
			}
			var count:Number = 0;
			for (var a:String in o) {
				count++;
			}
			nodeInfo[id] = [level,parentID,o];
			if (count > 0) {
				//trace("level " + level + " holdernode = " + id);				
				for (var i:String in o){
					recursiveObject(i, o[i], id, level+1);
				}
				//trace("end " + id);
				if (level == 1) {
					//trace ("sector num = " + sectorEndNodeCount);
					sectors.push([id, sectorEndNodeCount, endNodes.slice(0), maxLevel]);
				}
			} else {					
			  //trace( "level " + level + " leafnode = " + id);			
			  sectorEndNodeCount++
			  totalEndNodeCount++;			  
			  endNodes.push(level+"__"+id);
			}
			maxLevel = Math.max(maxLevel, level);
			return;
		}				
				
		public function recursiveXML(xml:XML, obj:Object, level:int=0):void {
			var xmlList:XMLList = xml.children();						
			if (level == 1) {
				//sectorEndNodeCount = 0;
			}
			if (xmlList.length() > 0) {
				//trace("level " + level + " holdernode = " + xml.@id);
				obj[xml.@id] = {};
				for each (var i:XML in xmlList){
					recursiveXML(i,obj[xml.@id],level+1);
				}
				//trace("</"+xml.@id+">");
				if (level == 1) {
					//trace ("sector num = " + sectorEndNodeCount);
				}
			} else {					
			 	// trace( "level " + level + " leafnode = " + xml.@id);
			  	obj[xml.@id] = {};
			 	// totalEndNodeCount++;
				// sectorEndNodeCount++;
			}
			return;
		}		
	}
}
