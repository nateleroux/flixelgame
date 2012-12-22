package  
{
	/**
	 * ...
	 * @author Nathan LeRoux
	 */
	public final class Globals 
	{
		
		public static var NG_APIConnectionState:int;
		
		public static function Reset()
		{
			NG_APIConnectionState = APIConnectionState.WAITING;
		}
		
	}

}