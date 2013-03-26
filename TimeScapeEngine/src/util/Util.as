package util 
{
	/**
	 * ...
	 * @author Saykrd
	 */
	public class Util 
	{
		
		public static function clearDictionary(d):void {
			for (var k:* in d) {
				delete d[k];
			}
		}
		
	}

}