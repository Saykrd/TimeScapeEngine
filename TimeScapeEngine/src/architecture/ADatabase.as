package architecture 
{
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	import interfaces.IRecyclable;
	import interfaces.ITransient;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public class ADatabase implements IRecyclable, ITransient
	{
		
		protected var group:String;
		protected var dispatcher:DatabaseDispatcher
		public function ADatabase() 
		{
			dispatcher = new DatabaseDispatcher
			dispatcher.classID = getQualifiedClassName(this)
		}
		
		public function set groupID(s:String):void {
			if (!group) {
				group = s
			} else {
				throw new Error("[ADataHandler] !! Handler groupID cannot be set. Already set to " + group)
			}
		}
		
		public function get groupID():String {
			return group
		}
		
		public function get dataDispatcher():DatabaseDispatcher {
			return dispatcher
		}
		
		public function addEventListener(type:String, listener:Function):void {
			dispatcher.addEventListener(type, listener)
		}
		
		public function removeEventListener(type:String, listener:Function):void {
			dispatcher.removeEventListener(type, listener)
		}
		
		public function destroy():void {
			dispatcher.destroy()
			
			dispatcher = null
		}
		
		public function init():void {
			// Overriden Method
		}
		
		public function clean():void {
			// Overriden Method
		}
		
		public function restart():void {
			// Overriden Method
		}
		
	}

}