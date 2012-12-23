package 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import com.newgrounds.*;
	import com.newgrounds.components.*;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Nathan LeRoux
	 */
	public class Preloader extends MovieClip 
	{
		
		// Preloader background image
		[Embed(source="../assets/preload_bg.png")] private var preloaderBackground:Class;
		
		public function Preloader() 
		{
			// Setup our background image
			var backgroundImg:Bitmap = new preloaderBackground;
			addChild(backgroundImg);
			
			// Hook up the newgrounds api
			var apiConnector:APIConnector = new APIConnector;
			apiConnector.className = "Game";
			apiConnector.apiId = NG_APIInfo.ApiId;
			apiConnector.encryptionKey = NG_APIInfo.EncryptionKey;
			addChild(apiConnector);
			
			// Center the preloader
			if (stage)
			{
				apiConnector.x = (stage.stageWidth - apiConnector.width) / 2;
				apiConnector.y = (stage.stageHeight - apiConnector.height) / 2;
				
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
			}
		}
		
	}
	
}