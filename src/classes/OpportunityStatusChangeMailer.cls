public class OpportunityStatusChangeMailer {
    private List<Messaging.SingleEmailMessage> emailMessages;
    private EmailTemplate mailTemplate;
    public OpportunityStatusChangeMailer(){
        mailTemplate = [SELECT Id, Name FROM EmailTemplate WHERE Name = 'Opportunity Status Changed' AND IsActive = true LIMIT 1];
    	emailMessages = new List<Messaging.SingleEmailMessage>();
    }
    
    public void addMailMessages(List<Opportunity> opportunities){
        Map<Id, User> oppOwners = new Map<Id, User>();
        Map<Id, User> users = new Map<Id, User>();
        for(User usr : [SELECT Id, Email FROM User]){
            users.put(usr.Id, usr);
        }
        
        for(Opportunity opp : opportunities){
            User owner = users.get(opp.OwnerId);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        	mail.setTemplateId(mailTemplate.Id);
        	mail.setTargetObjectId(owner.Id);
            mail.setSaveAsActivity(false);
            emailMessages.add(mail);
        }
    }
    
    public Boolean sendMail(){
        System.debug(emailMessages);
        List<Messaging.SendEmailResult> emailResults = Messaging.sendEmail(emailMessages, false);
        System.debug(emailResults);
        for(Messaging.SendEmailResult emailResult : emailResults){
            if(!emailResult.isSuccess()){
                return false;
            }        
        }
        return true;
    }
    

}