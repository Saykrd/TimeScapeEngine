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
			pass()
		}
		
		public function test2():void {
			//fail("My spoon is too big")
			//fail("My SPOON is TOO BIG")
			pass()
		}
		
		public function test3():void {
			//fail("I AM A BANANNA")
			pass()
		}
		
		public function test4():void {
			pass()
			//fail("POOL'S CLOSED")
			//fail("AIDS")
		}
		
		
		
		
	}

}