package  
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Nathan LeRoux
	 */
	public class LevelEntity 
	{
		
		public var Type:String;
		public var Properties:Dictionary;
		
		public function LevelEntity(Data:XML) 
		{
			/*
			<transition id="0" x="416" y="16" destination="test2" destOffsetX="0" destOffsetY="480" Transition="Snap">
				<node x="400" y="0" />
				<node x="416" y="0" />
				<node x="432" y="0" />
			</transition>
			*/
			
			Type = Data.name();
			Properties = new Dictionary;
			
			if (Data.name() == "transition")
				initTransition(Data);
		}
		
		private function initTransition(Data:XML):void
		{
			Properties["x"] = int(Data.@x);
			Properties["y"] = int(Data.@y);
			Properties["destination"] = String(Data.@destination);
			Properties["destOffsetX"] = int(Data.@destOffsetX);
			Properties["destOffsetY"] = int(Data.@destOffsetY);
			Properties["Transition"] = String(Data.@Transition);
			
			var nodes:Array = new Array;
			var index:int = 0;
			var curNode:XML = Data.children()[index++];
			while (curNode != null)
			{
				nodes.push(loadNode(curNode));
				curNode = Data.children()[index++];
			}
			
			Properties["nodes"] = nodes;
		}
		
		private function loadNode(Node:XML):Point
		{
			return new Point(Node.@x, Node.@y);
		}
		
	}

}