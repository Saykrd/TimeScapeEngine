package architecture.tests 
{
	import architecture.SystemContainer;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public class TestSystemContainer2 extends SystemContainer 
	{
		
		private var testSystem3:TestSystem3
		
		
		public function TestSystemContainer2(identifier:String) 
		{
			super(identifier);
			
			testSystem3 = registerSystem(TestSystem3) as TestSystem3
			
		}
		
	}

}