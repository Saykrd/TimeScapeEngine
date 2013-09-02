package util 
{
	/**
	 * ...
	 * @author Saykrd
	 */
	public class Random 
	{
		
		public function Random() 
		{
			
		}
		
		public static function randBetween(min:Number, max:Number):Number {
			return min + (max - min) * Math.random();
		}
		
	}

}