public without sharing class ContactTriggerHandler {
	
	public static void beforeInsert(Map<Id,Contact> newMap){
		refreshContactAmountInAccounts(null,newMap);
	}
	
	public static void beforeUpdate(Map<Id,Contact> oldMap, Map<Id,Contact> newMap){
		refreshContactAmountInAccounts(oldMap,newMap);
	}
    
    public static void refreshContactAmountInAccounts(Map<Id,Contact> oldMap, Map<Id,Contact> newMap){
    	Contact oldContact, newContact;
    	Map<Id,Account> relatedAccounts = getAccountsOfContacts(oldMap, newMap);
    	List<Account> accountsToUpdate = new List<Account>();
    	for(Id contactId : newMap.keySet()){
    		if(oldMap != null){
    			oldContact = oldMap.get(contactId);
    		}
    		newContact = newMap.get(contactId);
    		if(oldContact != null &&
    			oldContact.AccountId != newContact.AccountId){
    			accountsToUpdate.add(increaseContactCountInAccount(relatedAccounts.get(newContact.AccountId)));
    			accountsToUpdate.add(decreaseContactCountInAccount(relatedAccounts.get(oldContact.AccountId)));
    		}else if (oldContact == null){
    			accountsToUpdate.add(increaseContactCountInAccount(relatedAccounts.get(newContact.AccountId)));
    		}
    	}
    	
    	update accountsToUpdate;
    }
    
    private static Account increaseContactCountInAccount(Account acc){
    	Account resultAcc = acc;
    	
    	resultAcc.NumberOfRelatedContacts__c++;
    	
    	return resultAcc;
    }
    
    private static Account decreaseContactCountInAccount(Account acc){
    	Account resultAcc = acc;
   		
    	resultAcc.NumberOfRelatedContacts__c--;
    	
    	return resultAcc;
    }
    
    private static Map<Id, Account> getAccountsOfContacts(Map <Id, Contact> oldMap, Map<Id,Contact> newMap){
    	Set<Id> accountIds = new Set<Id>();
    	if(oldMap != null){
    		for(Id contactId : oldMap.keySet()){
    		accountIds.add(oldMap.get(contactId).AccountId);
    		}
    	}
    	for(Id contactId : newMap.keySet()){
    		accountIds.add(newMap.get(contactId).AccountId);
    	}
    	return new Map<Id, Account>([SELECT Id, NumberOfRelatedContacts__c FROM Account WHERE Id IN :accountIds]);
    }
}