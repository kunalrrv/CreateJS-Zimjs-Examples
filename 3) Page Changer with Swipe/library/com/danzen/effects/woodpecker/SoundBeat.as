﻿
package com.danzen.effects.woodpecker {
	
	import flash.display.Sprite;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	import flash.events.*
	
	import flash.media.Microphone;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	
	class SoundBeat extends Sprite {		
		
		private var numBumps:Number;  // how many array elements to return
		private var isSpectrum:Boolean;  // true for frequency else wave		
		private var myAmplitude:Number; // desired amplitude - will be approximate		
		private var myThreshhold:Number; // threshhold cutoff (make larger than amplitude)
		private var isNormalize:Boolean; // dynamically adjust myScale to approach myAmplitude
		private var beatArray:Array = [];  // array of bumps that gets dispatched
		private var ba:ByteArray = new ByteArray(); // internal holder for analysis
		
		private var mySensitivity:Number; // how many onEnterFrames we normalize on
		private var normalizeCount:Number = 0;  // internal count for normalization modulus
		private var myScale:Number; // internal scale for normalization
		private var myMic:Boolean; // do we have a mic
		
		private var micBytes:ByteArray; // byteArray and sound objects to hold mic sound
		private var micSound:Sound;
		private var myGain:Number;
		private var mic:Microphone;
		
		public function SoundBeat(theBumps=8,
								  theSpectrum=true,
								  theAmplitude=200,
								  theThreshhold=10000,
								  theNormalize=true,
								  theNormalizeSensitivity=5,
								  theMic=false,
								  theGain=50
								  ) {
						
			numBumps = theBumps+1;
			isSpectrum = theSpectrum;
			myAmplitude = theAmplitude;
			myScale = theAmplitude;			
			isNormalize = theNormalize;
			mySensitivity = theNormalizeSensitivity;
			myThreshhold = theThreshhold;		
			myMic = theMic;	
			myGain = theGain;
			
			if (myMic) {
				mic = Microphone.getMicrophone();				
				if (mic) {
					mic.setLoopBack(false);
					mic.gain = myGain;
					mic.rate = 44;				
					mic.addEventListener(SampleDataEvent.SAMPLE_DATA, sampleMic);
					micSound = new Sound();
					micSound.addEventListener(SampleDataEvent.SAMPLE_DATA, writeMicToSound);
					//SoundMixer.soundTransform = new SoundTransform(0);
				} else {
					trace ("no Mic detected");
				}
			}
			
			
			startProcess();
		}
		
		private function sampleMic(e:SampleDataEvent):void {
            micBytes = e.data;	
			micSound.play();
        }
 
		private function writeMicToSound(e:SampleDataEvent):void {
			for (var i:int = 0; i < 8192 && micBytes.bytesAvailable > 0; i++) {
				var sample:Number = micBytes.readFloat();
				e.data.writeFloat(sample);
				e.data.writeFloat(sample);
			}
		}		
		
		
		public function stopProcess() {
			removeEventListener(Event.ENTER_FRAME, processSound);
		}
		
		public function startProcess() {
			stopProcess();
			addEventListener(Event.ENTER_FRAME, processSound);			
		}
		
		public function getAmplitude() {
			return myAmplitude;
		}
		
		public function setGain(g:Number=50):void {
           	mic.gain = g;
        }
		
		public function setSpectrum(s:Boolean) {
			isSpectrum = s;
		}
		
		private function processSound(e:Event) {
			
			
			SoundMixer.computeSpectrum(ba,isSpectrum,0);
											
			var w:uint = Math.floor(256  / numBumps);
			var t:Number = 0;
			var temp:Array = [];			
			for (var i=0; i<256; i++) {
				t += ba.readFloat();
				if (i%w == 0) {					
					temp[i] = t / w;
					t = 0;
				}
			}
			var temp2:Array = [];
			for (i=0; i<256; i++) {
				t += ba.readFloat();
				if (i%w == 0) {					
					if (isSpectrum) {
						// times fudge factor to bring up high-end frequencies a little
						temp2.push((temp[i] + t/w) / 2 * (Math.pow(i, 1.4) + 150) / 200);
					} else {
						temp2.push((temp[i] + t/w) / 2);							
					}					
					t = 0;					
				}
			}						
			
			if (isNormalize) {
				normalizeCount++;				
				if (normalizeCount % mySensitivity == 0) {
					var nCheck:Boolean = false;
					for (i=0; i< beatArray.length; i++) {
						if (beatArray[i] > myAmplitude) {							
							myScale -= myAmplitude / 50;
							nCheck = true;
							break;
						}
					}
					if (!nCheck) {
						myScale += myAmplitude / 50;
					}
				}
			}
			
			beatArray = [];
			
			for (i=1; i<numBumps; i++) {
				beatArray.push(-Math.max(-Math.round(Math.abs(temp2[i]*myScale)*1000)/1000, -myThreshhold));
			}		
			
			dispatchEvent(new SoundBeatEvent(SoundBeatEvent.PROCESS_SOUND,beatArray));
			
		}
		
		public function dispose() {
			removeEventListener(Event.ENTER_FRAME, processSound);
		}				
	}	
}