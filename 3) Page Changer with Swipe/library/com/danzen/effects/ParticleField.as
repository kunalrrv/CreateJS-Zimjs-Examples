package com.danzen.effects {
	
	import flash.display.Sprite;
	import flash.events.*
	import flash.display.MovieClip;
	
	public class ParticleField extends Sprite {

		private var myParticles:Array;
		private var myW:Number;
		private var myH:Number;
		private var myShowNumber:Number;
		private var mySpeed:Number;
				
		private var panels:Array = [new Sprite(), new Sprite(), new Sprite()];
		private var totalOdds:Number=0;
		// theParticles = [[Good,9], [ReallyGood,1]]
	
		public function ParticleField (theParticles:Array, theWidth:Number, theHeight:Number, theShowNumber:Number=10, theSpeed:Number=10) {

			trace ("hi from ParticleField");
			myParticles = theParticles;			
			myW = theWidth;
			myH = theHeight;
			myShowNumber = theShowNumber;
			mySpeed = theSpeed;	
			
			for (var i:uint=0; i<myParticles.length; i++) {
				totalOdds += myParticles[i][1];
			}
			
			var startY:Number = -myH;			
			for (i=0; i<panels.length; i++) {
				addChild(panels[i]);
				panels[i].y = startY + myH*i;
				populatePanel(panels[i]);				
			}				

			addEventListener(Event.ENTER_FRAME, animate);

		}
		
		private function populatePanel(panel:Sprite):void {			
			var particle:MovieClip;
			var rand:Number;
			var j:uint;
			var myClass:Class;
			var points:Number;
			var total:Number;
			for (var i:uint=0; i<myShowNumber; i++) {
				rand = Math.random()*totalOdds;
				total = 0;
				for (j=0; j<myParticles.length; j++) {
					total += myParticles[j][1];
					if (rand < total) {
						myClass = myParticles[j][0];
						points = myParticles[j][2];
						break;
					}
				}				
				particle = new (myClass)();
				particle.points = points;
				panel.addChild(particle);
				particle.x = Math.random()*myW;
				particle.y = Math.random()*myH;
				
			}
		}
		
		private function animate(e:Event):void {
			var panel:Sprite;
			var j:Number;
			var total:Number;
			var particle:MovieClip;
			for (var i:uint=0; i<panels.length; i++) {
				panel = Sprite(panels[i]);
				panel.y += mySpeed;
				if (mySpeed > 0) {
					if (panel.y > myH) {
						panel.y -= myH*2;
						total = panel.numChildren;
						for (j=total-1; j>=0; j--) {						
							particle = MovieClip(panel.getChildAt(j));
							panel.removeChild(particle);
							particle = null;						
						}
						populatePanel(panel);					
					}
				} else {
					if (panel.y < -myH) {
						panel.y += myH*2;
						total = panel.numChildren;
						for (j=total-1; j>=0; j--) {						
							particle = MovieClip(panel.getChildAt(j));
							panel.removeChild(particle);
							particle = null;						
						}
						populatePanel(panel);					
					}
				}
			}	
		}
		
		public function hitObject(clip:Sprite):Array {
			var panel:Sprite;
			var particle:MovieClip;
			var i:uint;  var j:Number; 
			var hitList:Array = [];
			for (i=0; i<panels.length; i++) {
				panel = Sprite(panels[i]);
				for (j=0; j<panel.numChildren; j++) {
					particle = MovieClip(panel.getChildAt(j));
					if (particle.hitTestObject(clip)) {
						hitList.push(particle);
					}
				}
			}
			return hitList;
		}
		
		public function remove(clip:Sprite):void {
			clip.parent.removeChild(clip);
		}
		
		public function dispose():void {
			//avoid double disposing
			if (!hasEventListener(Event.ENTER_FRAME)) {return;}
			removeEventListener(Event.ENTER_FRAME, animate);
			var panel:Sprite;
			var total:Number;
			var j:Number;
			var particle:MovieClip;
			for (var i:uint = 0; i<3; i++) {
				panel = panels[i];
				total = panel.numChildren;
				for (j=total-1; j>=0; j--) {						
					particle = MovieClip(panel.getChildAt(j));
					panel.removeChild(particle);
					particle = null;						
				}
				removeChild(panel);
				panel = null;
			}
		}
		
		public function set speed(s:Number):void {
			mySpeed = s;
		}
		
		public function get speed():Number {
			return mySpeed;
		}
		
		

	}
	
}
