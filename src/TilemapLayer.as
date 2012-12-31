package  
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.*;
	/**
	 * ...
	 * @author Nathan LeRoux
	 */
	public class TilemapLayer extends FlxBasic
	{
		
		public var Parent:Level;
		public var Name:String;
		public var Tileset:String;
		public var ExportMode:String;
		public var Data:Array;
		public var Texture:TilesetTexture;
		
		// Render stuff
		private var dirty:Boolean;
		private var pixelPoint:Point;
		private var pixelRect:Rectangle;
		private var pixels:BitmapData;
		private var sourceRect:Rectangle;
		private var sourceRect2:Rectangle;
		private var destRect:Rectangle;
		private var clipRect:Rectangle;
		private var width:int;
		private var height:int;
		private var point:Point;
		private var point2:Point;
		private var point3:Point;
		
		// Animated water
		private var waterOffset:Point;
		private var waterCurrent:int;
		private var waterGoal:int;
		private var waterTile:int;
		
		public function TilemapLayer(Name:String, Tileset:String, ExportMode:String, Data:String, Parent:Level) 
		{
			this.Name = Name;
			this.Tileset = Tileset;
			this.ExportMode = ExportMode;
			this.Texture = null;
			this.Parent = Parent;
			
			dirty = true;
			pixelPoint = new Point;
			pixelRect = new Rectangle;
			pixels = null;
			sourceRect = new Rectangle;
			sourceRect2 = new Rectangle;
			destRect = new Rectangle;
			clipRect = new Rectangle;
			point = new Point;
			point2 = new Point;
			point3 = new Point;
			
			waterOffset = new Point;
			waterGoal = 30;
			
			// TODO: change this based on map name, possibly to an array of water tiles
			waterTile = 5;
			
			for each (var t:TilesetTexture in Globals.Tilemaps)
			{
				if (t.Name == Tileset)
				{
					this.Texture = t;
					break;
				}
			}
			
			this.Data = new Array;
			var ar:Array = Data.split(/,|\n/);
			for each (var dat:String in ar)
				this.Data.push(parseInt(dat));
		}
		
		public function prepare(w:int, h:int):void
		{
			pixels = new BitmapData(Globals.ScreenWidth + Globals.TileWidth * 4, Globals.ScreenHeight + Globals.TileHeight * 4);
			pixelRect = new Rectangle(0, 0, pixels.width, pixels.height);
			
			width = w;
			height = h;
		}
		
		override public function update():void 
		{
			// Update function! yay
			// Lets check which tileset we are, water only exists on 'overworld'
			if (Tileset == "overworld")
			{
				// Well, we are the overworld, so lets animate some water
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
						waterOffset.x += moveX;
						waterOffset.y += moveY;
						
						waterOffset.x = waterOffset.x % Globals.TileWidth;
						waterOffset.y = waterOffset.y % Globals.TileHeight;
						
						while (waterOffset.x < 0)
							waterOffset.x += Globals.TileWidth;
						while (waterOffset.y < 0)
							waterOffset.y += Globals.TileHeight;
						
						dirty = true;
					}
				}
			}
			
			super.update();
		}
		
		private function render(buffer:BitmapData, location:Point, camera:FlxCamera):void
		{
			// Clear transparent black
			buffer.fillRect(buffer.rect, 0x00000000);
			
			var x:int = 0, y:int = 0;
			var w:int = buffer.width, h:int = buffer.height;
			var tileX:int;
			var tileY:int = location.y / Globals.TileHeight;
			var tileW:int = width / Globals.TileWidth;
			var tileH:int = height / Globals.TileHeight;
			
			while (y < h)
			{
				x = 0;
				tileX = location.x / Globals.TileWidth;
				
				for (; x < w; tileX++, x += Globals.TileWidth)
				{
					if (tileX < 0 || tileY < 0)
						continue;
					if (tileX >= tileW || tileY >= tileH)
						continue;
					
					var tile:int = Data[tileX + tileY * tileW];
					if (tile != -1)
					{
						if (tile == waterTile && (waterOffset.x != 0 || waterOffset.y != 0))
						{
							// Draw the tile onto the buffer using the clipDraw helper function
							clipRect.x = x;
							clipRect.y = y;
							clipRect.width = 16;
							clipRect.height = 16;
							
							sourceRect.x = int(tile % Texture.TilesWidth) * Globals.TileWidth;
							sourceRect.y = int(tile / Texture.TilesWidth) * Globals.TileHeight;
							sourceRect.width = Globals.TileWidth;
							sourceRect.height = Globals.TileHeight;
							
							point.y = y;
							
							// Top left
							point.x = x - Globals.TileWidth + waterOffset.x;
							point.y = y - Globals.TileHeight + waterOffset.y;
							clipDraw(buffer, clipRect, Texture.Texture, sourceRect, point);
							
							// Top right
							point.x = x + waterOffset.x;
							point.y = y - Globals.TileHeight + waterOffset.y;
							clipDraw(buffer, clipRect, Texture.Texture, sourceRect, point);
							
							// Bottom left
							point.x = x - Globals.TileWidth + waterOffset.x;
							point.y = y + waterOffset.y;
							clipDraw(buffer, clipRect, Texture.Texture, sourceRect, point);
							
							// Bottom right
							point.x = x + waterOffset.x;
							point.y = y + waterOffset.y;
							clipDraw(buffer, clipRect, Texture.Texture, sourceRect, point);
						}
						else
						{
							sourceRect.x = int(tile % Texture.TilesWidth) * Globals.TileWidth;
							sourceRect.y = int(tile / Texture.TilesWidth) * Globals.TileHeight;
							sourceRect.width = Globals.TileWidth;
							sourceRect.height = Globals.TileHeight;
							point.x = x;
							point.y = y;
							point2.x = sourceRect.x;
							point2.y = sourceRect.y;
							
							buffer.copyPixels(Texture.Texture, sourceRect, point, Texture.Texture, point2, true);
						}
					}
				}
				
				tileY++;
				y += Globals.TileHeight;
			}
		}
		
		// This function is super handy
		private function clipDraw(buffer:BitmapData, clipRect:Rectangle, texture:BitmapData, sourceRect:Rectangle, dest:Point):void
		{
			// Lets build our rectangles
			destRect.x = dest.x;
			destRect.y = dest.y;
			destRect.width = sourceRect.width;
			destRect.height = sourceRect.height;
			
			// Cull out any dest rectangles that completely miss the clip rect
			if (destRect.right < clipRect.left || destRect.left > clipRect.right ||
				destRect.top > clipRect.bottom || destRect.bottom < clipRect.top)
				return;
			
			sourceRect2.copyFrom(sourceRect);
			
			var diff:int = 0;
			
			if (destRect.x < clipRect.x)
			{
				diff = clipRect.x - destRect.x;
				
				destRect.x = clipRect.x;
				destRect.width -= diff;
				
				sourceRect2.x += diff;
				sourceRect2.width -= diff;
			}
			
			if (destRect.y < clipRect.y)
			{
				diff = clipRect.y - destRect.y;
				
				destRect.y = clipRect.y;
				destRect.height -= diff;
				
				sourceRect2.y += diff;
				sourceRect2.height -= diff;
			}
			
			if (destRect.right > clipRect.right)
			{
				diff = destRect.right - clipRect.right;
				
				destRect.width -= diff;
				sourceRect2.width -= diff;
			}
			
			if (destRect.bottom > clipRect.bottom)
			{
				diff = destRect.bottom - clipRect.bottom;
				
				destRect.height -= diff;
				sourceRect2.height -= diff;
			}
			
			// And now we draw
			point3.x = destRect.x;
			point3.y = destRect.y;
			point2.x = sourceRect2.x;
			point2.y = sourceRect2.y;
			
			buffer.copyPixels(texture, sourceRect2, point3, texture, point2, true);
		}
		
		override public function draw():void 
		{
			var cameras:Array = FlxG.cameras;
			var camera:FlxCamera;
			var i:int = 0;
			var l:int = cameras.length;
			
			while (i < l)
			{
				camera = cameras[i];
				
				if (!dirty)
					dirty = (camera.scroll.x < pixelPoint.x) || (camera.scroll.y < pixelPoint.y) ||
							(camera.scroll.x + camera.width > pixelPoint.x + pixelRect.width) ||
							(camera.scroll.y + camera.height > pixelPoint.y + pixelRect.height);
				
				if (dirty)
				{
					dirty = false;
					
					pixelPoint.x = camera.scroll.x - Globals.TileWidth;
					pixelPoint.y = camera.scroll.y - Globals.TileHeight;
					
					pixelPoint.x -= pixelPoint.x % Globals.TileWidth;
					pixelPoint.y -= pixelPoint.y % Globals.TileHeight;
					
					// re-draw the tiles
					render(pixels, pixelPoint, camera);
				}
				
				sourceRect.x = camera.scroll.x - pixelPoint.x;
				sourceRect.y = camera.scroll.y - pixelPoint.y;
				sourceRect.width = camera.width;
				sourceRect.height = camera.height;
				
				point.x = Parent.offset.x;
				point.y = Parent.offset.y;
				
				point2.x = sourceRect.x;
				point2.y = sourceRect.y;
				
				camera.buffer.copyPixels(pixels, sourceRect, point, pixels, point2, true);
				
				i++;
			}
			
			super.draw();
		}
		
	}

}