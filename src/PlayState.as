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
						
						mod = transitionObj.Properties["destOffsetY"];
						dude.Sprite.y += mod;
						FlxG.camera.scroll.y += mod;
						
						level.remove(backgroundGroup, foregroundGroup);
						level = Globals.LoadLevel(transitionObj.Properties["destination"]);
						level.add(backgroundGroup, foregroundGroup);
						
						// TODO: Scrolling effect
						// For now, just snap them one tile in the direction they are headed
						switch(transitionObj.Properties["Transition"])
						{
							case "ScrollUp":
								dude.Sprite.y -= Globals.TileHeight * 3;
								FlxG.camera.scroll.y -= Globals.TileHeight * 3;
								break;
							case "ScrollDown":
								dude.Sprite.y += Globals.TileHeight * 3;
								FlxG.camera.scroll.y += Globals.TileHeight * 3;
								break;
							case "ScrollLeft":
								dude.Sprite.x -= Globals.TileHeight * 3;
								FlxG.camera.scroll.x -= Globals.TileHeight * 3;
								break;
							case "ScrollRight":
								dude.Sprite.x += Globals.TileHeight * 3;
								FlxG.camera.scroll.x += Globals.TileHeight * 3;
								break;
						}
						
						hasTransitioned = true;
					}
				}
			}
		}
		
		override public function update():void 
		{
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
				
			// Check to see if we are moving to another area
			checkPlayerForTraversal();
			
			// Scroll the camera
			camera.scroll.x = Math.min(Math.max(0, (dude.Sprite.x + 8) - camera.width / 2), level.width - camera.width);
			camera.scroll.y = Math.min(Math.max(0, (dude.Sprite.y + 8) - camera.height / 2), level.height - camera.height);
			
			super.update();
		}
		
	}

}