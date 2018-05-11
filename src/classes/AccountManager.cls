public class AccountManager {
    public Static Id accountId{get; public set;}
    public static void populateContactIds(Id contactId){
        Account acc = [SELECT ContactIds__c FROM Account WHERE Id = :accountId];
        String contactIds = '';
        for(Contact c : [SELECT Id FROM Contact WHERE AccountId = :accountId]){
                contactIds += c.Id + ',';
        }
        contactIds = contactIds.removeEnd(',');
        if(acc.ContactIDs__c == null || acc.ContactIDs__c == ''){
            acc.ContactIDs__c = contactIds;
        }else if(!acc.ContactIDs__c.contains(contactId) && contactIds.contains(contactId)){
            acc.ContactIDs__c += ','+contactId;
        }
        update acc;
    }

}