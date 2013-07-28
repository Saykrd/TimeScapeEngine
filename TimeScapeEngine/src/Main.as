package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import interfaces.ISystem;
	import unitTesting.UnitTestConsole;
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
			UnitTestConsole.inst.startup()
			UnitTestConsole.inst.runAllTests()
			stage.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function test():void {
			trace("boo")
		}
		
		private function onFrame(e:Event):void {
			Time.updateTime();
			
			//trace(Time.deltaTime, Time.epochTime, getTimer());
		}
		
	}
	
}