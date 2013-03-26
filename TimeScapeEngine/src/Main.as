package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import util.Time;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			Time.start()
			stage.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:Event):void {
			Time.updateTime();
			
			trace(Time.deltaTime, Time.epochTime, getTimer());
		}
		
	}
	
}