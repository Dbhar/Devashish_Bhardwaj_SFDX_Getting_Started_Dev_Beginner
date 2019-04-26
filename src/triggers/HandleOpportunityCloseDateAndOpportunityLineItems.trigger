trigger HandleOpportunityCloseDateAndOpportunityLineItems on Opportunity (before update, after update) {
    //Handle opportunity Close Date
    if(Trigger.IsBefore){
    	for(Opportunity opp : Trigger.New){
            String oldStatus = Trigger.oldMap.get(opp.Id).StageName;
            String newStatus = opp.StageName;
            if((oldStatus != newStatus) && (newStatus == 'Closed Won' || newStatus == 'Closed Lost')){
                opp.CloseDate = Date.today();
            }
    	}    
    }
    
    if(Trigger.IsAfter){
        //Delete OpportunityLineItems if Custom Status is Changed to Reset
        List<OpportunityLineItem> oppLineItemsToDelete = new List<OpportunityLineItem>();
        for(OpportunityLineItem oppLineItem : [SELECT Id,OpportunityId FROM OpportunityLineItem WHERE OpportunityId in :Trigger.NewMap.keySet()]){
            String oldOpportunityStatus = Trigger.oldMap.get(oppLineItem.OpportunityId).Custom_Status__c;
            String newOpportunityStatus = Trigger.NewMap.get(oppLineItem.OpportunityId).Custom_Status__c;
            if(oldOpportunityStatus != newOpportunityStatus && newOpportunityStatus == 'Reset'){
                oppLineItemsToDelete.add(oppLineItem);
            }
        }
        delete oppLineItemsToDelete;
    }
    
}