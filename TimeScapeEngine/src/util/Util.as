package util 
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Saykrd
	 */
	public class Util 
	{
		
		public static function clearDictionary(d:Dictionary):void {
			for (var k:* in d) {
				delete d[k];
			}
		}
		
		public static function dumpObject(obj:Object):void {
			trace(obj, "{")
			for (var k:String in obj) {
				trace(k, obj[k])
			}
			trace("}")
		}
		
		public static function dumpDict(dict:Dictionary):void {
			trace(dict, "{")
			for (var k:String in dict) {
				trace(k, dict[k])
			}
			trace("}")
		}
		
		public static function dumpVector(vect:*):void {
			trace(getQualifiedClassName(vect),"[")
			for (var i:int = 0; i < vect.length; i++) {
				trace("	[" + i + "]", vect[i])
			}
			trace("]")
		}
		
	}

}