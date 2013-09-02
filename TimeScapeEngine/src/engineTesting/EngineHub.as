package engineTesting 
{
	import architecture.ApplicationHub;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public class EngineHub extends ApplicationHub 
	{
		
		public function EngineHub() 
		{
		}
		
		public function startScene():void {
			endAll()
			var state:WorldState = new WorldState()
			run(state)
		}
		
	}

}