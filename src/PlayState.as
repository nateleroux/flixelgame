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
		private var level:Level;
		private var backgroundGroup:FlxGroup;
		private var objectGroup:FlxGroup;
		private var foregroundGroup:FlxGroup;
		[Embed(source = "../assets/levels/test.oel", mimeType = "application/octet-stream")] private var testLevel:Class;
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
			level = new Level(new testLevel);
			level.add(backgroundGroup, foregroundGroup);
			
			// Add our dude
			dude = new Entity(new Rectangle(0, 0, 16, 16), new FlxSprite);
			objectGroup.add(dude);
			
			add(backgroundGroup);
			add(objectGroup);
			add(foregroundGroup);
		}
		
		override public function update():void 
		{
			var camera:FlxCamera = FlxG.camera;
			var speed:Number = 60 * FlxG.elapsed;
			speed = 1;
			var x:int = 0, y:int = 0;
		
			if (FlxG.keys.LEFT)
				x -= speed;
			if (FlxG.keys.RIGHT)
				x += speed;
			if (FlxG.keys.UP)
				y -= speed;
			if (FlxG.keys.DOWN)
				y += speed;
			
			dude.TryMove(level, x, y, 5);
			
			if (FlxG.keys.justPressed("D"))
				Game.stats.visible = !Game.stats.visible;
			
			camera.scroll.x = Math.min(Math.max(0, (dude.Sprite.x + 8) - camera.width / 2), level.width - camera.width);
			camera.scroll.y = Math.min(Math.max(0, (dude.Sprite.y + 8) - camera.height / 2), level.height - camera.height);
			
			super.update();
		}
		
	}

}