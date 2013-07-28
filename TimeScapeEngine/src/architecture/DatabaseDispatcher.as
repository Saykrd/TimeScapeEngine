package architecture 
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import interfaces.ITransient;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public class DatabaseDispatcher extends EventDispatcher implements ITransient
	{
		
		private var _callRegistry:Dictionary;
		private var _classID:String = "none"
		
		public function DatabaseDispatcher()
		{
			_callRegistry = new Dictionary;
		}
		
		public function set classID(id:String):void {
			_classID = id
		}
		
		public function get classID():String {
			return _classID
		}
		
		public function destroy():void {
			removeAllListeners();
			_callRegistry = null;
		}
		
		
		public function removeListenersOfType(type:String):void {
			var listeners:Vector.<Function> = _callRegistry[type];
			
			if (listeners) {
				for (var i:int = listeners.length - 1; i >= 0; i--) {
					var l:Function = listeners[i];
					this.removeEventListener(type, l);
				}
			}
		}
		
		public function removeAllListeners():void {
			for (var type:String in _callRegistry) {
				removeListenersOfType(type)
				delete _callRegistry[type]
			}
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void {
			if (!type || !listener) {
				throw new Error("[DataBaseDispatcher] !! Cannot add null listener or null type")
			}
			
			if (!_callRegistry[type]) {
				_callRegistry[type] = new Vector.<Function>;
			}
			
			var listeners:Vector.<Function> = _callRegistry[type];
			var hasListener:Boolean = false
			for each(var l:Function in listeners) {
				if (l == listener) {
					hasListener = true
					break
				}
			}
			
			if (!hasListener) {
				listeners.push(listener)
			}
			
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			var listeners:Vector.<Function> = _callRegistry[type]
			
			if (listeners) {
				for (var i:int = listeners.length - 1; i >= 0; i--) {
					var l:Function = listeners[i];
					
					if (l == listener) {
						listeners.splice(i, 1)
						break;
					}
				}
			}
			
			super.removeEventListener(type, listener, useCapture)
		}
		
	}

}