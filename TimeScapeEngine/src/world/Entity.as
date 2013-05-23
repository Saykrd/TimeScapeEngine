package world 
{
	import flash.utils.Dictionary;
	import interfaces.ISerializable;
	import interfaces.ITransient;
	import util.Util;
	/**
	 * ...
	 * @author Saykrd
	 */
	public class Entity implements ISerializable, ITransient
	{
		
		private static var _numInstances:int = 0
		
		protected var _id:String = ""
		
		private var _stats:Dictionary
		
		public function Entity()
		{
			_stats = new Dictionary
		}
		
		public function destroy():void {
			Util.clearDictionary(_stats)
		}
		
		public function toObject():Object{
			var data:Object = { };		
			
			data.stats = { };
			for (var k:* in _stats) {
				_stats[k] = data.stats[k]
			}
			
			return data
		}
		
		public function fromObject(data:Object):void{
			for (var k:* in data.stats) {
				_stats[k] = data.stats[k]
			}
		}
		
		public function defineStat(stat:String, baseValue:*, minLimit:Number, maxLimit:Number):void {
			var data = new Object
			
			data.id       = stat;
			data.value    = baseValue;
			data.minLimit = minLimit;
			data.maxLimit = maxLimit;
			
			_stats[stat] = data;
		}
		
		public function defineStatFromXML(xml:XML):void {
			
		}
		
		public function defineStatFromObject(obj:Object):void {
			
		}
		
		public function validateStat(stat:String):Boolean {
			return _stat && _stats && _stats[stat]
		}
		
		public function setValue(stat:String, value:*):void {
			if (!_stats[stat]) {
				throw new Error("[Entity] !! Stat is not defined:" + stat);
			}
			
			var data:Object = _stats[stat];
			var endValue:*
			
			endValue = value;
			
			if (data.maxLimit && endValue > data.maxLimit) {
				endValue = data.maxLimit
			} else if (data.minLimit && endValue < data.minLimit) {
				endValue = data.minLimit
			}
			
			data.value = endValue
		}
		
		public function incrementValue(stat:String, value:Number):void {
			if (!validateStat(stat) || !(_stats[stat].value is Number)) {
				trace("[Entity] !! Cannot increment value for stat " + stat);
				if (!validateStat(stat)) {
					trace("[Entity] Reason: " + stat + " is not defined")
				}
				
				if (!(_stats[stat].value is Number)) {
					trace("[Entity] Reason: " + stat + " is not a number")
				}
				return
			}
			
			if (value < 0) {
				value = 0
			}
			
			var data:Object = _stats[stat];
			var endValue:Number
			
			endValue = data.value + value
			
			if (data.maxLimit && endValue > data.maxLimit) {
				endValue = data.maxLimit
			}
			
			data.value = endValue
		}
		
		public function subtractValue(stat:String, value:Number):void {
			if (!validateStat(stat) || !(_stats[stat].value is Number)) {
				trace("[Entity] !! Cannot increment value for stat " + stat);
				if (!validateStat(stat)) {
					trace("[Entity] Reason: " + stat + " is not defined")
				}
				
				if (!(_stats[stat].value is Number)) {
					trace("[Entity] Reason: " + stat + " is not a number")
				}
				return
			}
			
			if (value < 0) {
				value = Math.abs(value)
			}
			
			var data:Object = _stats[stat];
			var endValue:Number
			
			endValue = data.value + value
			
			if (data.maxLimit && endValue > data.maxLimit) {
				endValue = data.maxLimit
			}
			
			data.value = endValue
		}
		
		public function getValue(stat:String):*{
			if (!validateStat(stat)) return null;
			
			var data:Object = _stats[stat]
			return data.value
		}
		
	}

}