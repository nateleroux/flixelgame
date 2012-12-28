package  
{
	
	/**
	 * ...
	 * @author Nathan LeRoux
	 */
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.flixel.*;
	
	public class Entity extends FlxBasic
	{
		
		public var BoundingBox:Rectangle;
		public var Sprite:FlxSprite;
		public var Facing:uint;
		
		public function Entity(BBox:Rectangle, Image:FlxSprite = null) 
		{
			BoundingBox = BBox;
			Sprite = Image;
		}
		
		public function TryMove(level:Level, x:int, y:int, maxCornerSliding:int = 0, ignoreDirection:Boolean = false):Boolean
		{
			// Are we even moving?
			if (x == 0 && y == 0)
				return true;
			
			var newX:int, newY:int;
			var direction:uint = 0;
			newX = Sprite.x + x;
			newY = Sprite.y + y;
			
			// Figure out which direction we are facing...
			if (!ignoreDirection)
			{
				if(x != 0 && y != 0)
				{
					// We are attempting a diagonal move, so first check if our direction is valid here
					if ((x < 0 && Facing == FlxObject.LEFT) || (x > 0 && Facing == FlxObject.RIGHT) ||
						(y < 0 && Facing == FlxObject.UP) || (y > 0 && Facing == FlxObject.DOWN))
						direction = Facing;
					
					if (direction == 0)
					{
						// We are not facing in the direction we are attempting to move, so lets do some basic reasoning here
						// If we are going diagonal, then no matter what, we are going either UP OR DOWN, as well as LEFT OR RIGHT
						// So, if we are facing vertical, take the horizontal direction and vice versa
						// This way, we turn to the direction that would require less spinning if this was IRL
						// With all this extra energy the NPCs can have a pool party
						if ((Facing & (FlxObject.UP | FlxObject.DOWN)) != 0)
						{
							// Take the horizontal direction
							if (x < 0)
								direction = FlxObject.LEFT;
							else
								direction = FlxObject.RIGHT;
						}
						else
						{
							// Take the vertical direction
							if (y < 0)
								direction = FlxObject.UP;
							else
								direction = FlxObject.DOWN;
						}
					}
				}
				else
				{
					// Well this is easy, just set the direction according to the movement
					if (x < 0)
						direction = FlxObject.LEFT;
					else if (x > 0)
						direction = FlxObject.RIGHT;
					else if (y < 0)
						direction = FlxObject.UP;
					else if (y > 0)
						direction = FlxObject.DOWN;
				}
				
				Facing = direction;
			}
			
			// TODO: orient the sprite
			
			// Now lets do the actual movement
			// TODO: consider allowing multiple bounding boxes on an object...
			// We want to move in the facing direction first, this makes sliding on a wall look pretty
			var xM0:int, xM1:int, yM0:int, yM1:int;
			if (Facing == FlxObject.LEFT || Facing == FlxObject.RIGHT)
			{
				xM0 = x;
				yM1 = y;
				yM0 = xM1 = 0;
			}
			else
			{
				xM1 = x;
				yM0 = y;
				yM1 = xM0 = 0;
			}
			
			var moved:Boolean = false;
			if ((xM0 != 0 || yM0 != 0) && CanMove(BoundingBox, level, Sprite.x + xM0, Sprite.y + yM0))
			{
				Sprite.x += xM0;
				Sprite.y += yM0;
				
				moved = true;
			}
			
			if ((xM1 != 0 || yM1 != 0) && CanMove(BoundingBox, level, Sprite.x + xM1, Sprite.y + yM1))
			{
				Sprite.x += xM1;
				Sprite.y += yM1;
				
				moved = true;
			}
			
			// If we have not managed to move, lets attempt to slide around the corner in either direction
			// We only do this if the player is not moving in more than one direction
			if (!moved && maxCornerSliding != 0 && (x == 0 || y == 0))
			{
				var xD:int = 0, yD:int = 0;
				var xChk:int = Sprite.x, yChk:int = Sprite.y;
				var xChkS:int, yChkS:int;
				var slide:int = maxCornerSliding;
				
				if (Facing == FlxObject.LEFT || Facing == FlxObject.RIGHT)
				{
					xChk += x;
					yD = 1;
				}
				else
				{
					xD = 1;
					yChk += y;
				}
				
				xChkS = xChk;
				yChkS = yChk;
				
				for (var i:int = 0; i < 2; i++)
				{
					while (maxCornerSliding > 0)
					{
						// Modify the check values
						xChk += xD;
						yChk += yD;
						
						// Can we move here?
						if (CanMove(BoundingBox, level, xChk, yChk)/* && CanMove(BoundingBox, level, Sprite.x + xD, Sprite.y + yD)*/)
						{
							// We can, so slide in that direction slightly
							Sprite.x += xD;
							Sprite.y += yD;
							
							// If this is the last step before getting to the corner, round it NOW
							if (maxCornerSliding == slide)
							{
								Sprite.x += x;
								Sprite.y += y;
							}
							
							i = 2;
							break;
						}
						
						maxCornerSliding--;
					}
					
					xChk = xChkS;
					yChk = yChkS;
					xD = -xD;
					yD = -yD;
					maxCornerSliding = slide;
				}
			}
			
			return moved;
		}
		
		// Returns true if collision
		public static function TileCollide(bbox:Rectangle, tile:int, x:int, y:int):Boolean
		{
			if (tile == -1)
				return false;
			
			Collision.tempRect0.x = bbox.x - x;
			Collision.tempRect0.y = bbox.y - y;
			Collision.tempRect0.width = bbox.width;
			Collision.tempRect0.height = bbox.height;
			
			var rA:Array, tA:Array;
			rA = Collision.tileBB[tile];
			tA = Collision.tileTri[tile];
			
			for each (var r:Rectangle in rA)
			{
				if (Collision.rectangleTest(Collision.tempRect0, r))
					return true;
			}
			
			var xM:int, yM:int;
			xM = yM = 0;
			if (Collision.tempRect0.x < 0)
				xM = - Collision.tempRect0.x;
			if (Collision.tempRect0.y < 0)
				yM = - Collision.tempRect0.y;
			
			Collision.tempRect0.x += xM;
			Collision.tempRect0.y += yM;
			
			for each (var tri:Array in tA)
			{
				Collision.tempTri00.x = tri[0].x;
				Collision.tempTri00.y = tri[0].y;
				Collision.tempTri01.x = tri[1].x;
				Collision.tempTri01.y = tri[1].y;
				Collision.tempTri02.x = tri[2].x;
				Collision.tempTri02.y = tri[2].y;
				
				Collision.tempTri00.x += xM;
				Collision.tempTri01.x += xM;
				Collision.tempTri02.x += xM;
				Collision.tempTri00.y += yM;
				Collision.tempTri01.y += yM;
				Collision.tempTri02.y += yM;
				
				if (Collision.triangleTest(Collision.tempRect0, Collision.tempTri00, Collision.tempTri01, Collision.tempTri02))
					return true;
			}
			
			return false;
		}
		
		public static function CanMove(bbox:Rectangle, level:Level, x:int, y:int):Boolean
		{
			var map:TilemapLayer = level.getLayer("collision");
			
			// If the level has no collision, we shouldn't go any farther than this
			if (map == null)
				return true;
			
			var r:Rectangle = Collision.tempRect1;
			r.x = bbox.x + x;
			r.y = bbox.y + y;
			r.width = bbox.width;
			r.height = bbox.height;
			
			// What tiles are we intruding upon?
			// Start from the top left, make our way to the right, then go down and repeat
			var tileX:int, tileY:int;
			var ltileX:int, ltileY:int;
			var tileW:int = level.width / Globals.TileWidth;
			tileX = r.x / Globals.TileWidth;
			tileY = r.y / Globals.TileHeight;
			ltileX = (r.x + r.width) / Globals.TileWidth;
			ltileY = (r.y + r.height) / Globals.TileHeight;
			
			var tileXS:int = tileX, tileYS:int = tileY;
			
			r.x = bbox.x + x % 16;
			r.y = bbox.y + y % 16;
			
			while (true)
			{
				// Are we colliding with this tile?
				var tileIdx:int = tileX + tileY * tileW;
				
				if (tileIdx < map.Data.length &&
					TileCollide(r, map.Data[tileX + tileY * tileW], (tileX - tileXS) * 16, (tileY - tileYS) * 16))
					return false;
				
				// No collide, move on to the next tile
				tileX++;
				
				if (tileX > ltileX)
				{
					tileX = tileXS;
					tileY++;
				}
				
				if (tileY > ltileY)
					break;
			}
			
			return true;
		}
		
		override public function update():void 
		{
			if(Sprite != null)
				Sprite.update();
			
			super.update();
		}
		
		override public function draw():void 
		{
			if (Sprite != null)
				Sprite.draw();
			
			super.draw();
		}
		
	}

}