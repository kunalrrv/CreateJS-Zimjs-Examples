package com.danzen.effects
{
	import com.danzen.frameworks.Easy;
	import com.danzen.utilities.Colors;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	
	public class TartanSpec extends Sprite
	{
		public var colorNames:Array = [];
		
		public function TartanSpec(tartanData:Array, tartan:Bitmap)
		{
			var colors:Array = tartanData[0];
			var widths:Array = tartanData[1];
			
			addChild(Easy.rectangle(600, 500, 0xffffff));
			addChild(tartan);
			tartan.alpha = .2;
			
			var spec:Spec = new Spec();
			addChild(spec);
			
			var ct:ColorTransform = new ColorTransform();	
			var counter:Number = 0;
			var row:MovieClip;
			var j:uint;
			var cn:String;
			for (var i:uint = 0; i < colors.length / 2; i++) {				
				ct.color = colors[i];
				row = spec["row"+counter];
				row.s.inner.transform.colorTransform = ct;
				row.s.inner.alpha = .8;	
				cn = Colors.getName(colors[i]);
				colorNames.push(cn);
				row.n.text = cn;
				row.c.text = Colors.getHexFromNumber(colors[i]);
				for (j=0; j<widths.length; j++) {
					row["t"+j].text = String(widths[widths.length-1-j][i]);
				}
				
				counter++;
				ct.color = colors[colors.length-1-i];	
				row = spec["row"+counter];
				row.s.inner.transform.colorTransform = ct;
				row.s.inner.alpha = .8;	
				cn = Colors.getName(colors[colors.length-1-i]);
				colorNames.push(cn);
				row.n.text = cn;
				row.c.text = Colors.getHexFromNumber(colors[colors.length-1-i]);
				for (j=0; j<widths.length; j++) {
					row["t"+j].text = String(widths[widths.length-1-j][colors.length-1-i]);
				}
				counter++;
			}
			
		}
	}
}