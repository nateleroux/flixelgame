package  
{	
	/**
	 * ...
	 * @author Nathan LeRoux
	 */
	import com.newgrounds.API;
	import com.newgrounds.components.MedalPopup;
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		
		private var img:FlxSprite;
		private var level:Level;
		[Embed(source = "../assets/levels/test.oel", mimeType = "application/octet-stream")] private var testLevel:Class;
		
		public function PlayState() 
		{
		}
		
		override public function create():void 
		{
			//add(new FlxSprite);
			level = new Level(new testLevel);
			add(level);
			img = new FlxSprite;
			add(img);
		}
		
		override public function update():void 
		{
			var camera:FlxCamera = FlxG.camera;
			var speed:Number = 60 * FlxG.elapsed;
			speed = 1;
			//speed = 1;
			/*if (FlxG.keys.LEFT)
				camera.scroll.x -= speed;
			if (FlxG.keys.RIGHT)
				camera.scroll.x += speed;
			if (FlxG.keys.UP)
				camera.scroll.y -= speed;
			if (FlxG.keys.DOWN)
				camera.scroll.y += speed;/**//**/
			
			if (FlxG.keys.LEFT)
				img.x -= speed;
			if (FlxG.keys.RIGHT)
				img.x += speed;
			if (FlxG.keys.UP)
				img.y -= speed;
			if (FlxG.keys.DOWN)
				img.y += speed;/**/
			
			img.x = int(img.x);
			img.y = int(img.y);
			
			super.update();
		}
		
	}

}