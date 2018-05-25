@isTest
private class AccountManagerTest {
    private testMethod static void testPopulateContactIds(){
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Contact con1 = new Contact(LastName = 'Test Contact', AccountId = acc.Id);
        Contact con2 = new Contact(LastName = 'Test Contact2', AccountId = acc.Id);
        insert new List<Contact>{con1, con2};
        AccountManager.accountId = acc.Id;   
        AccountManager.populateContactIds(con1.Id);
        AccountManager.populateContactIds(con2.Id);
        acc = [SELECT ContactIds__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(con1.Id + ',' + con2.Id, acc.ContactIDs__c);
        Contact con3 = new Contact(LastName = 'Test Contact3', AccountId = acc.Id);
        insert con3;
        AccountManager.populateContactIds(con3.Id);
        acc = [SELECT ContactIds__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(con1.Id + ',' + con2.Id + ',' + con3.Id, acc.ContactIDs__c);
    }
}