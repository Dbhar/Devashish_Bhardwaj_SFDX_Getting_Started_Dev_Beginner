trigger handleChildAccounts on Account (after Insert, after update, after delete) {
    Map<Id, Integer> childCounts = new Map<Id, Integer>();
    for(Account acc : [SELECT Id, Child_Count__c FROM Account]){
        childCounts.put(acc.Id, (Integer)acc.Child_Count__c);
    }
    if(Trigger.isUpdate || Trigger.isInsert){
        List<Id> accountsToUpdateIds = new List<Id>();
        for(Account acc : Trigger.New){
            if(acc.Parent_Account__c != null){
                childCounts.put(acc.Parent_Account__c, childCounts.get(acc.Parent_Account__c) + 1);
                accountsToUpdateIds.add(acc.Parent_Account__c);
            }  
        }
        if(Trigger.IsUpdate){
        	for(Account acc : Trigger.old){
                if(acc.Parent_Account__c != null){
                    Id accountToDecreaseCountId = acc.Parent_Account__c;
                    Integer decreasedCount = childCounts.get(accountToDecreaseCountId) - 1;
                    if(decreasedCount < 0){
                        decreasedCount = 0;
                    }
                    childCounts.put(accountToDecreaseCountId, decreasedCount);
                    accountsToUpdateIds.add(accountToDecreaseCountId);
                }
            }
        }
        
        System.debug(childCounts);
        List<Account> accountsToUpdate = [SELECT Id FROM Account WHERE Id IN :accountsToUpdateIds];
        for(Account acc : accountsToUpdate){
            acc.Child_Count__c = childCounts.get(acc.Id);
        }
        update accountsToUpdate;
    }else{
        List<Id> accountsToUpdateIds = new List<Id>();
        for(Account acc : Trigger.old){
            if(acc.Parent_Account__c != null){
                Integer newChildCount = childCounts.get(acc.Parent_Account__c) - 1;
                if(newChildCount < 0){
                	newChildCount = 0;        
                }    
                childCounts.put(acc.Parent_Account__c, newChildCount);
                accountsToUpdateIds.add(acc.Parent_Account__c);
            }
        }
        List<Account> accountsToUpdate = [SELECT Id FROM Account WHERE Id IN :accountsToUpdateIds];
        for(Account acc : accountsToUpdate){
            acc.Child_Count__c = childCounts.get(acc.Id);
        }
        update accountsToUpdate;
    }
}