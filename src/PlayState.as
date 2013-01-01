package  
{	
	/**
	 * ...
	 * @author Nathan LeRoux
	 */
	import com.newgrounds.API;
	import com.newgrounds.components.MedalPopup;
	import flash.geom.Rectangle;
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		
		//private var img:FlxSprite;
		private var dude:Entity;
		private var level:Level, transitioningLevel:Level;
		private var backgroundGroup:FlxGroup;
		private var objectGroup:FlxGroup;
		private var foregroundGroup:FlxGroup;
		
		// Transition stuff
		private var scrollingState:int;
		private var scrollingRemain:int;
		private var scrollingDelta:int;
		private var cameraRemain:int;
		private var cameraDelta:int;
		private var scrollingCurrent:int;
		private var scrollingRate:int;
		
		[Embed(source = "../assets/Test Sprite.png")] private var testSprite:Class;
		
		public function PlayState() 
		{
		}
		
		override public function create():void 
		{
			backgroundGroup = new FlxGroup;
			objectGroup = new FlxGroup;
			foregroundGroup = new FlxGroup;
			
			// Setup the level
			level = Globals.LoadLevel("test");
			level.add(backgroundGroup, foregroundGroup);
			
			// Add our dude
			dude = new Entity(new Rectangle(0, 0, 16, 16), new FlxSprite);
			objectGroup.add(dude);
			
			dude.Sprite.x = 400;
			dude.Sprite.y = 16;
			
			add(backgroundGroup);
			add(objectGroup);
			add(foregroundGroup);
			
			scrollingState = 0;
		}
		
		private function checkPlayerForTraversal():void
		{
			// This function contains the logic that checks to see if the player is in contact with a level switch object
			var hasTransitioned:Boolean = false;
			for (var index:int = 0; index < level.transitions.length && !hasTransitioned; index++)
			{
				var transitionObj:LevelEntity = level.transitions[index];
				var nodes:Array = transitionObj.Properties["nodes"];
				for (var nodeIdx:int = 0; nodeIdx < nodes.length && !hasTransitioned; nodeIdx++)
				{
					// Each node is a 1x1 tile rectangle, the point is the upper left corner
					// Test to see if the player has come in contact with the node
					if (Collision.rectangleTestToPoint(dude.BoundingBox, dude.Sprite.x, dude.Sprite.y,
														nodes[nodeIdx], Globals.TileWidth, Globals.TileHeight))
					{
						// Uh oh, looks like we are taking a trip somewhere...
						var mod:int = transitionObj.Properties["destOffsetX"];
						dude.Sprite.x += mod;
						FlxG.camera.scroll.x += mod;
						level.offset.x += mod;
						
						mod = transitionObj.Properties["destOffsetY"];
						dude.Sprite.y += mod;
						FlxG.camera.scroll.y += mod;
						level.offset.y += mod;
						
						transitioningLevel = level;
						level = Globals.LoadLevel(transitionObj.Properties["destination"]);
						level.add(backgroundGroup, foregroundGroup);
						
						// The total scrolling length is TileWidth/Height * 3
						switch(transitionObj.Properties["Transition"])
						{
							case "ScrollUp":
								scrollingState = FlxObject.UP;
								scrollingRemain = Globals.TileHeight * 3;
								dude.Sprite.y = dude.Sprite.y + 16 - (dude.Sprite.y % 16);
								cameraRemain = FlxG.camera.scroll.y -
									Math.min(Math.max(0, (dude.Sprite.y + 8) - scrollingRemain - FlxG.camera.height / 2),
												level.height - FlxG.camera.height);
								break;
							case "ScrollDown":
								scrollingState = FlxObject.DOWN;
								scrollingRemain = Globals.TileHeight * 3;
								dude.Sprite.y = dude.Sprite.y - (dude.Sprite.y % 16) - Globals.TileHeight;
								cameraRemain =
									Math.min(Math.max(0, (dude.Sprite.y + 8) - scrollingRemain - FlxG.camera.height / 2),
												level.height - FlxG.camera.height) - FlxG.camera.scroll.y;
								break;
							case "ScrollLeft":
								scrollingState = FlxObject.LEFT;
								scrollingRemain = Globals.TileWidth * 3;
								dude.Sprite.x = dude.Sprite.x + 16 - (dude.Sprite.x % 16);
								cameraRemain = FlxG.camera.scroll.x -
									Math.min(Math.max(0, (dude.Sprite.x + 8) - scrollingRemain - FlxG.camera.width / 2),
										level.width - FlxG.camera.width);
								break;
							case "ScrollRight":
								scrollingState = FlxObject.RIGHT;
								scrollingRemain = Globals.TileWidth * 3;
								dude.Sprite.x = dude.Sprite.x - (dude.Sprite.x % 16) - Globals.TileWidth;
								cameraRemain =
									Math.min(Math.max(0, (dude.Sprite.x + 8) - scrollingRemain - FlxG.camera.width / 2),
										level.width - FlxG.camera.width) - FlxG.camera.scroll.x;
								break;
						}
						
						//scrollingDelta = scrollingRemain / 4;
						//cameraDelta = cameraRemain / 4;
						// We scroll 48 units, camera scroll 240 units, if going horiz then we camera scroll 320 units
						scrollingDelta = 1;
						cameraDelta = 5;
						scrollingCurrent = 0;
						scrollingRate = 0;
						
						hasTransitioned = true;
					}
				}
			}
		}
		
		private function gameUpdate():void
		{
			// TODO: consider changing walk speed
			var camera:FlxCamera = FlxG.camera;
			var speed:Number = 60 * FlxG.elapsed;
			speed = 1;
			var x:int = 0, y:int = 0;
			
			// Collect input
			if (FlxG.keys.LEFT || FlxG.keys.A)
				x -= speed;
			if (FlxG.keys.RIGHT || FlxG.keys.D)
				x += speed;
			if (FlxG.keys.UP || FlxG.keys.W)
				y -= speed;
			if (FlxG.keys.DOWN || FlxG.keys.S)
				y += speed;
			
			// Attempt to move
			dude.TryMove(level, x, y, 5);
			dude.Sprite.x = Math.min(Math.max(0, dude.Sprite.x), level.width - dude.Sprite.width);
			dude.Sprite.y = Math.min(Math.max(0, dude.Sprite.y), level.height - dude.Sprite.height);
			
			// Debug stuff
			if (FlxG.keys.justPressed("Q"))
				Game.stats.visible = !Game.stats.visible;
			
			// Scroll the camera
			camera.scroll.x = Math.min(Math.max(0, (dude.Sprite.x + 8) - camera.width / 2), level.width - camera.width);
			camera.scroll.y = Math.min(Math.max(0, (dude.Sprite.y + 8) - camera.height / 2), level.height - camera.height);
			
			// Update the water tiles
			Globals.UpdateWaterPos();
			
			// Check to see if we are moving to another area
			checkPlayerForTraversal();
		}
		
		private function scrollUpdate():void
		{
			var camera:FlxCamera = FlxG.camera;
			/*
			var speed:Number = 60 * FlxG.elapsed;
			speed = 1;
			var x:int = 0, y:int = 0;
			
			// Collect input
			if (FlxG.keys.LEFT || FlxG.keys.A)
				x -= speed;
			if (FlxG.keys.RIGHT || FlxG.keys.D)
				x += speed;
			if (FlxG.keys.UP || FlxG.keys.W)
				y -= speed;
			if (FlxG.keys.DOWN || FlxG.keys.S)
				y += speed;
			
			camera.scroll.x += x;
			camera.scroll.y += y;*/
			
			scrollingCurrent++;
			if (scrollingCurrent >= scrollingRate)
			{
				scrollingCurrent = 0;
				
				if (scrollingDelta > scrollingRemain)
					scrollingDelta = scrollingRemain;
				if (cameraDelta > cameraRemain)
					cameraDelta = cameraRemain;
				
				switch(scrollingState)
				{
					case FlxObject.UP:
						dude.Sprite.y -= scrollingDelta;
						camera.scroll.y -= cameraDelta;
						break;
					case FlxObject.DOWN:
						dude.Sprite.y += scrollingDelta;
						camera.scroll.y += cameraDelta;
						break;
					case FlxObject.LEFT:
						dude.Sprite.x -= scrollingDelta;
						camera.scroll.x -= cameraDelta;
						break;
					case FlxObject.RIGHT:
						dude.Sprite.x += scrollingDelta;
						camera.scroll.x += cameraDelta;
						break;
				}
				
				scrollingRemain -= scrollingDelta;
				cameraRemain -= cameraDelta;
				
				if (scrollingRemain == 0 && cameraRemain == 0)
				{
					transitioningLevel.remove(backgroundGroup, foregroundGroup);
					transitioningLevel = null;
					scrollingState = 0;
				}
			}
		}
		
		override public function update():void 
		{
			if (scrollingState == 0)
				gameUpdate();
			else
				scrollUpdate();
			
			super.update();
		}
		
	}

}