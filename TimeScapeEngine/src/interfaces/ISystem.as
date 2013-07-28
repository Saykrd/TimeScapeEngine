package interfaces 
{
	import architecture.DatabaseRequest;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public interface ISystem
	{
		function setup(request:DatabaseRequest):void
		function startup():void
		function shutdown():void
		function update():void
		function get dataRequest():DatabaseRequest
		
	}
	
}