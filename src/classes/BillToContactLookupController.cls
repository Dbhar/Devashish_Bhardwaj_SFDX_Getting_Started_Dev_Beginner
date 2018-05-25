public class BillToContactLookupController {
    public Opportunity opp{get;set;}
    public List<SelectOption> options{get;set;}
    public List<Contact> contacts{get;set;}
    public Id selectedContactId{get;set;}
    public BillToContactLookupController(){
        Id opportunityId = ApexPages.currentPage().getParameters().get('oppId');
        options = new List<SelectOption>();
        opp = [SELECT Id, Bill_To_Contact__c, Manager__c, Manager__r.Name FROM Opportunity WHERE Id = :opportunityId];
        selectedContactId = opp.Bill_To_Contact__c;
        contacts = [SELECT Id, Name, Subjects__c, Account.Name FROM Contact WHERE (AccountId != NULL AND AccountId = :opp.Manager__c) ORDER BY NAME];
        for(Contact c : contacts){
            options.add(new SelectOption(c.Id, 'Name : ' + c.Name + ' Subjects : ' + c.Subjects__c));
        }
    }
    
    public PageReference save(){
        opp.Bill_To_Contact__c = selectedContactId;
        update opp;
        return redirectToOpportunity();
    }
    
    public PageReference clear(){
        opp.Bill_To_Contact__c = null;
        update opp;
        return redirectToOpportunity();
        
    }
    
    public PageReference cancel(){
        return redirectToOpportunity();
    }
    
    public PageReference redirectToOpportunity(){
        return new PageReference('/' + opp.Id);
    }
}