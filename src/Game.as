package  
{
	/**
	 * ...
	 * @author Nathan LeRoux
	 */
	import org.flixel.FlxGame;
	import com.newgrounds.*;
	import com.newgrounds.components.*;
	
	public class Game extends FlxGame 
	{
		
		public var medalPopup:MedalPopup;
		
		public function Game() 
		{
			super(320, 240, MenuState, 2, 60, 60);
			
			// Setup the newgrounds medal popup
			medalPopup = new MedalPopup;
			medalPopup.x = 100;
			medalPopup.y = 480 - 100;
			medalPopup.alwaysOnTop = "true";
			
			addChild(medalPopup);
		}
		
	}

}