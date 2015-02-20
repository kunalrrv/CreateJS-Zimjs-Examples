package com.danzen.utilities
{
	import flash.geom.ColorTransform;
	
	public class Colors
	{
		public static function getHexFromNumber(n:Number):String {
			
			// input:   (Number) decimal color (i.e. 16711680)
			// returns: (String) hex color (i.e. 0xFF0000)
			var colArr:Array = n.toString(16).toUpperCase().split('');
			var numChars:Number = colArr.length;
			for(var a:uint=0; a<(6-numChars); a++){
				colArr.unshift("0");
			}
			return('#' + colArr.join(''));			
		}
		
		public static function getName(c:Number):String
		{
			var nums:Array = [0x000000, 0x000080, 0x00008B, 0x00009C, 0x0000CD, 0x0000FF, 0x000F89, 0x0014A8, 0x002147, 0x002366, 0x002387, 0x002395, 0x002E63, 0x002FA7, 0x00308F, 0x003153, 0x003366, 0x003399, 0x003399, 0x0033AA, 0x0038A8, 0x004040, 0x00416A, 0x00416A, 0x004225, 0x004242, 0x0047AB, 0x004953, 0x004B49, 0x004F98, 0x0054B4, 0x00563F, 0x006600, 0x0067A5, 0x006994, 0x006A4E, 0x006B3C, 0x00703C, 0x0070FF, 0x0072BB, 0x0073CF, 0x007474, 0x00755E, 0x0077BE, 0x007AA5, 0x007BA7, 0x007BA7, 0x007FBF, 0x007FFF, 0x008000, 0x008000, 0x008000, 0x008080, 0x00827F, 0x0087BD, 0x008B8B, 0x009000, 0x0093AF, 0x0095B6, 0x009E60, 0x009F6B, 0x00A550, 0x00A693, 0x00A86B, 0x00A877, 0x00B7EB, 0x00BFFF, 0x00BFFF, 0x00CC99, 0x00CCCC, 0x00CED1, 0x00FA9A, 0x00FF00, 0x00FF00, 0x00FF00, 0x00FF7F, 0x00FF7F, 0x00FFEF, 0x00FFFF, 0x00FFFF, 0x00FFFF, 0x013220, 0x014421, 0x014421, 0x01796F, 0x0247FE, 0x035096, 0x03C03C, 0x059033, 0x062A78, 0x08457E, 0x087830, 0x0892D0, 0x08E8DE, 0x0ABAB5, 0x0BDA51, 0x0D98BA, 0x0F0F0F, 0x0F4D92, 0x0F52BA, 0x0FC0FC, 0x100C08, 0x1034A6, 0x120A8F, 0x123524, 0x138808, 0x1560BD, 0x177245, 0x18453B, 0x191970, 0x195905, 0x1A2421, 0x1C352D, 0x1C39BB, 0x1CAC78, 0x1DACD6, 0x1E4D2B, 0x1E90FF, 0x1F75FE, 0x20B2AA, 0x21421E, 0x21ABCD, 0x228B22, 0x23297A, 0x26619C, 0x273BE2, 0x29AB87, 0x2A52BE, 0x2A8000, 0x2C1608, 0x2E8B57, 0x2F4F4F, 0x2F847C, 0x30BA8F, 0x30D5C8, 0x318CE7, 0x32127A, 0x321414, 0x32CD32, 0x333399, 0x355E3B, 0x36454F, 0x367588, 0x39FF14, 0x3B444B, 0x3C1414, 0x3C341F, 0x3CB371, 0x3CD070, 0x3D2B1F, 0x3EB489, 0x3F00FF, 0x3FFF00, 0x40826D, 0x414833, 0x414A4C, 0x4166F5, 0x4169E1, 0x417DC1, 0x43B3AE, 0x446CCF, 0x465945, 0x4682B4, 0x480607, 0x483C32, 0x483C32, 0x483C32, 0x483D8B, 0x48D1CC, 0x49796B, 0x4997D0, 0x4B0082, 0x4B3621, 0x4B5320, 0x4CBB17, 0x4D5D53, 0x4F666A, 0x4F7942, 0x50404D, 0x507D2A, 0x50C878, 0x50C878, 0x51484F, 0x5218FA, 0x522D80, 0x534B4F, 0x536872, 0x536878, 0x536878, 0x536895, 0x555555, 0x556B2F, 0x560319, 0x592720, 0x5A4FCF, 0x5B92E5, 0x5D3954, 0x5D8AA8, 0x5D8AA8, 0x5F9EA0, 0x6050DC, 0x6082B6, 0x614051, 0x635147, 0x645452, 0x6495ED, 0x65000B, 0x654321, 0x654321, 0x66023C, 0x663854, 0x66424D, 0x6699CC, 0x66B032, 0x66DDAA, 0x66FF00, 0x673147, 0x674846, 0x674C47, 0x682860, 0x69359C, 0x696969, 0x6A5ACD, 0x6B8E23, 0x6C541E, 0x6D9BC3, 0x6E7F80, 0x6F00FF, 0x6F00FF, 0x6F4E37, 0x701C1C, 0x701C1C, 0x702963, 0x704214, 0x704241, 0x708090, 0x71A6D2, 0x722F37, 0x72A0C1, 0x734F96, 0x738678, 0x73A9C2, 0x73C2FB, 0x746CC0, 0x74C365, 0x76FF7A, 0x778899, 0x779ECB, 0x77DD77, 0x78184A, 0x7851A9, 0x78866B, 0x79443B, 0x796878, 0x7B1113, 0x7B3F00, 0x7B68EE, 0x7C0A02, 0x7CFC00, 0x7DF9FF, 0x7F00FF, 0x7F7F7F, 0x7FFF00, 0x7FFFD4, 0x800000, 0x800020, 0x800080, 0x800080, 0x801818, 0x80461B, 0x808000, 0x808000, 0x808080, 0x808080, 0x80A570, 0x826644, 0x836953, 0x841B2D, 0x843F5B, 0x848482, 0x85BB65, 0x860111, 0x8601AF, 0x86608E, 0x872657, 0x873260, 0x87A96B, 0x87CEEB, 0x87CEFA, 0x880085, 0x882D17, 0x8878C3, 0x88D8C0, 0x893F45, 0x89CFF0, 0x8A2BE2, 0x8A3324, 0x8A496B, 0x8A795D, 0x8B0000, 0x8B008B, 0x8B4513, 0x8B8589, 0x8C92AC, 0x8DB600, 0x8E4585, 0x8F00FF, 0x8F00FF, 0x8FBC8F, 0x905D5D, 0x90EE90, 0x915C83, 0x915F6D, 0x915F6D, 0x918151, 0x91A3B0, 0x92000A, 0x922724, 0x92A1CF, 0x933D41, 0x9370DB, 0x93C572, 0x93CCEA, 0x9400D3, 0x9457EB, 0x960018, 0x964B00, 0x966FD6, 0x967117, 0x967117, 0x967117, 0x967117, 0x9678B6, 0x967BB6, 0x96C8A2, 0x96DED1, 0x979AAA, 0x986960, 0x987654, 0x98777B, 0x98817B, 0x98FB98, 0x98FF98, 0x990000, 0x990000, 0x990000, 0x9932CC, 0x9955BB, 0x996515, 0x996666, 0x9966CC, 0x997A8D, 0x99BADD, 0x9AB973, 0x9ACD32, 0x9B111E, 0x9B870C, 0x9BC4E2, 0x9BDDFF, 0x9C2542, 0x9DC209, 0x9F00C5, 0x9F00FF, 0x9F1D35, 0x9F8170, 0xA020F0, 0xA020F0, 0xA0785A, 0xA1CAF1, 0xA2A2D0, 0xA2ADD0, 0xA32638, 0xA3C1AD, 0xA40000, 0xA4C639, 0xA4DDED, 0xA4F4F9, 0xA50B5E, 0xA52A2A, 0xA52A2A, 0xA52A2A, 0xA57164, 0xA67B5B, 0xA67B5B, 0xA76BCF, 0xA7FC00, 0xA81C07, 0xA8516E, 0xA8E4A0, 0xA9203E, 0xA99A86, 0xA9A9A9, 0xA9BA9D, 0xAA381E, 0xAA98A9, 0xAAF0D1, 0xAB4E52, 0xAB4E52, 0xABCDEF, 0xACE1AF, 0xACE5EE, 0xADD8E6, 0xADDFAD, 0xADFF2F, 0xAE0C00, 0xAE2029, 0xAEC6CF, 0xAF4035, 0xAF4035, 0xAFEEEE, 0xB03060, 0xB03060, 0xB06500, 0xB0E0E6, 0xB19CD9, 0xB22222, 0xB2BEB5, 0xB2EC5D, 0xB2FFFF, 0xB31B1B, 0xB31B1B, 0xB3446C, 0xB38B6D, 0xB39EB5, 0xB48395, 0xB53389, 0xB5651D, 0xB57281, 0xB57EDC, 0xB5A642, 0xB666D2, 0xB7410E, 0xB768A2, 0xB76E79, 0xB784A7, 0xB78727, 0xB87333, 0xB8860B, 0xB94E48, 0xBA160C, 0xBA55D3, 0xBB3385, 0xBB6528, 0xBC8F8F, 0xBC987E, 0xBCD4E6, 0xBCD4E6, 0xBD33A4, 0xBDB76B, 0xBDDA57, 0xBE0032, 0xBEBEBE, 0xBF00FF, 0xBF4F51, 0xBF94E4, 0xBFFF00, 0xC04000, 0xC08081, 0xC0C0C0, 0xC154C1, 0xC154C1, 0xC19A6B, 0xC19A6B, 0xC19A6B, 0xC19A6B, 0xC23B22, 0xC2B280, 0xC2B280, 0xC32148, 0xC32148, 0xC3B091, 0xC40233, 0xC41E3A, 0xC46210, 0xC4C3D0, 0xC54B8C, 0xC5B358, 0xC71585, 0xC71585, 0xC72C48, 0xC74375, 0xC80815, 0xC8A2C8, 0xC90016, 0xC9A0DC, 0xC9C0BB, 0xC9DC87, 0xCA1F7B, 0xCA2C92, 0xCB410B, 0xCB4154, 0xCB99C9, 0xCBA135, 0xCC0000, 0xCC00CC, 0xCC3333, 0xCC4E5C, 0xCC5500, 0xCC6666, 0xCC7722, 0xCC8899, 0xCCCCFF, 0xCCCCFF, 0xCCFF00, 0xCCFF00, 0xCCFF00, 0xCD5700, 0xCD5B45, 0xCD5C5C, 0xCD5C5C, 0xCD7F32, 0xCD853F, 0xCD9575, 0xCE2029, 0xCF1020, 0xCF3476, 0xCF71AF, 0xCFB53B, 0xCFCFC4, 0xD0F0C0, 0xD10056, 0xD19FE8, 0xD1E231, 0xD2691E, 0xD2691E, 0xD2691E, 0xD2B48C, 0xD3003F, 0xD3D3D3, 0xD40000, 0xD4AF37, 0xD6CADD, 0xD70040, 0xD70040, 0xD70A53, 0xD71868, 0xD73B3E, 0xD7837F, 0xD83387, 0xD8BFD8, 0xD9004C, 0xD9603B, 0xD99058, 0xDA1D81, 0xDA3287, 0xDA70D6, 0xDA8A67, 0xDA9100, 0xDAA520, 0xDB7093, 0xDB7093, 0xDBD7D2, 0xDC143C, 0xDCD0FF, 0xDCDCDC, 0xDDA0DD, 0xDDA0DD, 0xDDA0DD, 0xDDADAF, 0xDE3163, 0xDE3163, 0xDE5D83, 0xDE6FA1, 0xDE6FA1, 0xDEA5A4, 0xDEAA88, 0xDEB887, 0xDF00FF, 0xDF00FF, 0xDF73FF, 0xDFFF00, 0xE0115F, 0xE03C31, 0xE08D3C, 0xE0B0FF, 0xE0FFFF, 0xE18E96, 0xE1A95F, 0xE1AD21, 0xE2062C, 0xE25098, 0xE25822, 0xE2725B, 0xE30022, 0xE30B5D, 0xE3256B, 0xE32636, 0xE32636, 0xE34234, 0xE34234, 0xE3A857, 0xE3DAC9, 0xE3FF00, 0xE4717A, 0xE4717A, 0xE48400, 0xE49B0F, 0xE4D00A, 0xE4D96F, 0xE52B50, 0xE5AA70, 0xE5B73B, 0xE5E4E2, 0xE62020, 0xE66771, 0xE68FAC, 0xE68FAC, 0xE6BE8A, 0xE6E200, 0xE6E6FA, 0xE6E6FA, 0xE6E8FA, 0xE75480, 0xE7ACCF, 0xE7FEFF, 0xE8000D, 0xE9692C, 0xE97451, 0xE9967A, 0xE9D66B, 0xE9D66B, 0xEAE0C8, 0xEB4C42, 0xEC3B83, 0xEC5800, 0xECD540, 0xECEBBD, 0xED1C24, 0xED872D, 0xED9121, 0xEDC9AF, 0xEE82EE, 0xEE82EE, 0xEEDC82, 0xEEE600, 0xEEE8AA, 0xEF3038, 0xEF98AA, 0xEFBBCC, 0xEFCC00, 0xEFDECD, 0xF08080, 0xF0DC82, 0xF0E130, 0xF0E68C, 0xF0E68C, 0xF0EAD6, 0xF0F8FF, 0xF0FFF0, 0xF0FFFF, 0xF1A7FE, 0xF2003C, 0xF28500, 0xF2F3F4, 0xF2F3F4, 0xF3E5AB, 0xF3E5AB, 0xF400A1, 0xF400A1, 0xF49AC2, 0xF4A460, 0xF4BBFF, 0xF4BBFF, 0xF4C2C2, 0xF4C2C2, 0xF4C430, 0xF4F0EC, 0xF56991, 0xF5DEB3, 0xF5F5DC, 0xF5F5F5, 0xF5FFFA, 0xF64A8A, 0xF6ADC6, 0xF77FBE, 0xF78FA7, 0xF7E98E, 0xF88379, 0xF88379, 0xF88379, 0xF8B878, 0xF8DE7E, 0xF8DE7E, 0xF8F4FF, 0xF8F8FF, 0xF9429E, 0xF94D00, 0xF984E5, 0xF984EF, 0xFAD6A5, 0xFAD6A5, 0xFAD6A5, 0xFADA5E, 0xFADA5E, 0xFADA5E, 0xFADA5E, 0xFADADD, 0xFADFAD, 0xFAE7B5, 0xFAEBD7, 0xFAEBD7, 0xFAF0BE, 0xFAF0E6, 0xFAFAD2, 0xFB607F, 0xFB9902, 0xFBA0E3, 0xFBAB60, 0xFBAED2, 0xFBCCE7, 0xFBCEB1, 0xFBEC5D, 0xFBEC5D, 0xFC0FC0, 0xFC6C85, 0xFC89AC, 0xFC8EAC, 0xFCC200, 0xFCF75E, 0xFD0E35, 0xFD0E35, 0xFDBCB4, 0xFDD5B1, 0xFDDDE6, 0xFDEE00, 0xFDF5E6, 0xFDFD96, 0xFE2712, 0xFE28A2, 0xFE4164, 0xFE4EDA, 0xFE6F5E, 0xFEFE22, 0xFEFE33, 0xFF0000, 0xFF0028, 0xFF0038, 0xFF003F, 0xFF004F, 0xFF007F, 0xFF007F, 0xFF0090, 0xFF00FF, 0xFF00FF, 0xFF033E, 0xFF0800, 0xFF1493, 0xFF1493, 0xFF1DCE, 0xFF2400, 0xFF2800, 0xFF33CC, 0xFF355E, 0xFF3800, 0xFF4040, 0xFF43A4, 0xFF4500, 0xFF4F00, 0xFF5349, 0xFF55A3, 0xFF5A36, 0xFF6347, 0xFF66CC, 0xFF6700, 0xFF6961, 0xFF69B4, 0xFF6E4A, 0xFF6FFF, 0xFF6FFF, 0xFF7518, 0xFF77FF, 0xFF7E00, 0xFF7F00, 0xFF7F50, 0xFF8243, 0xFF8C00, 0xFF8C69, 0xFF8F00, 0xFF91A4, 0xFF9933, 0xFF9966, 0xFF9966, 0xFF9999, 0xFF9F00, 0xFFA07A, 0xFFA089, 0xFFA343, 0xFFA500, 0xFFA6C9, 0xFFA700, 0xFFA812, 0xFFAE42, 0xFFB300, 0xFFB347, 0xFFB6C1, 0xFFB7C5, 0xFFBA00, 0xFFBCD9, 0xFFBF00, 0xFFBF00, 0xFFC0CB, 0xFFC1CC, 0xFFC40C, 0xFFC87C, 0xFFCBA4, 0xFFCBA4, 0xFFCC00, 0xFFCC00, 0xFFCC33, 0xFFCC99, 0xFFD300, 0xFFD700, 0xFFD800, 0xFFDAB9, 0xFFDB58, 0xFFDDF4, 0xFFDEAD, 0xFFDF00, 0xFFE135, 0xFFE4C4, 0xFFE4E1, 0xFFE5B4, 0xFFEBCD, 0xFFEF00, 0xFFEF00, 0xFFEFD5, 0xFFF0F5, 0xFFF5EE, 0xFFF600, 0xFFF700, 0xFFF8DC, 0xFFF8E7, 0xFFFACD, 0xFFFAF0, 0xFFFAFA, 0xFFFDD0, 0xFFFF00, 0xFFFF00, 0xFFFF31, 0xFFFF66, 0xFFFFE0, 0xFFFFF0, 0xFFFFFF];			
			var names:Array = ["Black", "Navy Blue", "Dark Blue", "Duke Blue", "Medium Blue", "Blue", "Phthalo Blue", "Zaffre", "Oxford Blue", "Royal Blue", "Resolution Blue", "Imperial Blue", "Cool Black", "International Klein Blue", "Air Force Blue", "Prussian Blue", "Dark Midnight Blue", "Dark Powder Blue", "Smalt", "Ua Blue", "Royal Azure", "Rich Black", "Dark Imperial Blue", "Indigo", "British Racing Green", "Warm Black", "Cobalt", "Midnight Green", "Deep Jungle Green", "Usafa Blue", "Medium Teal Blue", "Sacramento State Green", "Pakistan Green", "Medium Persian Blue", "Sea Blue", "Bottle Green", "Cadmium Green", "Dartmouth Green", "Brandeis Blue", "French Blue", "True Blue", "Skobeloff", "Tropical Rain Forest", "Ocean Boat Blue", "Cg Blue", "Celadon Blue", "Cerulean", "Honolulu Blue", "Azure", "Ao", "Green", "Office Green", "Teal", "Teal Green", "Blue", "Dark Cyan", "Islamic Green", "Blue", "Bondi Blue", "Shamrock Green", "Green", "Green", "Persian Green", "Jade", "Green", "Cyan", "Capri", "Deep Sky Blue", "Caribbean Green", "Robin Egg Blue", "Dark Turquoise", "Medium Spring Green", "Electric Green", "Green", "Lime", "Guppie Green", "Spring Green", "Turquoise Blue", "Aqua", "Cyan", "Electric Cyan", "Dark Green", "Forest Green", "Up Forest Green", "Pine Green", "Blue", "Medium Electric Blue", "Dark Pastel Green", "North Texas Green", "Catalina Blue", "Dark Cerulean", "La Salle Green", "Rich Electric Blue", "Bright Turquoise", "Tiffany Blue", "Malachite", "Blue-Green", "Onyx", "Yale Blue", "Sapphire", "Spiro Disco Ball", "Smoky Black", "Egyptian Blue", "Ultramarine", "Phthalo Green", "India Green", "Denim", "Dark Spring Green", "Msu Green", "Midnight Blue", "Lincoln Green", "Dark Jungle Green", "Medium Jungle Green", "Persian Blue", "Green", "Bright Cerulean", "Cal Poly Green", "Dodger Blue", "Blue", "Light Sea Green", "Myrtle", "Ball Blue", "Forest Green", "St. Patrick's Blue", "Lapis Lazuli", "Palatinate Blue", "Jungle Green", "Cerulean Blue", "Napier Green", "Zinnwaldite Brown", "Sea Green", "Dark Slate Gray", "Celadon Green", "Mountain Meadow", "Turquoise", "Bleu De France", "Persian Indigo", "Seal Brown", "Lime Green", "Blue", "Hunter Green", "Charcoal", "Teal Blue", "Neon Green", "Arsenic", "Dark Sienna", "Olive Drab #7", "Medium Sea Green", "Ufo Green", "Bistre", "Mint", "Electric Ultramarine", "Harlequin", "Viridian", "Rifle Green", "Outer Space", "Ultramarine Blue", "Royal Blue", "Tufts Blue", "Verdigris", "Han Blue", "Gray-Asparagus", "Steel Blue", "Bulgarian Rose", "Dark Lava", "Dark Taupe", "Taupe", "Dark Slate Blue", "Medium Turquoise", "Hooker's Green", "Celestial Blue", "Indigo", "Café Noir", "Army Green", "Kelly Green", "Feldgrau", "Stormcloud", "Fern Green", "Purple Taupe", "Sap Green", "Emerald", "Paris Green", "Quartz", "Han Purple", "Regalia", "Liver", "Cadet", "Dark Electric Blue", "Payne's Grey", "Ucla Blue", "Davy's Grey", "Dark Olive Green", "Dark Scarlet", "Caput Mortuum", "Iris", "United Nations Blue", "Dark Byzantium", "Air Force Blue", "Rackley", "Cadet Blue", "Majorelle Blue", "Glaucous", "Eggplant", "Umber", "Wenge", "Cornflower Blue", "Rosewood", "Dark Brown", "Otter Brown", "Tyrian Purple", "Halayà Úbe", "Tuscan Red", "Blue Gray", "Green", "Medium Aquamarine", "Bright Green", "Old Mauve", "Rose Ebony", "Medium Taupe", "Palatinate Purple", "Purple Heart", "Dim Gray", "Slate Blue", "Olive Drab", "Field Drab", "Cerulean Frost", "Aurometalsaurus", "Electric Indigo", "Indigo", "Coffee", "Persian Plum", "Prune", "Byzantium", "Sepia", "Deep Coffee", "Slate Gray", "Iceberg", "Wine", "Air Superiority Blue", "Dark Lavender", "Xanadu", "Moonstone Blue", "Maya Blue", "Toolbox", "Mantis", "Screamin' Green", "Light Slate Gray", "Dark Pastel Blue", "Pastel Green", "Pansy Purple", "Royal Purple", "Camouflage Green", "Bole", "Old Lavender", "Up Maroon", "Chocolate", "Medium Slate Blue", "Barn Red", "Lawn Green", "Electric Blue", "Violet", "Gray", "Chartreuse", "Aquamarine", "Maroon", "Burgundy", "Patriarch", "Purple", "Falu Red", "Russet", "Heart Gold", "Olive", "Gray", "Trolley Grey", "Yellow-Ochre", "Raw Umber", "Pastel Brown", "Antique Ruby", "Deep Ruby", "Battleship Grey", "Dollar Bill", "Red Devil", "Violet", "French Lilac", "Dark Raspberry", "Boysenberry", "Asparagus", "Sky Blue", "Light Sky Blue", "Mardi Gras", "Sienna", "Ube", "Pearl Aqua", "Cordovan", "Baby Blue", "Blue-Violet", "Burnt Umber", "Twilight Lavender", "Shadow", "Dark Red", "Dark Magenta", "Saddle Brown", "Taupe Gray", "Cool Grey", "Apple Green", "Plum", "Electric Violet", "Violet", "Dark Sea Green", "Rose Taupe", "Light Green", "Antique Fuchsia", "Mauve Taupe", "Raspberry Glace", "Dark Tan", "Cadet Grey", "Sangria", "Vivid Auburn", "Ceil", "Smokey Topaz", "Medium Purple", "Pistachio", "Light Cornflower Blue", "Dark Violet", "Lavender Indigo", "Carmine", "Brown", "Dark Pastel Purple", "Drab", "Mode Beige", "Sand Dune", "Sandy Taupe", "Purple Mountain Majesty", "Lavender Purple", "Eton Blue", "Pale Robin Egg Blue", "Manatee", "Dark Chestnut", "Pale Brown", "Bazaar", "Cinereous", "Pale Green", "Mint Green", "Ou Crimson Red", "Stizza", "Usc Cardinal", "Dark Orchid", "Deep Lilac", "Golden Brown", "Copper Rose", "Amethyst", "Mountbatten Pink", "Carolina Blue", "Olivine", "Yellow-Green", "Ruby Red", "Dark Yellow", "Pale Cerulean", "Columbia Blue", "Big Dip O'ruby", "Limerick", "Purple", "Vivid Violet", "Vivid Burgundy", "Beaver", "Purple", "Veronica", "Chamoisee", "Baby Blue Eyes", "Blue Bell", "Wild Blue Yonder", "Alabama Crimson", "Cambridge Blue", "Dark Candy Apple Red", "Android Green", "Non-Photo Blue", "Waterspout", "Jazzberry Jam", "Auburn", "Brown", "Red-Brown", "Blast-Off Bronze", "Café Au Lait", "French Beige", "Rich Lavender", "Spring Bud", "Rufous", "China Rose", "Granny Smith Apple", "Deep Carmine", "Grullo", "Dark Gray", "Laurel Green", "Chinese Red", "Rose Quartz", "Magic Mint", "Redwood", "Rose Vale", "Pale Cornflower Blue", "Celadon", "Blizzard Blue", "Light Blue", "Moss Green", "Green-Yellow", "Mordant Red 19", "Upsdell Red", "Pastel Blue", "Medium Carmine", "Pale Carmine", "Pale Blue", "Maroon", "Rich Maroon", "Ginger", "Powder Blue", "Light Pastel Purple", "Firebrick", "Ash Grey", "Inchworm", "Celeste", "Carnelian", "Cornell Red", "Raspberry Rose", "Light Taupe", "Pastel Purple", "English Lavender", "Fandango", "Light Brown", "Turkish Rose", "Lavender", "Brass", "Rich Lilac", "Rust", "Pearly Purple", "Rose Gold", "Opera Mauve", "University Of California Gold", "Copper", "Dark Goldenrod", "Deep Chestnut", "International Orange", "Medium Orchid", "Medium Red-Violet", "Ruddy Brown", "Rosy Brown", "Pale Taupe", "Beau Blue", "Pale Aqua", "Byzantine", "Dark Khaki", "June Bud", "Crimson Glory", "Gray", "Electric Purple", "Bittersweet Shimmer", "Bright Lavender", "Lime", "Mahogany", "Old Rose", "Silver", "Deep Fuchsia", "Fuchsia", "Camel", "Desert", "Fallow", "Lion", "Dark Pastel Red", "Ecru", "Sand", "Bright Maroon", "Maroon", "Khaki", "Red", "Cardinal", "Alloy Orange", "Lavender Gray", "Mulberry", "Vegas Gold", "Medium Violet-Red", "Red-Violet", "French Raspberry", "Fuchsia Rose", "Venetian Red", "Lilac", "Harvard Crimson", "Wisteria", "Pale Silver", "Medium Spring Bud", "Magenta", "Royal Fuchsia", "Sinopia", "Brick Red", "Pastel Violet", "Satin Sheen Gold", "Boston University Red", "Deep Magenta", "Persian Red", "Dark Terra Cotta", "Burnt Orange", "Fuzzy Wuzzy", "Ochre", "Puce", "Lavender Blue", "Periwinkle", "Electric Lime", "Fluorescent Yellow", "French Lime", "Tenné", "Dark Coral", "Chestnut", "Indian Red", "Bronze", "Peru", "Antique Brass", "Fire Engine Red", "Lava", "Telemagenta", "Sky Magenta", "Old Gold", "Pastel Gray", "Tea Green", "Rubine Red", "Bright Ube", "Pear", "Chocolate", "Cinnamon", "Cocoa Brown", "Tan", "Utah Crimson", "Light Gray", "Rosso Corsa", "Gold", "Languid Lavender", "Carmine", "Rich Carmine", "Debian Red", "Dogwood Rose", "Jasper", "New York Pink", "Cerise", "Thistle", "Ua Red", "Medium Vermilion", "Persian Orange", "Vivid Cerise", "Deep Cerise", "Orchid", "Pale Copper", "Harvest Gold", "Goldenrod", "Pale Red-Violet", "Pale Violet-Red", "Timberwolf", "Crimson", "Pale Lavender", "Gainsboro", "Medium Lavender Magenta", "Pale Plum", "Plum", "Pale Chestnut", "Cerise Red", "Cherry", "Blush", "China Pink", "Thulian Pink", "Pastel Pink", "Tumbleweed", "Burlywood", "Phlox", "Psychedelic Purple", "Heliotrope", "Chartreuse", "Ruby", "Cg Red", "Tiger's Eye", "Mauve", "Light Cyan", "Ruddy Pink", "Earth Yellow", "Urobilin", "Medium Candy Apple Red", "Raspberry Pink", "Flame", "Terra Cotta", "Cadmium Red", "Raspberry", "Razzmatazz", "Alizarin Crimson", "Rose Madder", "Cinnabar", "Vermilion", "Indian Yellow", "Bone", "Lemon Lime", "Candy Pink", "Tango Pink", "Fulvous", "Gamboge", "Citrine", "Straw", "Amaranth", "Fawn", "Meat Brown", "Platinum", "Lust", "Light Carmine Pink", "Charm Pink", "Light Thulian Pink", "Pale Gold", "Peridot", "Lavender", "Lavender Mist", "Glitter", "Dark Pink", "Pink Pearl", "Bubbles", "Ku Crimson", "Deep Carrot Orange", "Light Red Ochre", "Dark Salmon", "Arylide Yellow", "Hansa Yellow", "Pearl", "Carmine Pink", "Cerise Pink", "Persimmon", "Sandstorm", "Pale Spring Bud", "Red", "Cadmium Orange", "Carrot Orange", "Desert Sand", "Lavender Magenta", "Violet", "Flax", "Titanium Yellow", "Pale Goldenrod", "Deep Carmine Pink", "Mauvelous", "Cameo Pink", "Yellow", "Almond", "Light Coral", "Buff", "Dandelion", "Khaki", "Light Khaki", "Eggshell", "Alice Blue", "Honeydew", "Azure Mist/Web", "Rich Brilliant Lavender", "Red", "Tangerine", "Anti-Flash White", "Munsell", "Medium Champagne", "Vanilla", "Fashion Fuchsia", "Hollywood Cerise", "Pastel Magenta", "Sandy Brown", "Brilliant Lavender", "Electric Lavender", "Baby Pink", "Tea Rose", "Saffron", "Isabelline", "Light Crimson", "Wheat", "Beige", "White Smoke", "Mint Cream", "French Rose", "Nadeshiko Pink", "Persian Pink", "Pink Sherbet", "Flavescent", "Congo Pink", "Coral Pink", "Tea Rose", "Mellow Apricot", "Jasmine", "Mellow Yellow", "Magnolia", "Ghost White", "Rose Bonbon", "Tangelo", "Pale Magenta", "Light Fuchsia Pink", "Champagne", "Deep Champagne", "Sunset", "Jonquil", "Naples Yellow", "Royal Yellow", "Stil De Grain Yellow", "Pale Pink", "Peach-Yellow", "Banana Mania", "Antique White", "Moccasin", "Blond", "Linen", "Light Goldenrod Yellow", "Brink Pink", "Orange", "Lavender Rose", "Rajah", "Lavender Pink", "Classic Rose", "Apricot", "Corn", "Maize", "Shocking Pink", "Wild Watermelon", "Tickle Me Pink", "Flamingo Pink", "Golden Poppy", "Icterine", "Scarlet", "Tractor Red", "Melon", "Light Apricot", "Piggy Pink", "Aureolin", "Old Lace", "Pastel Yellow", "Red", "Persian Rose", "Neon Fuchsia", "Purple Pizzazz", "Bittersweet", "Laser Lemon", "Yellow", "Red", "Ruddy", "Carmine Red", "Electric Crimson", "Folly", "Bright Pink", "Rose", "Magenta", "Fuchsia", "Magenta", "American Rose", "Candy Apple Red", "Deep Pink", "Fluorescent Pink", "Hot Magenta", "Scarlet", "Ferrari Red", "Razzle Dazzle Rose", "Radical Red", "Coquelicot", "Coral Red", "Wild Strawberry", "Orange-Red", "International Orange", "Red-Orange", "Brilliant Rose", "Portland Orange", "Tomato", "Rose Pink", "Safety Orange", "Pastel Red", "Hot Pink", "Outrageous Orange", "Shocking Pink", "Ultra Pink", "Pumpkin", "Fuchsia Pink", "Amber", "Orange", "Coral", "Mango Tango", "Dark Orange", "Salmon", "Princeton Orange", "Salmon Pink", "Deep Saffron", "Atomic Tangerine", "Pink-Orange", "Light Salmon Pink", "Orange Peel", "Light Salmon", "Vivid Tangerine", "Neon Carrot", "Orange", "Carnation Pink", "Chrome Yellow", "Dark Tangerine", "Yellow Orange", "Ucla Gold", "Pastel Orange", "Light Pink", "Cherry Blossom Pink", "Selective Yellow", "Cotton Candy", "Amber", "Fluorescent Orange", "Pink", "Bubble Gum", "Mikado Yellow", "Topaz", "Deep Peach", "Peach", "Tangerine Yellow", "Usc Gold", "Sunglow", "Peach-Orange", "Yellow", "Gold", "School Bus Yellow", "Peach Puff", "Mustard", "Pink Lace", "Navajo White", "Golden Yellow", "Banana Yellow", "Bisque", "Misty Rose", "Peach", "Blanched Almond", "Canary Yellow", "Yellow", "Papaya Whip", "Lavender Blush", "Seashell", "Cadmium Yellow", "Lemon", "Cornsilk", "Cosmic Latte", "Lemon Chiffon", "Floral White", "Snow", "Cream", "Electric Yellow", "Yellow", "Daffodil", "Unmellow Yellow", "Light Yellow", "Ivory", "White"];
			
			//var index:int = find(nums, c);
			//return names[index];
			
			var index:int = getClosest((c>>16)&0xFF,(c>>8)&0xFF,c&0xFF);
			return names[index];
			
			
			
			function find(keys:Array, target:Object):int {				
				var high:int = keys.length;
				var low:int = -1;
				var probe:int;
				while (high - low > 2) {
					probe = (low + high) / 2;
					if (keys[probe] > target) {
						high = probe;
					} else {
						low = probe;
					}
				}
				
				if (low == -1) {
					return -1;
				} else {
					return low;
				}
			}
			
			

			
			
			/*
			function getClosestHex(a:Number, b:Array):Number {
				var c:Number=-1;
				var d:Number=b.length
				var e:Number=768
				var f:Number;
				var a:Array = [a>>>16, a>>>8&0x00FF, a&0x0000FF];
				
				while(++c; Math.abs(a[0]-(b[c]>>>16))+Math.abs(a[1]-(b[c]>>>8&0x00FF))+Math.abs(a[2]-(b[c]&0x0000FF)) ) {
 				//)) f=c;
					f=c;
				}
				return b[f];
			}
			
			var a = 0x80807f;
			var hexPalette:Array = [0x000000, 0xFFFFFF, 0xFF0000, 0x00FF00, 0x0000FF,
				0x00FFFF, 0xFF00FF, 0xFFFF00];
			var getA = getClosestHex(a, hexPalette);
			trace(getA.toString(16));			
			*/
			
			/*
			var hexPalette:Array = [0x000000, 0xFFFFFF, 0xFF0000, 0x00FF00, 0x0000FF,
				0x00FFFF, 0xFF00FF, 0xFFFF00];
			
			function buildRGB(palette:Array){
				var a=[], i=-1, l=palette.length;
				while(++i>>16, palette[i]>>>8&0x00FF,
					palette[i]&0x0000FF];
					return a;
					}
			
			function getClosestColor(color:Array, palette:Array){
				var c=-1, d=palette.length, e=768, f;
				while(++c
					Math.abs(color[0]-palette[c][0])+Math.abs(color[1]-palette[c][1])+Math.abs(color[2]-palette[c][2]))))
				f=c;
				return palette[f];
			}
			
			var b = [128, 128, 127];
			var rgbPalette:Array = buildRGB(hexPalette);
			var getB = getClosestColor(b, rgbPalette);
			trace(getB);	*/
			
			
			
			

			function getClosest(red1:Number, green1:Number, blue1:Number):Number {
				var totalColors:Number = nums.length;
				var tempDistance:Number=11111111111;
				var closestIndex:Number;
				for (var i:Number = 0; i < totalColors; i++) {
					// first, break up the color to check
					var red2:Number = (nums[i] & 0xFF0000) >>> 16;
					var green2:Number = (nums[i] & 0x00FF00) >>> 8;
					var blue2:Number = nums[i] & 0x0000FF;
					
					// now, get the distance from the source
					var tempD:Number = Math.sqrt ( Math.pow((red1-red2),2) + Math.pow((green1-green2),2) + Math.pow((blue1-blue2),2) );
					if (tempD <= tempDistance) {
						tempDistance = tempD;
						closestIndex = i;
					}
				}				
				return closestIndex;
			}			
					
		}
	}
}