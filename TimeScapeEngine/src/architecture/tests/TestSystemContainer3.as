package architecture.tests 
{
	import architecture.SystemContainer;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public class TestSystemContainer3 extends SystemContainer 
	{
		
		private var testSystem1:TestSystem1
		private var testSystem2:TestSystem2
		
		
		public function TestSystemContainer3(identifier:String) 
		{
			super(identifier);
			
			testSystem1 = registerSystem(TestSystem1) as TestSystem1
			testSystem2 = registerSystem(TestSystem2) as TestSystem2
			addListener(testSystem1, "testSystemEvent1", testEvent1)
			
		}
		
		public function testEvent1(e:Event):void {
			trace("On TestSystemEvent1!")
		}
		
	}

}