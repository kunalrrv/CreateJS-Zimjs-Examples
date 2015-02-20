
package com.danzen.utilities {
	
	public class Templates {
		
		public function Templates() {
			
		}
		
		public static function makeSprites(sprites:String) {
			
			// declares the sprites and makes them - split trace into proper places
			// sprites is a comma delimited list of the sprites you want to make
			
			//Templates.makeSprites("theClip:InteractiveObject, theMax:Number=1, theMin:Number=0, thePeriod:Number=2")
			
			var temp = sprites.split(",");
			var i:uint;
			trace ("// place in class above constructor\n");
			for (i=0; i<temp.length; i++) {
				trace ("\t\tprivate var " + temp[i] + ":Sprite;");
			}
			trace ("");
			trace ("// place in the constructor or method of class\n");
			for (i=0; i<temp.length; i++) {
				trace ("\t\t\t" + temp[i] + " = new Sprite();");
			}
			
			
		}
		
		public static function makeVariables(variables:String, prefix:String = "my", className:String = "MyClassName"):void {

			// makes declarations, parameters and class assignments
			// output is to the trace window
			
			// write variables as if you are collecting them as parameters
			// including optional default values - must be on one line like so
			// makeVariables('title:String, alpha:Number = .7, name:String = "no name"');
			// prefix of "my" works well if you have a lot of keyword-type variables
			// for no prefix just pass in prefix = ""
			
            variables = variables.replace(/\s*/g, "");			
			var temp = variables.split(",");
			
			var output = "";
			var i:uint;
			var current;
			
			for (i=0; i<temp.length; i++) {
				current = temp[i].split(" ")[0].split("=")[0];
				if (prefix.length > 0) {																
					output += "\t\tprivate var " + prefix + StringPlus.firstUpper(current) + ";\n";
				} else {
					output += "\t\tprivate var " + current + ";\n";
				}
			}
			
			
			output += "\n\t\tpublic function " + className + " (\n";			
			for (i=0; i<temp.length; i++) {
				output += "\t\t\t\t\tthe" + StringPlus.firstUpper(temp[i])+",\n";
			}
			output = output.substr(0,output.length-2);
			output += ") {\n\n";
			
			for (i=0; i<temp.length; i++) {
				current = temp[i].split(":")[0];	
				if (prefix.length > 0) {															
					output += "\t\t\t" + prefix + StringPlus.firstUpper(current) + " = " + "the" + StringPlus.firstUpper(current) + ";\n";
				} else {
					output += "\t\t\t" + current + " = " + "the" + StringPlus.firstUpper(current) + ";\n";
				}
			}
			
			output += "\n\t\t}";
			
			trace (output);
		}
	}
}