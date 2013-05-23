package interfaces 
{
	import architecture.DataHandlerRequest;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public interface ISystem extends IEventDispatcher
	{
		function create(request:DataHandlerRequest):void
		function startup():void
		function shutdown():void
		function update():void
		function get dataRequest():DataHandlerRequest
		
	}
	
}