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
		public var offset:Point;
		public var entities:Array;
		public var transitions:Array;
		private var layers:Array;
		
		public function Level(xmlData:ByteArray) 
		{
			var data:XML = new XML(xmlData);
			layers = new Array;
			
			// Lets grab the header information
			width = data.@width;
			height = data.@height;
			
			offset = new Point;
			
			// Parse the layers
			var index:int = 0;
			var curLayer:XML = data.children()[index++];
			while (curLayer != null)
			{
				if (curLayer.name() == "entities")
				{
					// Entity layer, time to load our entities!
					entities = new Array;
					
					var entIndex:int = 0;
					var curEntity:XML = curLayer.children()[entIndex++];
					while (curEntity != null)
					{
						entities.push(new LevelEntity(curEntity));
						curEntity = curLayer.children()[index++];
					}
				}
				else
					layers.push(new TilemapLayer(curLayer.name(), curLayer.@tileset, curLayer.@exportMode, curLayer.text(), this));
				
				curLayer = data.children()[index++];
			}
			
			// Prepare the layers
			var layer:TilemapLayer;
			if ((layer = getLayer("background")) != null)
				layer.prepare(width, height);
			if ((layer = getLayer("foreground")) != null)
				layer.prepare(width, height);
			
			// Split the entities up into a few different arrays, makes it easier to walk them later
			transitions = entities.filter(
				function(item:LevelEntity, index:Number, a:Array):Boolean {
					return item.Type == "transition";
				});
		}
		
		public function remove(background:FlxGroup, foreground:FlxGroup):void
		{
			var layer:TilemapLayer;
			if ((layer = getLayer("background")) != null)
				background.remove(layer);
			if ((layer = getLayer("foreground")) != null)
				foreground.remove(layer);
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