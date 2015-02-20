package com.danzen.renderers{

	import fl.controls.listClasses.CellRenderer;
	

	public class WrapColumnRenderer extends CellRenderer {

		public function WrapColumnRenderer() {
			textField.wordWrap = true;
			textField.autoSize = "left";
		}
		override protected function drawLayout():void {
			textField.width = this.width;
			super.drawLayout();
		}
	}

}