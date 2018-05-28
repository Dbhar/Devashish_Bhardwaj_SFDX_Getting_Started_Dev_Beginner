trigger HandleOpportunityStatusChange on Opportunity (after update) {
    OpportunityStatusChangeMailer mailer = new OpportunityStatusChangeMailer();
    List<Opportunity> opportunitiesWithChangedStatus = new List<Opportunity>();
    for(Opportunity opp : Trigger.New){
            String oldStatus = Trigger.oldMap.get(opp.Id).Custom_Status__c;
            String newStatus = opp.Custom_Status__c;
            if(oldStatus != newStatus){
                opportunitiesWithChangedStatus.add(opp);
            }
    	}
    mailer.addMailMessages(opportunitiesWithChangedStatus);
    Boolean isMailSent = mailer.sendMail();
    if(!isMailSent){
        for(opportunity opp : OpportunitiesWithChangedStatus){
            opp.addError('Mail could not be sent');
        }
    }
}