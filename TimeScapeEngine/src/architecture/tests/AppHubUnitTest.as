package architecture.tests 
{
	import architecture.ApplicationHub;
	import unitTesting.UnitTest;
	import unitTesting.UnitTestVars;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public class AppHubUnitTest extends UnitTest 
	{
		
		public function AppHubUnitTest(id:String) 
		{
			super(id);
			init()
		}
		
		public var appHub:TestAppHub;
		
		public function init():void {
			addTask("appHubTest1", appHubTest1)
			addTask("multiStateInGroup", appHubTest2)
		}
		
		public function appHubTest1():void {
			UnitTestVars.inst.registerTestCase("appHubTest")
			
			appHub = new TestAppHub
			
			appHub.testRun1()
			appHub.update()
			appHub.endAll()
			
			var setupChecks:Array = []
			var updateChecks:Array = []
			var startupChecks:Array = []
			var shutdownChecks:Array = []
			var numSystems:int = 3
			
			var dispatchCheck:Boolean = UnitTestVars.inst.getTestVar("appHubTest", "dispatchedEvent1")
			var listenCheck:Boolean = UnitTestVars.inst.getTestVar("appHubTest", "dispatchRecieved1")
			
			for (var i:int = 0; i <  numSystems; i++) {
				setupChecks[i] = UnitTestVars.inst.getTestVar("appHubTest", "setupTestSystem" + (i + 1))
				updateChecks[i] = UnitTestVars.inst.getTestVar("appHubTest", "updateTestSystem" + (i + 1))
				startupChecks[i] = UnitTestVars.inst.getTestVar("appHubTest", "startupTestSystem" + (i + 1))
				shutdownChecks[i] = UnitTestVars.inst.getTestVar("appHubTest", "shutdownTestSystem" + (i + 1))
			}
			
			if (!dispatchCheck) {
				fail("Event was not dispatched!");
			}
			
			if (!listenCheck) {
				fail("Dispatched event was not recieved!");
			}
			
			for (i = 0; i <  numSystems; i++) {
				if (!setupChecks[i]) {
					fail("Test System " + (i + 1) + " was not setup properly!")
				}
				
				if (!updateChecks[i]) {
					fail("Test System "+ (i + 1) +" did not update!")
				}
				
				if (!startupChecks[i]) {
					fail("Test System "+ (i + 1) + " did not startup!")
				}
				
				if (!shutdownChecks[i]) {
					fail("Test System "+ (i + 1) + " did not shutdown!")
				}
			}
			
			pass()
		}
		
		public function appHubTest2():void {
			UnitTestVars.inst.registerTestCase("appHubTest")
			
			appHub.testRun2()
			appHub.update()
			appHub.endAll()
			
			var setupChecks:Array = []
			var updateChecks:Array = []
			var startupChecks:Array = []
			var shutdownChecks:Array = []
			var numSystems:int = 3
			
			var dispatchCheck:Boolean = UnitTestVars.inst.getTestVar("appHubTest", "dispatchedEvent1")
			var listenCheck:Boolean = UnitTestVars.inst.getTestVar("appHubTest", "dispatchRecieved1")
			
			for (var i:int = 0; i <  numSystems; i++) {
				setupChecks[i] = UnitTestVars.inst.getTestVar("appHubTest", "setupTestSystem" + (i + 1))
				updateChecks[i] = UnitTestVars.inst.getTestVar("appHubTest", "updateTestSystem" + (i + 1))
				startupChecks[i] = UnitTestVars.inst.getTestVar("appHubTest", "startupTestSystem" + (i + 1))
				shutdownChecks[i] = UnitTestVars.inst.getTestVar("appHubTest", "shutdownTestSystem" + (i + 1))
			}
			
			if (!dispatchCheck) {
				fail("Event was not dispatched!");
			}
			
			if (!listenCheck) {
				fail("Dispatched event was not recieved!");
			}
			
			
			for (i = 0; i <  numSystems; i++) {
				if (!setupChecks[i]) {
					fail("Test System " + (i + 1) + " was not setup properly!")
				}
				
				if (!updateChecks[i]) {
					fail("Test System "+ (i + 1) +" did not update!")
				}
				
				if (!startupChecks[i]) {
					fail("Test System "+ (i + 1) + " did not startup!")
				}
				
				if (!shutdownChecks[i]) {
					fail("Test System "+ (i + 1) + " did not shutdown!")
				}
			}
			
			pass()
		}
		
	}

}