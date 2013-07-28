package architecture.tests 
{
	import architecture.AppState;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public class TestSystemContainer2 extends AppState 
	{
		
		private var testSystem3:TestSystem3
		
		
		public function TestSystemContainer2(identifier:String) 
		{
			super(identifier);
			
			testSystem3 = registerSystem(TestSystem3) as TestSystem3
			
		}
		
	}

}