@isTest
private class OpportunityManagerTest {
    private testMethod static void testUpdateManager(){
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Contact con = new Contact(LastName = 'Test Contact', AccountId = acc.Id);
        insert con;
        Opportunity opp1 = new Opportunity(Name = 'Test Opp', Bill_To_Contact__c = con.Id, StageName = 'Prospecting', CloseDate=Date.newInstance(2018, 1, 1));
        Opportunity opp2 = new Opportunity(Name = 'Test Opp', StageName = 'Prospecting', CloseDate=Date.newInstance(2018, 1, 1));
        insert new List<Opportunity>{opp1, opp2};
        opp1 = [SELECT Id, Bill_To_Contact__c, Manager__c FROM Opportunity WHERE Id = :opp1.Id];
        opp2 = [SELECT Id, Bill_To_Contact__c, Manager__c FROM Opportunity WHERE Id = :opp2.Id];
        OpportunityManager.updateManager(new List<Opportunity>{opp1, opp2});
        opp1 = [SELECT Manager__c FROM Opportunity WHERE Id = :opp1.Id];
        System.assertEquals(con.AccountId, opp1.Manager__c);
        opp2 = [SELECT Manager__c FROM Opportunity WHERE Id = :opp2.Id];
        System.assertEquals(null, opp2.Manager__c);
    }
}