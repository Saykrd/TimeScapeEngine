package unitTesting 
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Saykrd
	 */
	public class UnitTest extends EventDispatcher
	{
		
		private var _tasks:Array
		private var _failed:Boolean
		private var _result:UnitTestResult
		
		protected var _testID:String
		
		
		public function UnitTest(id:String) 
		{
			_tasks = [];
			_result = new UnitTestResult;
			_testID = id || getQualifiedClassName(this)
			
		}
		
		public function get testID():String {
			return _testID;
		}
		
		public function runTest():void {
			trace("[UnitTest] ================================")
			trace("[UnitTest] Running test: " + _testID)
			for (var i:int = 0; i < _tasks.length; i++) {
				var data:Object = _tasks[i]
				var task:Function = data.task
				var id:String = data.taskID
				var remarks:Array
				
				trace("[UnitTest] Executing task: " + id + "...")
				_result.refresh()
				task()
				
				if (!_result.passed) {
					failTest(id)
					remarks = _result.remarks
					trace("[UnitTest] Task failed for the following reasons:")
					for (var j:int = 0; j < remarks.length; j++) {
						var rsn:String = remarks[j]
						trace("[UnitTest] Reason " + (j + 1) + ": " + rsn);
					}
				}
				
				if (!_failed) {
					trace("[UnitTest] " + id + " has passed!")
				} else {
					break;
				}
			}
			
			if (!_failed) {
				passTest()
			}
			complete()
		}
		
		protected function addTask(taskID:String, task:Function):void {
			_tasks.push( { taskID : taskID, task : task } )
		}
		
		protected function pass():void {
			_result.pass()
		}
		
		protected function fail(reason:String):void {
			_result.fail(reason)
		}
		
		private function complete():void {
			trace("[UnitTest] Unit Test " + testID + " has completed")
			var event:UnitTestEvent = new UnitTestEvent(UnitTestEvent.TEST_COMPLETE, testID)
			dispatchEvent(event)
		}
		
		private function passTest():void {
			trace("[UnitTest] SUCCESS!! Passed unit Test " + testID + " with flying colors. Good job.")
			var event:UnitTestEvent = new UnitTestEvent(UnitTestEvent.TEST_SUCCESS, testID)
			dispatchEvent(event)
		}
		
		private function failTest(taskID:String):void {
			_failed = true
			trace("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
			trace("[UnitTest] !! Unit Test " + testID + " has failed! Failed at task: " + taskID)
			//trace("[UnitTest] Fail Reason: " + reason)
			var event:UnitTestEvent = new UnitTestEvent(UnitTestEvent.TEST_FAILED, testID, taskID)
			dispatchEvent(event)
		}
		
	}

}