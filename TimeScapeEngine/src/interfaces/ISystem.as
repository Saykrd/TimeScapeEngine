package interfaces 
{
	import architecture.DatabaseRequest;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public interface ISystem extends IAutomatable
	{
		function setup(request:DatabaseRequest):void
		function startup():void
		function shutdown():void
		function get dataRequest():DatabaseRequest
		function get dispatcher():EventDispatcher
	}
	
}