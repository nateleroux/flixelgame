package  
{
	/**
	 * ...
	 * @author Nathan LeRoux
	 */
	import flash.display.*;
	
	public final class Globals 
	{
		
		// Tilesets
		[Embed(source = "../assets/tilesets/overworld.png")] public static var tilemapTexture_overworld:Class;
		
		public static var Tilemaps:Array;
		
		public static const TileWidth:int = 16;
		public static const TileHeight:int = 16;
		
		public static const ScreenWidth:int = 320;
		public static const ScreenHeight:int = 240;
		
		public static function Reset():void
		{
			Tilemaps = new Array;
			Tilemaps.push(new TilesetTexture("overworld", ((new tilemapTexture_overworld) as Bitmap).bitmapData));
		}
		
	}

}