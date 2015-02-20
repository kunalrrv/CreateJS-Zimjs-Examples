package com.danzen.renderers{

	import fl.controls.listClasses.CellRenderer;
	import flash.text.TextFormat;
	
	public class SmallColumnRenderer extends CellRenderer {
		
		private var tf:TextFormat;
		
		public function SmallColumnRenderer() {
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