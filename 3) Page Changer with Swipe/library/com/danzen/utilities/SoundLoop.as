package com.danzen.utilities {
	
	// a simple class to loop sound by inventor Dan Zen http://www.danzen.com
	// 0 for repeat loops forever
	// 1 for repeat plays once (not quite right but whatever)
	
	// make sure that the com folder is in your class path
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	public class SoundLoop {
		
		public var loopChannel:SoundChannel;
		public var loopSound:Sound;
		public var repeatCount:uint;
		private var count:Number = 0;		
		
		public function SoundLoop(theURL:String, theRepeatCount:uint=0) {
			
			trace ("hi from SoundLoop and Dan Zen")
			
			repeatCount = theRepeatCount;
			loopSound = new Sound(new URLRequest(theURL));
			loopChannel = loopSound.play();
			loopChannel.addEventListener(Event.SOUND_COMPLETE, replay);
		}
		
		private function replay(e:Event) {
			if (repeatCount != 0) {
				count++;
				if (count >= repeatCount) {
					dispose();
				}
			}
			loopChannel.removeEventListener(Event.SOUND_COMPLETE, replay);
			loopChannel = loopSound.play();
			loopChannel.addEventListener(Event.SOUND_COMPLETE, replay);			
		}
		
		public function dispose() {
			loopChannel.stop();
			loopChannel.removeEventListener(Event.SOUND_COMPLETE, replay);
		}
	}
}
			