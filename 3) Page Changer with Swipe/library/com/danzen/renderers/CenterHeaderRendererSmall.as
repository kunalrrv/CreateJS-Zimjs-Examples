package com.danzen.renderers{

	import fl.controls.dataGridClasses.HeaderRenderer;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class CenterHeaderRendererSmall extends HeaderRenderer {
		private var tf:TextFormat;

		public function CenterHeaderRendererSmall() {
			init();
		}

		private function init():void {
			tf = new TextFormat();
			tf.align = TextFormatAlign.CENTER;
			tf.size = 14;
			tf.bold = true;
		}

		override protected function drawLayout():void {
			super.drawLayout();
			textField.x = 0;
			textField.y = 4;
			textField.width = this.width;
			textField.setTextFormat(tf);
		}
	}
}