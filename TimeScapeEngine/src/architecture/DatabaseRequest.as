package architecture 
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import interfaces.ISystem;
	import interfaces.ITransient;
	/**
	 * ...
	 * @author Saykrd
	 */
	public class DatabaseRequest 
	{
		private var _requestList:Vector.<Class>
		private var _subscriptionList:Vector.<Class>
		private var _databaseList:Dictionary
		private var _dispatcherList:Dictionary
		private var _system:ISystem
		
		public function DatabaseRequest(system:ISystem) 
		{
			_system = system;
			_requestList = new Vector.<Class>
			_subscriptionList = new Vector.<Class>;
			_dispatcherList = new Dictionary;
			_databaseList = new Dictionary;
		}
		
		public function requestDataFrom(...databases):void {
			for each(var cls:Class in databases) {
				_requestList.push(cls)
			}
		}
		
		public function subscribeTo(...subscriptions):void {
			for each(var cls:Class in subscriptions) {
				_subscriptionList.push(cls)
			}
		}
		
		public function addDatabase(database:ADatabase):void {
			trace("Adding database " + database + " to system " + _system)
			for each(var cls:Class in _requestList) {
				if (database is cls) {
					_databaseList[cls] = database;
					break;
				}
			}
		}
		
		public function addDispatcher(dispatcher:DatabaseDispatcher):void {
			trace("Adding dispatcher " + dispatcher + " to system " + _system)
			for each(var cls:Class in _subscriptionList) {
				if (dispatcher.classID == getQualifiedClassName(cls)) {
					_dispatcherList[cls] = dispatcher;
					break;
				}
			}
		}
		
		public function getDatabase(cls:Class):ADatabase{
			if (_databaseList[cls]) {
				return _databaseList[cls]
			}
			
			return null
		}
		
		public function getDispatcher(cls:Class):DatabaseDispatcher {
			if (_dispatcherList[cls]) {
				return _dispatcherList[cls]
			}
			
			return null
		}
		
		public function get fulfilled():Boolean {
			for each(var cls:Class in _requestList) {
				if (!_databaseList[cls]) {
					return false
				}
			}
			
			return true
		}
		
		public function transact():void {
			if (fulfilled) {
				_system.setup(this)
			}
			dispose()
		}
		
		public function dispose():void {
			_requestList.length = 0
			_subscriptionList.length = 0
			
			_subscriptionList = null
			_requestList = null
			_dispatcherList = null
			_databaseList = null
			_system = null
		}
		
		public function get requests():Vector.<Class> {
			return _requestList
		}
		
		public function get subscriptions():Vector.<Class> {
			return _subscriptionList
		}
		
	}

}