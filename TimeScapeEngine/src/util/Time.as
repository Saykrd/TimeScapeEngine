package util 
{
	import flash.utils.*
	
	/**
	 * ...
	 * @author Saykrd
	 */
	
	public class Time 
	{
		
		private static var _appStartTime:Number
		private static var _deltaTime:Number = 0
		private static var _prevTimeStamp:Number = 0
		
		private static var _date:Date = new Date()
		
		public static function start():void {
			_appStartTime  = _date.time
			_prevTimeStamp = getTimer();
		}
		
		
		public static function updateTime():void {
			var curTimeStamp:Number = getTimer();
			_deltaTime = curTimeStamp - _prevTimeStamp;
			_prevTimeStamp = curTimeStamp
			
			_date.time += _deltaTime
		}
		
		public static function get applicationStartTime():Number {
			return _appStartTime
		}
		
		public static function get deltaTime():Number {
			return _deltaTime
		}
		
		public static function get totalRunTime():Number {
			return getTimer()
		}
		
		public static function get epochTime():Number {
			return _date.time
		}
		
	}

}