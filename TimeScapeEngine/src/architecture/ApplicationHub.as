package architecture 
{
	import flash.utils.Dictionary;
	import interfaces.ISystem;
	/**
	 * ...
	 * @author Saykrd
	 */
	public class ApplicationHub 
	{
		
		private static const DEFAULT_SYSTEM_GROUP:String = "defaultSystemGroup"
		
		private var _databases:Vector.<ADatabase>
		private var _systemSets:Vector.<SystemContainer>
		
		public function ApplicationHub() 
		{
			_databases = new Vector.<ADatabase>;
			_systemSets = new Vector.<SystemContainer>;
		}
			
		protected function run(systemSet:SystemContainer, groupID:String = DEFAULT_SYSTEM_GROUP):void {
			var databases:Vector.<ADatabase>;  
			var requests:Vector.<DatabaseRequest>;
			var database:ADatabase;
			var request:DatabaseRequest;
			
			if (getSystemSetByID(systemSet.containerID, groupID)) {
				throw new Error("[ApplicationHub] !! Attempt to run duplicate system set of id " + systemSet.containerID + " in group " + groupID) 
			}
			// Get all handler requests from each system
			requests = queryRequests(systemSet);
			// Get all handlers already in this group
			databases = getDatabasesInGroup(groupID);
			
			// Create all databases that are required
			for each(request in requests) {
				var reqList:Vector.<Class> = request.requests;
				for each(var cls:Class in reqList) {
					
					var hasData:Boolean;
					
					for each(database in databases) {
						if (database is cls) {
							hasData = true;
							break
						}
					}
					
					if (!hasData) {
						var db:ADatabase = new cls;
						db.groupID = group;
						databases.push(db);
						_databases.push(db);
					}
				}
			}
			
			// Assign all necessary handlers to each request
			for each(request in requests) {
				var reqList:Vector.<Class> = request.requests;
				var subscriptions:Vector.<Class> = request.subscriptions;
				for each(var cls:Class in reqList) {
					var requestedDatabase:ADatabase;
					
					for each(database in databases) {
						if (database is cls) {
							requestedDatabase = database;
						}
					}
					
					request.addHandler(requestedDatabase);
				}
				
				for each(var cls:Class in subscriptions) {
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
			
			_systemSets.push(systemSet);
		}
		
		
		public function end(systemSetID:String, groupID:String = null):void {
			var systemSet:SystemContainer = getSystemSetByID(systemSetID, groupID)
			
			if (!systemSet) return
			
			groupID = groupID || systemSet.groupID
			var systemSets:Vector.<SystemContainer> = getSystemSetGroup(groupID)
			var databases:Vector.<ADatabase> = queryDatabases(systemSet, groupID)
			var trash:Vector.<ADatabase> = new Vector.<ADatabase>
			
			// Clean up all the databases that arent in use anymore due to the shutdown of this system
			for each(var database:ADatabase in databases) {
				var inUse:Boolean = false;
				for each(var ss:SystemContainer in systemSets) {
					if (ss == systemSet) continue;
					
					var requests:Vector.<DatabaseRequest> = queryRequests(ss)
					
					for each(var request:DatabaseRequest in requests) {
						var rlist:Vector.<Class> = request.requests
						for each(var cls:Class in rlist) {
							if (database is cls) {
								inUse = true;
								break;
							}
						}
					}
				}
				
				if (!inUse) {
					trash.push(database)
				}
			}
			
			for each(var db:ADatabase in trash) {
				removeDatabase(db);
			}
			
			removeSystem(systemSetID, groupID);
		}
		
		public function endGroup(groupID:String):void {
			var systemSets:Vector.<SystemContainer> = getSystemSetGroup(groupID);
			var databases:Vector.<ADatabase> = getDatabasesInGroup(groupID);
			
			for each(var systemSet:SystemContainer in systemSets) {
				removeSystem(systemSet.containerID, groupID)
			}
			
			for each(var database:ADatabase in databases) {
				removeDatabase(database)
			}
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
			
			for each(database in _databases) {
				if (database.groupID == groupID) {
					databases.push(database);
				}
			}
			
			return databases
		}
		
		
		private function queryRequests(systemSet:SystemContainer):Vector.<DatabaseRequest> {
			var requests:Vector.<DatabaseRequest> = new Vector<DatabaseRequest>;
			
			for (var i:int = 0; i < systemSet.numSystems; i++) {
				var sys:ISystem = systemSet.getSystemByIndex(i);
				var req:DatabaseRequest = sys.dataRequest;
				
				requests.push(req);
			}
			
			return requests
		}
		
		private function queryDatabases(systemSet:SystemContainer):Vector.<ADatabase> {
			
		}
		
	}

}