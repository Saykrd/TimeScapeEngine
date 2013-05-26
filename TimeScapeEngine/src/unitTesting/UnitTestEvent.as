package unitTesting 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public class UnitTestEvent extends Event 
	{
		
		public static const TEST_FAILED:String = "unitTestFailed"
		public static const TEST_SUCCESS:String = "unitTestSuccess"
		public static const TEST_COMPLETE:String = "unitTestComplete"
		
		private var _testID:String
		private var _taskID:String
		
		public function UnitTestEvent(type:String, testID:String, taskID:String = "", bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			_testID = testID;
			_taskID = taskID;
			super(type, bubbles, cancelable);
		}
		
		public function get testID():String {
			return _testID
		}
		
		public function get taskID():String {
			return _taskID
		}
		
	}

}