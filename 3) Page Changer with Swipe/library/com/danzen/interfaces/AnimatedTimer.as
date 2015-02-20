package com.danzen.interfaces {
	
	import flash.display.TextField;
	
	public class AnimatedTimer {
		
		private var myText:TextField

		public function AnimatedTimer(theText:TextField) {
			// constructor code
			trace ("hi from AnimatedTimer");
			myText = theText;
			myText.text = "123";
			
		}

	}
	
}
