package engineTesting 
{
	import architecture.AppState;
	import util.Random;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public class WorldState extends AppState 
	{
		public function WorldState(id:String = "DEFAULT") 
		{
			super(id)
			setStartCommand(start)
		}
		
		public function start():void {
			trace("STARTING")
		}
		
		
		override public function update():void {
			super.update();
		}
		
	}

}