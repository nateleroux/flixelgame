package  
{
	
	/**
	 * ...
	 * @author Nathan LeRoux
	 */
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.*;
	import org.flixel.*;
	
	public class Level
	{
		
		public var width:int, height:int;
		private var layers:Array;
		
		public function Level(xmlData:ByteArray) 
		{
			var data:XML = new XML(xmlData);
			layers = new Array;
			
			// Lets grab the header information
			width = data.@width;
			height = data.@height;
			
			// Parse the layers
			var index:int = 0;
			var curLayer:XML = data.children()[index++];
			while (curLayer != null)
			{
				layers.push(new TilemapLayer(curLayer.name(), curLayer.@tileset, curLayer.@exportMode, curLayer.text()));
				
				curLayer = data.children()[index++];
			}
			
			// Prepare the layers
			var layer:TilemapLayer;
			if ((layer = getLayer("background")) != null)
				layer.prepare(width, height);
			if ((layer = getLayer("foreground")) != null)
				layer.prepare(width, height);
		}
		
		public function add(background:FlxGroup, foreground:FlxGroup):void
		{
			var layer:TilemapLayer;
			if ((layer = getLayer("background")) != null)
				background.add(layer);
			if ((layer = getLayer("foreground")) != null)
				foreground.add(layer);
		}
		
		public function getLayer(name:String):TilemapLayer
		{
			for each (var layer:TilemapLayer in layers)
			{
				if (layer.Name == name)
					return layer;
			}
			
			return null;
		}
		
	}

}