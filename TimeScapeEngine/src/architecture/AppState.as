package architecture 
{
	import flash.utils.Dictionary;
	import flash.utils.ObjectOutput;
	import interfaces.ISystem;
	/**
	 * ...
	 * @author Saykrd
	 */
	public class AppState 
	{
		
		protected var systems:Vector.<ISystem>
		protected var initialized:Boolean = false
		protected var id:String = "Unnamed System Set"
		protected var group:String
		private var _listenerData:Dictionary
		private var _startMethod:Function
		
		public function AppState(identifier:String) 
		{
			systems = new Vector.<ISystem>
			_listenerData = new Dictionary;
			id = identifier
		}
		
		public function set groupID(s:String):void {
			if (!group) {
				group = s
			} else {
				throw new Error("[AppState] !! Container groupID cannot be set. Already set to " + group)
			}
		}
		
		public function get groupID():String {
			return group
		}
		
		public function get stateID():String {
			return id;
		}
		
		public function get numSystems():int {
			return systems.length;
		}
		
		public function getSystemByIndex(index:int):ISystem {
			if (index >= systems.length) {
				throw new Error("[AppState] !! Index " + index + " is out of range " + systems.length)
			}
			
			return systems[index];
		}
		
		protected function registerSystem(sysClass:Class):ISystem {
			var inst:* = new sysClass
			
			if (inst is ISystem) {
				systems.push(inst)
				return inst
			}
			
			return null
		}
		
		protected function addListener(system:ISystem, eventType:String, command:Function):void {
			var data:Object = _listenerData[system] || { } ;
			var listeners:Vector.<Function> = data[eventType] || new Vector.<Function>
			for each(var cmd:Function in listeners) {
				if (cmd == command) {
					return
				}
			}
			listeners.push(command)
			trace("addign listener to system", system, eventType)
			system.dispatcher.addEventListener(eventType, command, false, 0, false)
			
			if (!data[eventType]) {
				data[eventType] = listeners
			}
			
			if (!_listenerData[system]) {
				_listenerData[system] = data
			}
			
		}
		
		protected function removeListener(system:ISystem, eventType:String, command:Function):void {
			var data:Object = _listenerData[system];
			if (!data) return
			
			var listeners:Vector.<Function> = data[eventType]
			if (!listeners) return
			
			var hasListener:Boolean = false
			for (var i:int = listeners.length - 1; i >= 0 && listeners.length > 0; i--) {
				var cmd:Function = listeners[i];
				if (cmd == command) {
					hasListener = true;
					listeners.splice(i, 1);
					break;
				}
			}
			
			if (hasListener) {
				trace("removing listener from system", system, eventType)
				system.dispatcher.removeEventListener(eventType, command)
			}
		}
		
		
		protected function removeAllListeners():void {
			for (var sys:* in _listenerData) {
				var data:Object = _listenerData[sys];
				for (var eventType:String in data) {
					var listeners:Vector.<Function> = data[eventType].concat();
					for (var i:int = 0; i < listeners.length; i++) {
						var cmd:Function = listeners[i];
						removeListener(sys, eventType, cmd)
					}
				}
			}
		}
		
		public function update():void {
			for (var i:int = 0; i < systems.length; i++) {
				var system:ISystem = systems[i];
				system.update()
			}
		}
		
		public function initialize():void {
			if (!initialized) {
				initialized = true
				for (var i:int = 0; i < systems.length; i++) {
					var system:ISystem = systems[i];
					system.startup()
				}
			}
			
			if (_startMethod != null) {
				_startMethod()
			}
		}
		
		public function setStartCommand(command:Function):void {
			_startMethod = command
		}
		
		public function kill():void {
			removeAllListeners()
			for (var i:int = 0; i < systems.length; i++) {
				var system:ISystem = systems[i];
				system.shutdown()
			}
		}
		
		public function restart():void {
			for (var i:int = 0; i < systems.length; i++) {
				var system:ISystem = systems[i];
				system.shutdown()
				system.startup()
			}
		}
		
	}

}