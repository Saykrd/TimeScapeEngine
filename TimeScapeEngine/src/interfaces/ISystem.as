package interfaces 
{
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public interface ISystem 
	{
		function startup():void
		function shutdown():void
		function update(elapsedSeconds:int = 0):void
	}
	
}