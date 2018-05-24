trigger ContactTrigger on Contact (before insert, before update) {
	
	
	if (Trigger.isBefore){
		
		if(Trigger.isInsert){
			ContactTriggerHandler.beforeInsert(Trigger.newMap);
		}
		
		if(Trigger.isUpdate){
			ContactTriggerHandler.beforeUpdate(Trigger.oldMap, Trigger.newMap);
		}
		
	}  
}