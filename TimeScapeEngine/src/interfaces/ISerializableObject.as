package interfaces 
{
	
	/**
	 * ...
	 * @author Saykrd
	 */
	public interface ISerializableObject extends ITransientObject
	{
		function toObject():Object
		function fromObject(data:Object):void
		
	}
	
}