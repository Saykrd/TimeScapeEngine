package engineTesting 
{
	import architecture.ApplicationHub;
	import engineTesting.practiceStates.Away3DPractice;
	import engineTesting.practiceStates.AwayPhysicsTest;
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
		
		public function away3DPractice():void {
			endAll();
			var state:Away3DPractice = new Away3DPractice("away3d");
			run(state);
		}
		
		public function awayPhysicsTest():void {
			endAll();
			var state:AwayPhysicsTest = new AwayPhysicsTest();
			run(state);
		}
		
	}

}