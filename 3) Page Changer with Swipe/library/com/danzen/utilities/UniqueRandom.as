package com.danzen.utilities {
	
	import com.danzen.utilities.DynamicObject;

	public class UniqueRandom {
		
		private var a:Array;
		private var o:Array;
		
		public function UniqueRandom(theA:Array) {
			a = DynamicObject.copy(theA);
			o = DynamicObject.copy(a);
		}
		
		public function removeElement(e:*):void { // removes element from working list and master list	
			for (var i:uint=0; i<o.length; i++) {
				if (DynamicObject.compare(o[i],e)) {					
					o.splice(i,1);					
					break;
				}
			}
			for (i=0; i<a.length; i++) {
				if (DynamicObject.compare(a[i],e)) {					
					a.splice(i,1);					
					break;
				}
			}			
		}
		
		public function removeElementTemp(e:*):void { // removes element from working list but not master list
			for (var i:uint=0; i<a.length; i++) {
				if (DynamicObject.compare(a[i],e)) {					
					a.splice(i,1);					
					break;
				}
			}			
		}
		
		public function addElement(e:*):void {
			a.push(e);
			o.push(e);
		}
		
		public function getArray(n:Number):Array {
			if (!o) {return [];}
			if (o.length <= 0) {return [];}
			if (o.length < n) {return o;}
			if (a.length < n) {
				a = DynamicObject.copy(o);
				n = a.length;
			}
			var s:Array = [];
			for (var i:uint=0; i<n; i++) {				
				s.push(a.splice(Math.floor(Math.random()*a.length),1)[0]);
			}
			return s;		
		}
		
		public function getElement():* {
			if (!o) {return null;}
			if (o.length <= 0) {return null;}
			if (a.length == 0) {
				a = DynamicObject.copy(o);
			}				
			return a.splice(Math.floor(Math.random()*a.length),1)[0];
		}		
	}
}