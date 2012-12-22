package 
{
	/**
	 * ...
	 * @author Nathan LeRoux
	 */
	import com.newgrounds.components.*;
	import com.newgrounds.*;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			addChild(new MedalPopup);
			addChild(new Game);
		}

	}

}