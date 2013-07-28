package architecture.tests 
{
	import architecture.DatabaseRequest;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import interfaces.ISystem;
	import unitTesting.UnitTestVars;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public class TestSystem2 implements ISystem 
	{
		
		public function TestSystem2() 
		{
			
		}
		
		/* INTERFACE interfaces.ISystem */
		
		public function get dataRequest():DatabaseRequest 
		{
			var request:DatabaseRequest = new DatabaseRequest(this)
			request.requestDataFrom(TestDB2, TestDB3)
			return request;
		}
		
		private var _dispatcher:EventDispatcher
		public function get dispatcher():EventDispatcher {
			if (!_dispatcher) {
				_dispatcher = new EventDispatcher;
			}
			return _dispatcher
		}
		
		private var testDB2:TestDB2
		private var testDB3:TestDB3
		
		public function setup(request:DatabaseRequest):void 
		{
			testDB2 = request.getDatabase(TestDB2) as TestDB2
			testDB3 = request.getDatabase(TestDB3) as TestDB3
			trace("setting up test system 2 " + testDB2 + " " + testDB3)
			
			if (testDB2 is TestDB2 && testDB3 is TestDB3) {
				UnitTestVars.inst.setTestVar("appHubTest", "setupTestSystem2", true);
			}
		}
		
		public function startup():void 
		{
			trace("starting up test system 2");
			UnitTestVars.inst.setTestVar("appHubTest", "startupTestSystem2", true);
		}
		
		public function shutdown():void 
		{
			trace("shutting down test system 2");
			UnitTestVars.inst.setTestVar("appHubTest", "shutdownTestSystem2", true);
		}
		
		public function update():void 
		{
			trace("updating test system 2")
			UnitTestVars.inst.setTestVar("appHubTest", "updateTestSystem2", true);
		}
		
	}

}