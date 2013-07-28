package architecture.tests 
{
	import architecture.ApplicationHub;
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public class TestAppHub extends ApplicationHub 
	{
		
		public function TestAppHub() 
		{
			
		}
		
		public function testRun1():void {
			endAll()
			
			var sysSet1:TestSystemContainer1 = new TestSystemContainer1("test1")
			var sysSet2:TestSystemContainer2 = new TestSystemContainer2("test2")
			
			run(sysSet1, "group1")
			
		}
		
		
		public function testRun2():void {
			endAll()
			
			var sysSet1:TestSystemContainer1 = new TestSystemContainer1("test1")
			var sysSet2:TestSystemContainer2 = new TestSystemContainer2("test2")
			
			run(sysSet1, "group2")
			run(sysSet2, "group2")
			
		}
		
		public function testRun3():void {
			endAll()
			
			var sysSet1:TestSystemContainer1 = new TestSystemContainer1("test1")
			var sysSet2:TestSystemContainer2 = new TestSystemContainer2("test2")
			
			run(sysSet1, "group1")
			run(sysSet2, "group2")
			
		}
		
	}

}