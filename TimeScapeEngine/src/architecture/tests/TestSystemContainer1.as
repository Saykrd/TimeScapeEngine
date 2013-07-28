package architecture.tests 
{
	import architecture.SystemContainer;
	
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
			
		}
		
	}

}