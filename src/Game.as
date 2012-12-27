package  
{
	/**
	 * ...
	 * @author Nathan LeRoux
	 */
	import net.hires.debug.Stats;
	import org.flixel.FlxG;
	import org.flixel.FlxGame;
	import com.newgrounds.*;
	import com.newgrounds.components.*;
	
	public class Game extends FlxGame 
	{
		
		public var medalPopup:MedalPopup;
		public static var stats:Stats;
		
		public function Game() 
		{
			var firstState:Class;
			CONFIG::release {
				firstState = MenuState;
			}
			CONFIG::debug {
				firstState = PlayState;
			}
			
			super(320, 240, firstState, 2, 60, 60);
			
			// Setup the newgrounds medal popup
			medalPopup = new MedalPopup;
			medalPopup.x = 100;
			medalPopup.y = 480 - 100;
			medalPopup.alwaysOnTop = "true";
			
			addChild(medalPopup);
			
			// Reset the globals
			Globals.Reset();
			
			// Initialize the collision class
			Collision.init();
			
			stats = new Stats;
			stats.visible = false;
			addChild(stats);
			
			forceDebugger = true;
		}
		
	}

}