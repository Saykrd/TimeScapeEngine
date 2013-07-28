package unitTesting 
{
	/**
	 * ...
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

		public function registerTestCase(caseID:String):void {
			_vars[caseID] = { };
			
		}
		
		public function setTestVar(caseID:String, property:String, value:*):void {
			if (!_vars[caseID]) return;
			_vars[caseID][property] = value;
		}
		
		public function getTestVar(caseID:String, property:String):* {
			if (!_vars[caseID]) return null;
			return _vars[caseID][property];
		}
	}
}
internal class Lock {}