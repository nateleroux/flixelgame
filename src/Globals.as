package  
{
	/**
	 * ...
	 * @author Nathan LeRoux
	 */
	import flash.display.*;
	import flash.utils.Dictionary;
	
	public final class Globals 
	{
		
		// Tilesets
		[Embed(source = "../assets/tilesets/overworld.png")] public static var tilemapTexture_overworld:Class;
		
		public static var Tilemaps:Array;
		public static var Levels:Dictionary;
		
		public static const TileWidth:int = 16;
		public static const TileHeight:int = 16;
		
		public static const ScreenWidth:int = 320;
		public static const ScreenHeight:int = 240;
		
		// Level list
		[Embed(source = "../assets/levels/test.oel", mimeType = "application/octet-stream")] private static var lvlTest:Class;
		[Embed(source = "../assets/levels/test2.oel", mimeType = "application/octet-stream")] private static var lvlTest2:Class;
		
		public static function Reset():void
		{
			// Setup the tilemaps
			Tilemaps = new Array;
			Tilemaps.push(new TilesetTexture("overworld", ((new tilemapTexture_overworld) as Bitmap).bitmapData));
			
			// Now setup the levels
			// Any time a new level is added, it must be added here
			Levels = new Dictionary;
			Levels["test"] = new lvlTest;
			Levels["test2"] = new lvlTest2;
		}
		
		public static function LoadLevel(Name:String):Level
		{
			return new Level(Levels[Name]);
		}
		
	}

}