public class OpportunityManager {
    public Static void updateManager(List<Opportunity> opportunities){
        //Query opportunities with the Bill_To_Contact field if not done by the caller.  
        List<Id> opportunityIds = new List<Id>();
        for(Opportunity opp : Opportunities){
            opportunityIds.add(opp.Id);
        }
        opportunities = [SELECT Id, Bill_To_Contact__c FROM Opportunity WHERE Id IN :opportunityIds];
        for(Opportunity opp : opportunities){
            if(opp.Bill_To_Contact__c != null){
                opp.Manager__c = [SELECT AccountId FROM Contact WHERE Id = :opp.Bill_To_Contact__c].AccountId;
            }
        }
        update opportunities;
    }
}