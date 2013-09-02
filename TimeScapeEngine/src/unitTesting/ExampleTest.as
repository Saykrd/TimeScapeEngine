package unitTesting 
{
	/**
	 * ...
	 * @author Saykrd
	 */
	public class ExampleTest extends UnitTest 
	{
		
		public function ExampleTest(id:String) 
		{
			super(id);
			init()
		}
		
		public function init():void {
			addTask("test1", test1)
			addTask("test2", test2)
			addTask("test3", test3)
			addTask("test4", test4)
		}
		
		public function test1():void {
			// Testing if tests can pass
			pass()
		} 
		
		public function test2():void {
			//If fail is hit, fail test and print out reason. do not pass
			fail("FAIL REASON 1")
			fail("FAIL REASON 2")
			pass()
		}
		
		public function test3():void {
			fail("I AM A BANANNA")
			pass()
		}
		
		public function test4():void {
			//Ignore fails after test is passed
			pass()
			fail("FAIL 1")
			fail("FAIL 2")
		}
		
		
		
		
	}

}