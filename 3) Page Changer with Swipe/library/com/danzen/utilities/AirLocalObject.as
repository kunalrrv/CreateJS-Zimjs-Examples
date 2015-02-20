package com.danzen.utilities {
	
	// class to use SQLlight in similar way to a shared local object 
	// not quite as flexible as you specify at the start what properties you are using
	// have found the shared object does not work that well on iOS even with flush();
	// 2013 Dan Zen
	
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.filesystem.File;

	public class AirLocalObject {
		
		private var sqlConnection:SQLConnection;
		private var uniqueName:String; // unique name for database path
		private var propertyNames:Array; // list of strings for property names to store - as strings
		
		public function AirLocalObject(theUniqueName:String, thePropertyNames:Array) {			
								
			trace ("hi from AirLocalObject");
			
			uniqueName = theUniqueName;
			propertyNames = thePropertyNames;
						
			sqlConnection = new SQLConnection();
			sqlConnection.open(File.applicationStorageDirectory.resolvePath(uniqueName + ".db"));			
									
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			
			var initiateString:String = "";
			var insertString:String = "";
			var valuesString:String = "";
			for (var i:uint=0; i<propertyNames.length; i++) {
				initiateString += propertyNames[i] + " TEXT,"; 
				insertString += propertyNames[i] + ",";
				valuesString += "'',";
			}
			initiateString = initiateString.substr(0, -1);
			insertString = insertString.substr(0, -1);
			valuesString = valuesString.substr(0, -1);
			
			
			stmt.text = "CREATE TABLE IF NOT EXISTS data (" + initiateString + ")";
			stmt.execute();
									
			stmt.text = "SELECT * FROM data";
			stmt.execute();
			var result:SQLResult = stmt.getResult();			
			if (!result.data) {
				stmt.text = "INSERT into data (" + insertString + ") values(" + valuesString + ")";
				stmt.execute();
			} 		
			
		}
		
		public function setProperty(theName:String, theValue:String):void {
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = "UPDATE data SET " + theName + " = '" + theValue + "'";
			stmt.execute();
		}
		
		public function getProperty(theName:String):String {
			var stmt:SQLStatement = new SQLStatement();
			stmt.sqlConnection = sqlConnection;
			stmt.text = "SELECT * FROM data";
			stmt.execute();
			var result:SQLResult = stmt.getResult();			
			if (result.data) {
				return String(result.data[0][theName]);
			} else {
				return "";
			}
		}
		
		public function clear():void {
			var newQuery:SQLStatement = new SQLStatement();
			newQuery.sqlConnection = sqlConnection;
			newQuery.text = "DROP TABLE data";
			newQuery.execute();
		}
		
	}
}