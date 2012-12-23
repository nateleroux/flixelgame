package  
{
	/**
	 * ...
	 * @author Nathan LeRoux
	 */
	 import flash.utils.ByteArray;
	 import org.flixel.*;
	 
	public class MenuState extends FlxState
	{
		
		private var startButton:FlxButton;
		
		private var morespace:ByteArray;
		
		public function MenuState() 
		{
		}
		
		override public function create():void 
		{
			// TODO: make a better menu
			FlxG.mouse.show();
			startButton = new FlxButton(120, 90, "Start Game", startGame);
			add(startButton);
		}
		
		private function startGame():void
		{
			FlxG.mouse.hide();
			FlxG.switchState(new PlayState);
		}
		
	}

}