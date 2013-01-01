package  
{
	/**
	 * ...
	 * @author Nathan LeRoux
	 */
	import flash.display.*;
	import flash.utils.Dictionary;
	import flash.geom.Point;
	
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
		
		// Animated water
		public static var WaterOffset:Point;
		public static var WaterDirty:Boolean;
		private static var waterCurrent:int;
		private static var waterGoal:int;
		private static var waterTile:int;
		
		// Level list
		[Embed(source = "../assets/levels/test.oel", mimeType = "application/octet-stream")] private static var lvlTest:Class;
		[Embed(source = "../assets/levels/test2.oel", mimeType = "application/octet-stream")] private static var lvlTest2:Class;
		[Embed(source = "../assets/levels/test3.oel", mimeType = "application/octet-stream")] private static var lvlTest3:Class;
		
		public static function Reset():void
		{
			// Setup water animation
			WaterDirty = false;
			WaterOffset = new Point;
			waterGoal = 30;
			
			// Setup the tilemaps
			Tilemaps = new Array;
			Tilemaps.push(new TilesetTexture("overworld", ((new tilemapTexture_overworld) as Bitmap).bitmapData));
			
			// Now setup the levels
			// Any time a new level is added, it must be added here
			Levels = new Dictionary;
			Levels["test"] = new lvlTest;
			Levels["test2"] = new lvlTest2;
			Levels["test3"] = new lvlTest3;
		}
		
		public static function UpdateWaterPos():void
		{
			WaterDirty = false;
			waterCurrent++;
			
			if (waterCurrent >= waterGoal)
			{
				waterCurrent = 0;
				
				// Lets move by a random amount between -2 and 2 pixels! (yes, that means it is lerp time)
				var moveX:int, moveY:int;
				moveX = (Math.random() * 4) - 2;
				moveY = (Math.random() * 4) - 2;
				
				if (moveX != 0 || moveY != 0)
				{
					WaterOffset.x += moveX;
					WaterOffset.y += moveY;
					
					WaterOffset.x = WaterOffset.x % Globals.TileWidth;
					WaterOffset.y = WaterOffset.y % Globals.TileHeight;
					
					while (WaterOffset.x < 0)
						WaterOffset.x += Globals.TileWidth;
					while (WaterOffset.y < 0)
						WaterOffset.y += Globals.TileHeight;
					
					WaterDirty = true;
				}
			}
		}
		
		public static function LoadLevel(Name:String):Level
		{
			return new Level(Levels[Name]);
		}
		
	}

}