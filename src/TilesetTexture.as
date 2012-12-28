package  
{

	/**
	 * ...
	 * @author Nathan LeRoux
	 */
	import flash.display.BitmapData;
	
	public class TilesetTexture 
	{
		
		public var Name:String;
		public var Texture:BitmapData;
		public var TilesWidth:int;
		
		public function TilesetTexture(Name:String, Texture:BitmapData) 
		{
			this.Name = Name;
			this.Texture = Texture;
			this.TilesWidth = this.Texture.width / Globals.TileWidth;
		}
		
	}

}