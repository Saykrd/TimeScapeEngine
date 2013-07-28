package architecture 
{
	import interfaces.ISystem;
	/**
	 * ...
	 * @author Saykrd
	 */
	public class SystemContainer 
	{
		
		protected var systems:Vector.<ISystem>
		protected var initialized:Boolean = false
		protected var id:String = "Unnamed System Set"
		protected var group:String
		
		public function SystemContainer(identifier:String) 
		{
			systems = new Vector.<ISystem>
			id = identifier
		}
		
		public function set groupID(s:String):void {
			if (!group) {
				group = s
			} else {
				throw new Error("[SystemContainer] !! Container groupID cannot be set. Already set to " + group)
			}
		}
		
		public function get groupID():String {
			return group
		}
		
		public function get containerID():String {
			return id;
		}
		
		public function get numSystems():int {
			return systems.length;
		}
		
		public function getSystemByIndex(index:int):ISystem {
			if (index >= systems.length) {
				throw new Error("[SystemContainer] !! Index " + index + " is out of range " + systems.length)
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
		}
		
		
		public function kill():void {
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