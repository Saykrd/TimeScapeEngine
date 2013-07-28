package architecture.tests 
{
	import architecture.DatabaseDispatcher;
	import architecture.DatabaseRequest;
	import flash.events.Event;
	import interfaces.ISystem;
	import unitTesting.UnitTestVars;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public class TestSystem3 implements ISystem 
	{
		
		public function TestSystem3() 
		{
			
		}
		
		/* INTERFACE interfaces.ISystem */
		
		public function get dataRequest():DatabaseRequest 
		{
			var request:DatabaseRequest = new DatabaseRequest(this)
			request.requestDataFrom(TestDB5)
			request.subscribeTo(TestDB1)
			return request;
		}
		
		private var testDB5:TestDB5
		private var testDBDispatcher1:DatabaseDispatcher
		
		public function setup(request:DatabaseRequest):void 
		{
			testDB5 = request.getDatabase(TestDB5) as TestDB5;
			testDBDispatcher1 = request.getDispatcher(TestDB1);
			
			trace("setting up test system 3 " + testDB5 + testDBDispatcher1);
			
			if (testDB5 && testDB5 is TestDB5 && testDBDispatcher1 is DatabaseDispatcher) {
				UnitTestVars.inst.setTestVar("appHubTest", "setupTestSystem3", true);
			}
		}
		
		public function startup():void 
		{
			trace("starting up test system 3");
			UnitTestVars.inst.setTestVar("appHubTest", "startupTestSystem3", true);
		}
		
		public function shutdown():void 
		{
			trace("shutting down test system 3");
			UnitTestVars.inst.setTestVar("appHubTest", "shutdownTestSystem3", true);
		}
		
		public function update():void 
		{
			trace("updating test system 3")
			UnitTestVars.inst.setTestVar("appHubTest", "updateTestSystem3", true);
		}
		
	}

}