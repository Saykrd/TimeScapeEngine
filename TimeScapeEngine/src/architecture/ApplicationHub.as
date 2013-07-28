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
		
		private static const DEFAULT_SYSTEM_GROUP:String = "defaultSystemGroup"
		
		private var _databases:Vector.<ADatabase>
		private var _systemSets:Vector.<SystemContainer>
		private var _activeGroups:Dictionary
		private var _activeSets:Dictionary
		
		public function ApplicationHub() 
		{
			_databases    = new Vector.<ADatabase>;
			_systemSets   = new Vector.<SystemContainer>;
			_activeGroups = new Dictionary
			_activeSets   = new Dictionary
		}
			
		protected function run(systemSet:SystemContainer, groupID:String = DEFAULT_SYSTEM_GROUP):void {
			var databases:Vector.<ADatabase>;  
			var requests:Vector.<DatabaseRequest>;
			var database:ADatabase;
			var request:DatabaseRequest;
			var reqList:Vector.<Class>;
			var cls:Class;
			
			trace("Setting up system set " + systemSet.containerID + " in system group " + groupID)
			
			if (getSystemSetByID(systemSet.containerID, groupID)) {
				throw new Error("[ApplicationHub] !! Attempt to run duplicate system set of id " + systemSet.containerID + " in group " + groupID) 
			}
			// Get all handler requests from each system
			trace("Getting handlers request...")
			requests = queryRequests(systemSet);
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
			
			systemSet.groupID = groupID;
			systemSet.initialize();
			activateSet(systemSet.containerID, groupID)
			
			_systemSets.push(systemSet);
			Util.dumpVector(_databases)
		}
		
		
		public function end(systemSetID:String, groupID:String = null):void {
			trace("Ending system set: " + systemSetID + " in group " + groupID)
			var systemSet:SystemContainer = getSystemSetByID(systemSetID, groupID)
			
			if (!systemSet) return
			
			groupID = groupID || systemSet.groupID
			var systemSets:Vector.<SystemContainer> = getSystemSetGroup(groupID)
			var databases:Vector.<ADatabase> = getDatabasesInGroup(groupID)
			var trash:Vector.<ADatabase> = new Vector.<ADatabase>
			
			// Clean up all the databases that arent in use anymore due to the shutdown of this system
			trace("Gathering all databases that are not in use anymore..")
			for each(var database:ADatabase in databases) {
				var inUse:Boolean = false;
				for each(var ss:SystemContainer in systemSets) {
					if (ss == systemSet) continue;
					
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
			
			removeSystem(systemSetID, groupID);
			
			for each(var db:ADatabase in trash) {
				removeDatabase(db);
			}
			
			Util.dumpVector(_databases)
		}
		
		public function endGroup(groupID:String):void {
			trace("Ending system group:" + groupID)
			var systemSets:Vector.<SystemContainer> = getSystemSetGroup(groupID);
			var databases:Vector.<ADatabase> = getDatabasesInGroup(groupID);
			
			for each(var systemSet:SystemContainer in systemSets) {
				end(systemSet.containerID, groupID)
			}
			
			_activeSets[groupID] = null
		}
		
		public function endAll():void {
			trace("Ending all systemsets...")
			Util.dumpVector(_systemSets)
			
			var groups:Array = getGroupList()
			for (var i:int = 0; i < groups.length; i++) {
				var groupID = groups[i];
				endGroup(groupID)
			}
			
			trace("Is everything gone?")
			Util.dumpVector(_systemSets)
		}
		
		public function update():void {
			for (var i:int = 0; i <  _systemSets.length; i++) {
				var ss:SystemContainer = _systemSets[i];
				var ssid:String = ss.containerID;
				var gid:String  = ss.groupID;
				
				if (isSetActive(ssid, gid)){
					ss.update()
				}
			}
		}
		
		public function activateSet(setID:String, groupID:String):void {
			var data = _activeSets[groupID] || { };
			
			data[setID] = true
			
			if (!_activeSets[groupID]) {
				_activeSets[groupID] = data
				data._active = true
			}
		}
		
		public function haltSet(setID:String, groupID:String):void {
			if (!_activeSets[groupID]) {
				return
			}
			var data = _activeSets[groupID];
			data[setID] = false
		}
		
		public function activateGroup(groupID:String):void {
			var data = _activeSets[groupID] || { };
			
			data._active = true
			
			if (!_activeSets[groupID]) {
				_activeSets[groupID] = data
			}
		}
		
		public function haltGroup(groupID:String):void {
			if (!_activeSets[groupID]) {
				return
			}
			var data = _activeSets[groupID];
			data._active = false
		}
		
		public function isSetActive(setID:String, groupID:String):Boolean {
			if (!_activeSets[groupID]) {
				return false
			}
			
			var data = _activeSets[groupID];
			return data._active && data[setID]
		}
		
		public function isGroupActive(groupID:String):Boolean {
			if (!_activeSets[groupID]) {
				return false
			}
			
			var data = _activeSets[groupID];
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
		
		
		private function removeSystem(systemSetID:String, groupID:String = null):void {
			for (var i:int = _systemSets.length - 1; i >= 0 && _systemSets.length != 0; i--) {
				var systemSet:SystemContainer = _systemSets[i]
				if (systemSet.containerID == systemSetID && (!groupID || systemSet.groupID == groupID)) {
					systemSet.kill();
					_systemSets.splice(i, 1)
					
					if (_activeSets[groupID]) {
						_activeSets[groupID][systemSetID] = null
					}
					
					return;
				}
			}
			
			return;
		}
		
		private function getSystemSetByID(systemSetID:String, groupID:String = null):SystemContainer {
			for each(var systemSet:SystemContainer in _systemSets) {
				if (systemSet.containerID == systemSetID && (!groupID || systemSet.groupID == groupID)) {
					return systemSet;
				}
			}
			
			return null;
		}
		
		private function getSystemSetGroup(groupID:String):Vector.<SystemContainer> {
			var systemSets:Vector.<SystemContainer> = new Vector.<SystemContainer>;
			
			for each(var sc:SystemContainer in _systemSets) {
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
			
			for each(var sc:SystemContainer in _systemSets) {
				if (!tracker[sc.groupID]) {
					groupList.push(sc.groupID)
					tracker[sc.groupID] = true
				}
			}
			
			tracker = null
			return groupList
		}
		
		
		private function queryRequests(systemSet:SystemContainer):Vector.<DatabaseRequest> {
			var requests:Vector.<DatabaseRequest> = new Vector.<DatabaseRequest>;
			
			for (var i:int = 0; i < systemSet.numSystems; i++) {
				var sys:ISystem = systemSet.getSystemByIndex(i);
				var req:DatabaseRequest = sys.dataRequest;
				
				requests.push(req);
			}
			
			return requests
		}
		
	}

}