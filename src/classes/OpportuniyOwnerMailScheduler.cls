global class OpportuniyOwnerMailScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
      	List<String> mailtoAddresses = new List<String>(); 
        for(Opportunity opp : [SELECT Owner.Email, LastModifiedDate FROM Opportunity]){
            if(opp.LastModifiedDate < Date.today().addDays(-30)){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setToAddresses(new List<String>{opp.Owner.Email});
                mail.setSubject('Opportunity Has Not been Updated For 30 Days');
        		String body = 'Hi ' + opp.Owner.Name;
        		body += 'Your Opportunity ' + opp.Name + ' has not been updated for more than 30 days';
        		mail.setHtmlBody(body);
                Messaging.sendEmail(new List<Messaging.Email>{mail});
            }
        }
    }
}