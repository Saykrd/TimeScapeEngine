package architecture.tests 
{
	import architecture.DatabaseRequest;
	import flash.events.Event;
	import interfaces.ISystem;
	import unitTesting.UnitTestVars;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public class TestSystem1 implements ISystem 
	{
		
		public function TestSystem1() 
		{
			
		}
		
		/* INTERFACE interfaces.ISystem */
		
		public function get dataRequest():DatabaseRequest 
		{
			var request:DatabaseRequest = new DatabaseRequest(this)
			request.requestDataFrom(TestDB1, TestDB4)
			return request;
		}
		
		private var testDB1:TestDB1
		private var testDB4:TestDB4
		
		public function setup(request:DatabaseRequest):void 
		{
			testDB1 = request.getDatabase(TestDB1) as TestDB1
			testDB4 = request.getDatabase(TestDB4) as TestDB4
			trace("setting up test system 1 " + testDB1 + " " + testDB4)
			
			
			if (testDB1 is TestDB1 && testDB4 is TestDB4) {
				UnitTestVars.inst.setTestVar("appHubTest", "setupTestSystem1", true);
			}
		}
		
		public function startup():void 
		{
			trace("starting up test system 1");
			UnitTestVars.inst.setTestVar("appHubTest", "startupTestSystem1", true);
		}
		
		public function shutdown():void 
		{
			trace("shutting down test system 1");
			UnitTestVars.inst.setTestVar("appHubTest", "shutdownTestSystem1", true);
		}
		
		public function update():void 
		{
			trace("updating test system 1")
			UnitTestVars.inst.setTestVar("appHubTest", "updateTestSystem1", true);
		}
		
	}

}