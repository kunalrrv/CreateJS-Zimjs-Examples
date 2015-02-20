package com.danzen.flex {
	import mx.core.UIComponent;
	import flash.display.Sprite;
	public class AddSprite extends UIComponent {
		public function AddSprite(s:Sprite) {
			super ();			
			explicitHeight = s.height;
			explicitWidth = s.width;			
			addChild (s);
		}
	}
}