package 
{
	import architecture.ApplicationHub;
	import com.flashdynamix.utils.SWFProfiler;
	import engineTesting.EngineHub;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import interfaces.ISystem;
	import net.hires.debug.Stats;
	import unitTesting.UnitTestConsole;
	import util.Time;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public class Main extends Sprite 
	{
		
		public static var STAGE:Stage
		
		private var _appHub:ApplicationHub
		
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
			STAGE = stage
			addChild(new Stats);
			var hub:EngineHub = new EngineHub
			hub.soundPractice();
			_appHub = hub
			
			//UnitTestConsole.inst.startup()
			//UnitTestConsole.inst.runAllTests()
			stage.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:Event):void {
			Time.updateTime();
			
			if (_appHub) {
				_appHub.update()
			}
			//trace(Time.deltaTime, Time.epochTime, getTimer());
		}
		
	}
	
}