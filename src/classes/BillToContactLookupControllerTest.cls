@isTest
private class BillToContactLookupControllerTest {
    @testSetup
    private static void setup(){
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        List<Contact> contacts = new List<Contact>();
        for(Integer i = 0; i < 10; i++){
            contacts.add(new Contact(LastName = 'Test Contact' + i, AccountId = acc.Id));
        }
        insert contacts;
        Opportunity opp = new Opportunity(Name = 'Test Opp', Manager__c = acc.Id, StageName = 'Prospecting', CloseDate=Date.newInstance(2018, 1, 1));
    	insert opp;
    }
    
    private static testMethod void testLoad(){
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account'];
        Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE Name = 'Test Opp'];
        Test.setCurrentPage(Page.BillToContactLookup);
        ApexPages.currentPage().getParameters().put('oppId', opp.Id);
        BillToContactLookUpController controller = new BillToContactLookupController();
        System.assertEquals([SELECT Id, Name, Subjects__c, Account.Name FROM Contact WHERE AccountId = :acc.Id], controller.contacts);
    }
    
    private static testMethod void testSaveClearCancel(){
        //Save
        Account acc = [SELECT Id FROM Account WHERE Name = 'Test Account'];
        Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE Name = 'Test Opp'];
        Test.setCurrentPage(Page.BillToContactLookup);
        ApexPages.currentPage().getParameters().put('oppId', opp.Id);
        BillToContactLookUpController controller = new BillToContactLookupController();
        Id ContactId = controller.contacts.get(0).Id;
        controller.selectedContactId = contactId;
        PageReference redirected = controller.save();
        String url = redirected.getUrl();
        System.assertEquals(new PageReference('/' + opp.Id).getUrl(), url);
        opp = [SELECT Id, Name, Bill_To_Contact__c FROM Opportunity WHERE Name = 'Test Opp'];
        System.assertEquals(contactId, opp.Bill_To_Contact__c);
        
        //cancel
        Test.setCurrentPage(Page.BillToContactLookup);
        ApexPages.currentPage().getParameters().put('oppId', opp.Id);
        controller = new BillToContactLookupController();
        controller.selectedContactId = controller.contacts.get(1).Id;
        redirected = controller.cancel();
        url = redirected.getUrl();
        System.assertEquals(new PageReference('/' + opp.Id).getUrl(), url);
        opp = [SELECT Id, Name, Bill_To_Contact__c FROM Opportunity WHERE Name = 'Test Opp'];
        System.assertEquals(contactId, opp.Bill_To_Contact__c);
        
        //clear
        Test.setCurrentPage(Page.BillToContactLookup);
        ApexPages.currentPage().getParameters().put('oppId', opp.Id);
        controller = new BillToContactLookupController();
        controller.selectedContactId = controller.contacts.get(2).Id;
        redirected = controller.clear();
        url = redirected.getUrl();
        System.assertEquals(new PageReference('/' + opp.Id).getUrl(), url);
        opp = [SELECT Id, Name, Bill_To_Contact__c FROM Opportunity WHERE Name = 'Test Opp'];
        System.assertEquals(null, opp.Bill_To_Contact__c);
    }
    
}