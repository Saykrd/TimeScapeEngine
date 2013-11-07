package engineTesting.practiceStates 
{
	import architecture.AppState;
	import away3d.containers.View3D;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public class Away3DPractice extends AppState 
	{
		
		private var view:View3D;
		
		public function Away3DPractice(id:String) 
		{
			super(id);
			setStartCommand(start);
		}
		
		public function start():void {
			view = new View3D();
		}
		
		
		
	}

}