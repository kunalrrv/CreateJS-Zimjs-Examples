package com.danzen.renderers{

	import fl.controls.dataGridClasses.HeaderRenderer;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class CenterHeaderRenderer extends HeaderRenderer {
		private var tf:TextFormat;

		public function CenterHeaderRenderer() {
			init();
		}

		private function init():void {
			tf = new TextFormat();
			tf.align = TextFormatAlign.CENTER;
			tf.bold = true;
		}

		override protected function drawLayout():void {
			super.drawLayout();
			textField.x = 0;
			textField.width = this.width;
			textField.setTextFormat(tf);
		}
	}
}