package architecture 
{
	import flash.utils.Dictionary;
	import interfaces.ISystem;
	import util.Util;
	/**
	 * ...
	 * @author Saykrd
	 */
	public class ApplicationHub 
	{
		
		private static const DEFAULT_STATE_GROUP:String = "defaultStateGroup"
		
		private var _databases:Vector.<ADatabase>
		private var _appStates:Vector.<AppState>
		private var _activeStates:Dictionary
		
		public function ApplicationHub() 
		{
			_databases    = new Vector.<ADatabase>;
			_appStates   = new Vector.<AppState>;
			_activeStates   = new Dictionary
		}
			
		protected function run(appState:AppState, groupID:String = DEFAULT_STATE_GROUP):void {
			var databases:Vector.<ADatabase>;  
			var requests:Vector.<DatabaseRequest>;
			var database:ADatabase;
			var request:DatabaseRequest;
			var reqList:Vector.<Class>;
			var cls:Class;
			
			trace("Setting up system set " + appState.stateID + " in system group " + groupID)
			
			if (getSystemSetByID(appState.stateID, groupID)) {
				throw new Error("[ApplicationHub] !! Attempt to run duplicate system set of id " + appState.stateID + " in group " + groupID) 
			}
			// Get all handler requests from each system
			trace("Getting handlers request...")
			requests = queryRequests(appState);
			// Get all handlers already in this group
			trace("Getting handlers already in this group...")
			databases = getDatabasesInGroup(groupID);
			
			// Create all databases that are required
			trace("Creating Databases...")
			for each(request in requests) {
				reqList= request.requests;
				for each(cls in reqList) {
					
					var hasData:Boolean;
					
					for each(database in databases) {
						if (database is cls) {
							trace("Class " + database + " is already in system set!")
							hasData = true;
							break
						}
					}
					
					if (!hasData) {
						trace("Creating database: " + cls)
						var db:ADatabase = new cls;
						db.groupID = groupID;
						databases.push(db);
						_databases.push(db);
					}
				}
			}
			
			// Assign all necessary databases and dispatchers to each request
			for each(request in requests) {
				reqList = request.requests;
				var subscriptions:Vector.<Class> = request.subscriptions;
				for each(cls in reqList) {
					var requestedDatabase:ADatabase;
					
					for each(database in databases) {
						if (database is cls) {
							requestedDatabase = database;
						}
					}
					
					request.addDatabase(requestedDatabase);
				}
				
				for each(cls in subscriptions) {
					var requestedDispatcher:DatabaseDispatcher;
					
					for each(database in databases) {
						if (database is cls) {
							requestedDispatcher = database.dataDispatcher;
						}
					}
					
					if (requestedDispatcher) {
						request.addDispatcher(requestedDispatcher);
					}
				}
				
				request.transact();
			}
			
			appState.groupID = groupID;
			_appStates.push(appState);
			appState.initialize();
			activateState(appState.stateID, groupID)
			Util.dumpVector(_databases)
		}
		
		
		public function end(stateID:String, groupID:String = null):void {
			trace("Ending state: " + stateID + " in group " + groupID)
			var appState:AppState = getSystemSetByID(stateID, groupID)
			
			if (!appState) return
			
			groupID = groupID || appState.groupID
			var systemSets:Vector.<AppState> = getStateGroup(groupID)
			var databases:Vector.<ADatabase> = getDatabasesInGroup(groupID)
			var trash:Vector.<ADatabase> = new Vector.<ADatabase>
			
			// Clean up all the databases that arent in use anymore due to the shutdown of this system
			trace("Gathering all databases that are not in use anymore..")
			for each(var database:ADatabase in databases) {
				var inUse:Boolean = false;
				for each(var ss:AppState in systemSets) {
					if (ss == appState) continue;
					
					var requests:Vector.<DatabaseRequest> = queryRequests(ss)
					
					for each(var request:DatabaseRequest in requests) {
						var rlist:Vector.<Class> = request.requests
						for each(var cls:Class in rlist) {
							if (database is cls) {
								trace("Database", database, "is still in use")
								inUse = true;
								break;
							}
						}
					}
				}
				
				if (!inUse) {
					trace("Database", database, "is not in use!")
					trash.push(database)
				}
			}
			
			removeState(stateID, groupID);
			
			for each(var db:ADatabase in trash) {
				removeDatabase(db);
			}
			
			Util.dumpVector(_databases)
		}
		
		public function endGroup(groupID:String):void {
			trace("Ending system group:" + groupID)
			var systemSets:Vector.<AppState> = getStateGroup(groupID);
			var databases:Vector.<ADatabase> = getDatabasesInGroup(groupID);
			
			for each(var appState:AppState in systemSets) {
				end(appState.stateID, groupID)
			}
			
			_activeStates[groupID] = null
		}
		
		public function endAll():void {
			trace("Ending all states...")
			Util.dumpVector(_appStates)
			
			var groups:Array = getGroupList()
			for (var i:int = 0; i < groups.length; i++) {
				var groupID:String = groups[i];
				endGroup(groupID)
			}
			
			trace("Is everything gone?")
			Util.dumpVector(_appStates)
		}
		
		public function update():void {
			for (var i:int = 0; i <  _appStates.length; i++) {
				var ss:AppState = _appStates[i];
				var ssid:String = ss.stateID;
				var gid:String  = ss.groupID;
				
				if (isStateActive(ssid, gid)){
					ss.onTick();
					ss.postTick();
				}
			}
		}
		
		public function activateState(setID:String, groupID:String):void {
			var data:Object = _activeStates[groupID] || { };
			
			data[setID] = true
			
			if (!_activeStates[groupID]) {
				_activeStates[groupID] = data
				data._active = true
			}
		}
		
		public function haltState(setID:String, groupID:String):void {
			if (!_activeStates[groupID]) {
				return
			}
			var data:Object = _activeStates[groupID];
			data[setID] = false
		}
		
		public function activateGroup(groupID:String):void {
			var data:Object = _activeStates[groupID] || { };
			
			data._active = true
			
			if (!_activeStates[groupID]) {
				_activeStates[groupID] = data
			}
		}
		
		public function haltGroup(groupID:String):void {
			if (!_activeStates[groupID]) {
				return
			}
			var data:Object = _activeStates[groupID];
			data._active = false
		}
		
		public function isStateActive(setID:String, groupID:String):Boolean {
			if (!_activeStates[groupID]) {
				return false
			}
			
			var data:Object = _activeStates[groupID];
			return data._active && data[setID]
		}
		
		public function isGroupActive(groupID:String):Boolean {
			if (!_activeStates[groupID]) {
				return false
			}
			
			var data:Object = _activeStates[groupID];
			return data._active
		}
		
		
		private function removeDatabase(database:ADatabase):void {
			for (var i:int = _databases.length - 1; i >= 0 && _databases.length != 0; i--) {
				var db:ADatabase = _databases[i]
				if (db == database) {
					db.destroy();
					_databases.splice(i, 1);
					return;
				}
			}
		}
		
		
		private function removeState(stateID:String, groupID:String = null):void {
			for (var i:int = _appStates.length - 1; i >= 0 && _appStates.length != 0; i--) {
				var appState:AppState = _appStates[i]
				if (appState.stateID == stateID && (!groupID || appState.groupID == groupID)) {
					appState.kill();
					_appStates.splice(i, 1)
					
					if (_activeStates[groupID]) {
						_activeStates[groupID][stateID] = null
					}
					
					return;
				}
			}
			
			return;
		}
		
		private function getSystemSetByID(stateID:String, groupID:String = null):AppState {
			for each(var appState:AppState in _appStates) {
				if (appState.stateID == stateID && (!groupID || appState.groupID == groupID)) {
					return appState;
				}
			}
			
			return null;
		}
		
		private function getStateGroup(groupID:String):Vector.<AppState> {
			var systemSets:Vector.<AppState> = new Vector.<AppState>;
			
			for each(var sc:AppState in _appStates) {
				if (sc.groupID == groupID) {
					systemSets.push(sc)
				}
			}
			
			return systemSets
		}
		
		private function getDatabasesInGroup(groupID:String):Vector.<ADatabase> {
			var databases:Vector.<ADatabase> = new Vector.<ADatabase>;
			
			for each(var database:ADatabase in _databases) {
				if (database.groupID == groupID) {
					databases.push(database);
				}
			}
			
			return databases
		}
		
		private function getGroupList():Array {
			var groupList:Array = []
			var tracker:Object = { }
			
			for each(var sc:AppState in _appStates) {
				if (!tracker[sc.groupID]) {
					groupList.push(sc.groupID)
					tracker[sc.groupID] = true
				}
			}
			
			tracker = null
			return groupList
		}
		
		
		private function queryRequests(appState:AppState):Vector.<DatabaseRequest> {
			var requests:Vector.<DatabaseRequest> = new Vector.<DatabaseRequest>;
			
			for (var i:int = 0; i < appState.numSystems; i++) {
				var sys:ISystem = appState.getSystemByIndex(i);
				var req:DatabaseRequest = sys.dataRequest;
				
				requests.push(req);
			}
			
			return requests
		}
		
	}

}