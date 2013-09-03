package engineTesting 
{
	import architecture.AppState;
	import away3d.events.MouseEvent3D;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.SampleDataEvent;
	import flash.media.Sound;
	import flash.utils.ByteArray;
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
		
		private var _sound:Sound;
		
		public function start():void {
			trace("STARTING")
		}
		
		override public function update():void {
			super.update();
		}
		
	}

}