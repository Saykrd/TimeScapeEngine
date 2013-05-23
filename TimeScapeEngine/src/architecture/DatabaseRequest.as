package architecture 
{
	import flash.utils.Dictionary;
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
		private var _handlerList:Dictionary
		private var _dispatcherList:Dictionary
		private var _system:ISystem
		
		public function DatabaseRequest(system:ISystem) 
		{
			_system = system;
			_requestList = new Vector.<Class>
			_subscriptionList = new Vector.<Class>;
			_dispatcherList = new Dictionary;
			_handlerList = new Dictionary;
		}
		
		public function addRequests(...handlers):void {
			for each(var cls:Class in handlers) {
				_requestList.push(cls)
			}
		}
		
		public function addSubscriptions(...subscriptions):void {
			for each(var cls:Class in subscriptions) {
				_subscriptionList.push(cls)
			}
		}
		
		public function addHandler(handler:ADatabase):void {
			for each(var cls:Class in _requestList) {
				if (handler is cls) {
					_handlerList[cls] = handler;
					break;
				}
			}
		}
		
		public function addDispatcher(dispatcher:DatabaseDispatcher):void {
			for each(var cls:Class in _handlerList) {
				if (dispatcher is cls) {
					_dispatcherList[cls] = dispatcher;
					break;
				}
			}
		}
		
		public function getHandler(cls:Class):ADatabase{
			if (_handlerList[cls]) {
				return _handlerList[cls]
			}
			
			return null
		}
		
		public function getDispatcher(cls:Class):DatabaseDispatcher {
			if (_subscriptionList[cls]) {
				return _dispatcherList[cls]
			}
			
			return null
		}
		
		public function get fulfilled():Boolean {
			for each(var cls:Class in _requestList) {
				if (!_handlerList[cls]) {
					return false
				}
			}
			
			return true
		}
		
		public function transact():void {
			if (fulfilled) {
				_system.create(this)
			}
			dispose()
		}
		
		public function dispose():void {
			_requestList.splice(0)
			_subscriptionList.splice(0)
			
			_subscriptionList = null
			_requestList = null
			_dispatcherList = null
			_handlerList = null
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