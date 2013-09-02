package unitTesting 
{
	/**
	 * Global class used to report test values for Unit Tests. Register values for expected behavior here,
	 * then review them in your test.
	 * @author Saykrd
	 */
	public class UnitTestVars 
	{
		
		//================== SINGLETON LOCK ==============
		private static var _inst:UnitTestVars
		
		public static function get inst():UnitTestVars {
			if (!_inst) {
				_inst = new UnitTestVars(new Lock())
			}
			
			return _inst
		}
		
		
		public function UnitTestVars(locked:Lock) {}
		
		//------------------------------------------------
		
		private var _vars:Object = { }
		
		/**
		 * Adds / Refreshes a new test case to store values in
		 * @param	caseID
		 */
		public function registerTestCase(caseID:String):void {
			_vars[caseID] = { };
			
		}
		
		/**
		 * Registers an expected value to a case.
		 * @param	caseID
		 * @param	property
		 * @param	value
		 */
		public function setTestVar(caseID:String, property:String, value:*):void {
			if (!_vars[caseID]) return;
			_vars[caseID][property] = value;
		}
		
		/**
		 * Retrieves a registered property from a case
		 * @param	caseID
		 * @param	property
		 * @return
		 */
		public function getTestVar(caseID:String, property:String):* {
			if (!_vars[caseID]) return null;
			return _vars[caseID][property];
		}
	}
}
internal class Lock {}