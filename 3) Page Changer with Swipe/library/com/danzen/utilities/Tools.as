
package com.danzen.utilities {
	
	
	public class Tools {

		public static function randomBetween(a:Number=1,b:Number=0) {
			return Math.random()*Math.abs(a-b) + Math.min(a,b);						
		}
		
		public static function randomArrayFrom(a:Array,n:Number=-1) {
			// returns an array subset of unique random values from a
			// if n is less than or equal to a.length or null
			// else returns an array of length n of random non-unique values from a
			if (n==-1) {n=a.length;}
			var temp:Array = [];
			for (var i:uint=0; i<n; i++) {
				if (n > a.length) {
					temp.push(a[Math.floor(Math.random()*a.length)]);
				} else {
					temp.push(a.splice(Math.floor(Math.random()*a.length),1));
				}
			}
			return temp;
		}		
		
		public static function getRandomNodes(nodes:XMLList, n:Number) {
			
			if (n > nodes.length()) {n = nodes.length();}
			
			// could use copy XML and then replace() and normalize()
			// as splice - but this is just as easy...
			var temp = [];
			for (var i:uint=0; i<nodes.length(); i++) {temp.push(i);}
			temp = Tools.randomArrayFrom(temp, n);
									
			var myXML:XML = <node/>;
			for (i=0; i<n; i++) {
				myXML.appendChild(nodes[temp[i]]);				
			}			
			return myXML.*;
			
		}
		
		public static function test() {
			var xml:XML = <node/>;
			xml.addSingleNode = <foo/>;
			xml.addTextNode = "bar";
			xml.appendList = (<firstListNode/> + <secondListNode/>);
			xml.appendDynamicNode = <node>{Math.random()}</node>;
			xml.appendChild(<childNode/>);
			xml.prependChild(<firstChild/>);
			xml.cdata = <![CDATA[ CData content ]]>;
			xml.firstChild.setChildren("some text");
			xml.replace(xml.*.length(), "some more text");
			
			trace(xml.toXMLString());
			/*
<node>
  <firstChild>some text</firstChild>
  <foo/>
  <addTextNode>bar</addTextNode>
  <firstListNode/>
  <secondListNode/>
  <node>0.8503989921882749</node>
  <childNode/>
  <![CDATA[ CData content ]]>
  some more text
</node>
*/
		}
		
	}
}