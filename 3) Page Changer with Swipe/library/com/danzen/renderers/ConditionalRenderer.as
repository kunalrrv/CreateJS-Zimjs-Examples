package com.danzen.renderers{

	import fl.controls.listClasses.CellRenderer;


	public class ConditionalRenderer extends CellRenderer {

		public function ConditionalRenderer() {
			textField.wordWrap = true;
			textField.autoSize = "left";
		}
		override public function set data(value:Object):void {
			if (value != null) {
				super.data = value;
				if (value[DataGridListData(listData).dataField] < 10) {
					setStyle("color", 0xFF0000);
				}
				else {
					setStyle("color", 0x000000);
				}
			}
		}
	}
}