public class OpportunityManager {
    public Static void updateManager(List<Opportunity> opportunities){
        //getting id map of all contacts 
        Map<Id, Contact> contacts = new Map<Id, Contact>([SELECT Id, AccountId FROM CONTACT]);
        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        for(Opportunity opp : opportunities){
            if(opp.Bill_To_Contact__c != null && opp.Manager__c == null){
                opp.Manager__c = contacts.get(opp.Bill_To_Contact__c).AccountId;
                opportunitiesToUpdate.add(opp);
                
            }
        }
        update opportunitiesToUpdate;
    }
}