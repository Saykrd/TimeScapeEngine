package world 
{
	import flash.utils.Dictionary;
	import util.Util;
	/**
	 * ...
	 * @author Saykrd
	 */
	public class World 
	{
		
		public var _scenes:Dictionary
		public var _entities:Dictionary
		
		
		public function World() 
		{
			
		}
		
		public function destroy():void {
			Util.clearDictionary(_scenes)
			Util.clearDictionary(_entities)
			
			_scenes   = null
			_entities = null
		}
		
		public function init():void {
			
		}
		
		public function pause():void {
			
		}
		
		public function resume():void {
			
		}
		
		public function update():void {
			
		}
		
		public function addEntity():void {
			
		}
		
		public function addObject():void {
			
		}
		
		public function newScene():void {
			
		}
		
		public function endScene():void {
			
		}
		
		
		
	}

}