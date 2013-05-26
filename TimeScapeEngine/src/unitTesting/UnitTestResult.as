package unitTesting 
{
	/**
	 * ...
	 * @author Saykrd
	 */
	public class UnitTestResult 
	{
		
		private const FAILED:String = "failed"
		private const PASS:String = "pass"
		private const UNCHECKED:String = "unchecked"
		
		private const UNSPECIFIED_REASON:String = "Creator of test hasn't specified any reasons for failure"
		
		private var _status:String = UNCHECKED
		private var _remarks:Array = []
		
		
		public function fail(reason:String):void {
			if (_status != FAILED) {
				_status = FAILED
				refreshRemarks()
			}
			_remarks.push(reason)
		}
		
		public function pass():void {
			if (_status != FAILED) {
				_status = PASS
				refreshRemarks()
			}
		}
		
		public function get remarks():Array {
			return _remarks.slice()
		}
		
		public function get passed():Boolean {
			return _status == PASS;
		}
		
		public function refresh():void {
			_status = UNCHECKED
			refreshRemarks()
		}
		
		private function refreshRemarks():void {
			_remarks.splice(0)
			if (_status == UNCHECKED) {
				_remarks[0] = UNSPECIFIED_REASON
			}
		}
		
	}

}