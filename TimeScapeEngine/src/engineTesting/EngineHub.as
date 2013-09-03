package engineTesting 
{
	import architecture.ApplicationHub;
	import engineTesting.practiceStates.SoundPractice;
	
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
		
		public function soundPractice():void {
			endAll();
			var state:SoundPractice = new SoundPractice();
			run(state);
		}
		
	}

}