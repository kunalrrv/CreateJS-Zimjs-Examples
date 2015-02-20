package com.danzen.renderers{

	import fl.controls.listClasses.CellRenderer;
	import flash.text.TextFormat;
	
	public class CenterColumnRenderer extends CellRenderer {
		
		private var tf:TextFormat;
		
		public function CenterColumnRenderer() {
			tf = new TextFormat();
			tf.align = "center";			
			tf.size = 22;
		}

		override protected function drawLayout():void {
			textField.width = this.width;
			textField.setTextFormat(tf);
			super.drawLayout();
		}
	}

}