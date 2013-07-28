package architecture.tests 
{
	import architecture.SystemContainer;
	import flash.events.Event;
	import unitTesting.UnitTestVars;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public class TestSystemContainer1 extends SystemContainer 
	{
		
		private var testSystem1:TestSystem1
		private var testSystem2:TestSystem2
		private var testSystem3:TestSystem3
		
		
		public function TestSystemContainer1(identifier:String) 
		{
			super(identifier);
			
			testSystem1 = registerSystem(TestSystem1) as TestSystem1
			testSystem2 = registerSystem(TestSystem2) as TestSystem2
			testSystem3 = registerSystem(TestSystem3) as TestSystem3
			addListener(testSystem1, "testSystemEvent1", testEvent1)
		}
		
		public function testEvent1(e:Event):void {
			trace("On TestEvent1!!")
			UnitTestVars.inst.setTestVar("appHubTest", "dispatchRecieved1", true)
		}
	}

}