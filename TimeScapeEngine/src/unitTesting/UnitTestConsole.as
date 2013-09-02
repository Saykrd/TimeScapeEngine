package unitTesting 
{
	import architecture.tests.AppHubUnitTest;
	import flash.utils.getQualifiedClassName;
	/**
	 * Main Hub used to setup a unit testing environment. Used to run and interface with all registered unit tests.
	 * @author Saykrd
	 */
	public class UnitTestConsole 
	{
		//================== SINGLETON LOCK ==============
		
		private static var _inst:UnitTestConsole
		
		public static function get inst():UnitTestConsole {
			if (!_inst) {
				_inst = new UnitTestConsole(new Lock())
			}
			
			return _inst
		}
		
		
		public function UnitTestConsole(locked:Lock) {}
		
		//------------------------------------------------
		
		private var _tests:Vector.<UnitTest> = new Vector.<UnitTest>
		private var _pass:Boolean = true
		private var _passedTests:Vector.<String> = new Vector.<String>
		private var _failedTests:Vector.<String> = new Vector.<String>
		
		/**
		 * Initiallizes all unit tests
		 */
		public function startup():void {
			trace("Unit Test Console Initialized")
			//----------------------- ALL TESTS INITIALIZED HERE ------------------------------
			
			addTests(AppHubUnitTest)
			
			//---------------------------------------------------------------------------------
		}
		
		
		/**
		 * Runs all registered unit tests
		 */
		public function runAllTests():void {
			trace("[UnitTestConsole] ================================================")
			trace("[UnitTestConsole] ------------- STARTING UNIT TESTS --------------")
			trace("[UnitTestConsole] ================================================")
			
			clearResults()
			for each(var test:UnitTest in _tests) {
				runTest(test)
			}
			printResults()
		}
		
		/**
		 * Runs a unit test. Results are printed in the console
		 * @param	test
		 */
		public function runTest(test:UnitTest):void {
			test.addEventListener(UnitTestEvent.TEST_SUCCESS, onTestSuccess);
			test.addEventListener(UnitTestEvent.TEST_FAILED, onTestFail);
			test.runTest();
			
			function onTestSuccess(e:UnitTestEvent):void {
				_passedTests.push(e.testID);
				removeListeners();
			}
			
			function onTestFail(e:UnitTestEvent):void {
				_pass = false;
				_failedTests.push(e.testID + " at task " + e.taskID);
				removeListeners();
			}
			
			function removeListeners():void {
				test.removeEventListener(UnitTestEvent.TEST_SUCCESS, onTestSuccess);
				test.removeEventListener(UnitTestEvent.TEST_FAILED, onTestFail);
			}
		}
		
		/**
		 * Registers multiple test to be executed
		 * @param	...classes
		 */
		private function addTests(...classes):void {
			for (var i:int = 0; i < classes.length; i++) {
				var cls:Class = classes[i]
				addTest(cls);
			}
		}
		
		
		/**
		 * Registers a test to be executed
		 * @param	testClass
		 */
		private function addTest(testClass:Class):void {
			var test:* = new testClass(getQualifiedClassName(testClass));
			if (test is UnitTest) {
				_tests.push(test);
			}
		}
		
		/**
		 * Clears results of last executed unit test run
		 */
		private function clearResults():void {
			_passedTests.length = 0
			_failedTests.length = 0
			_pass = true
		}
		
		/**
		 * Dumps results of unit tests into the console
		 */
		private function printResults():void {
			trace("[UnitTestConsole] ================================================")
			trace("[UnitTestConsole] ------------- UNIT TEST RESULTS ----------------")
			trace("[UnitTestConsole] ================================================")
			var i:int = 0
			
			if (_pass) {
				trace("[UnitTestConsole] Unit test was a success!!")
			} else {
				trace("[UnitTestConsole] Unit test was a failure!!")
			}
			
			if (_passedTests.length > 0) {
				trace("[UnitTestConsole] The following tests have passed successfully:");
				for (i = 0; i < _passedTests.length; i++) {
					var testID:String = _passedTests[i];
					trace("[UnitTestConsole]   - ", testID);
				}
			}
			
			if (_failedTests.length > 0) {
				trace("[UnitTestConsole] The following tests have failed:");
				for (i = 0; i < _failedTests.length; i++) {
					var failedTest:String = _failedTests[i];
					trace("[UnitTestConsole]   - ", failedTest);
				}
			}
			
			trace("[UnitTestConsole] Number of tests checked: " + (_passedTests.length + _failedTests.length));
			
			if (_pass) {
				trace("[UnitTestConsole] Ending with a happyface :)")
			} else {
				trace("[UnitTestConsole] Ending with a sadface... :(")
			}
			
		}
		
		
	}
}

internal class Lock {}