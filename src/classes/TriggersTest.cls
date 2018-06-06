@isTest
private class TriggersTest {
    private testMethod static void testDisallowDeletionOfClassWithFemaleStudents(){
        Class__c cls = new Class__c(ClassName__c = 'C1', MaxSize__c = 100);
        insert cls;
        List<Student__c> students = new List<Student__c>();
        Student__c student = new Student__c(LastName__c = 'Female', Class__c = cls.Id, Sex__c = 'Female');
        students.add(student);
        for(Integer i = 0; i < 99; i++){
            students.add(new Student__c(LastName__c = 'Male' + (i + 1), Class__c = cls.Id, Sex__c = 'Male'));
        }
        insert students;
        try{
            delete cls;
            System.assert(false, 'Class should not have been deleted');
        }catch(Exception e){
            System.assert(e.getMessage().contains('Cannot delete a class with female students'), 'Expected error to contain \'Cannot delete a class with female students\'');
        }
        System.assertEquals(1, [SELECT COUNT() FROM Class__c]);
        System.assertEquals(100, [SELECT COUNT() FROM Student__c]);
    }
    
    private static testMethod void testDisallowInsertionUpdationOfHindiTeacher(){
        Contact hindiTeacher = new Contact(LastName = 'XXX', Subjects__c = 'Hindi;English;Maths');
        try{
            insert hindiTeacher;
            System.assert(false, 'Record should not have been inserted');
        }catch(Exception e){
            System.assert(e.getMessage().contains('We don\'t want anymore Hindi Teachers'), 'Expected error to contain \'We don\'t want anymore Hindi Teachers\' got ' + e.getMessage());
        }
        
        Contact englishTeacher = new Contact(LastName = 'XXX', Subjects__c = 'English;Maths');
        insert englishTeacher;
        englishTeacher.Subjects__c = 'English;Maths;Hindi';
        try{
            update englishTeacher;
            System.assert(false, 'Record should not have been updated');
        }catch(Exception e){
            System.assert(e.getMessage().contains('A teachers subject can\'t be changed to hindi'), 'Expected error to contain \'A teachers subject can\'t be changed to hindi\' got ' + e.getMessage());
        }
    }
    
    private testMethod static void testOpportunityCloseDate(){
        Opportunity opp1 = new Opportunity(Name = 'Test Opp', StageName = 'Prospecting', CloseDate=Date.newInstance(2018, 1, 1));
        insert opp1;
        opp1.StageName = 'Closed Won';
        update opp1;
        opp1 = [SELECT CloseDate FROM Opportunity WHERE Id = :opp1.Id];
        System.assertEquals(Date.today(), opp1.CloseDate);
    }
    
    private testMethod static void testOpportunityReset(){
        Opportunity opp1 = new Opportunity(Name = 'Test Opp', StageName = 'Prospecting', CloseDate=Date.newInstance(2018, 1, 1));
        insert opp1;
        Id pricebookId = Test.getStandardPricebookId();
        Product2 prod = new Product2(Name = 'Product X', ProductCode = 'Pro-X', isActive = true);
        insert prod;
        PricebookEntry pbEntry = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id, UnitPrice = 100.00, IsActive = true);
        insert pbEntry;
        List<OpportunityLineItem> oppLitems = new List<OpportunityLineItem>();
        for(Integer i = 0; i < 200; i++){
            oppLitems.add(new OpportunityLineItem(OpportunityId = opp1.Id, Quantity = 2, PricebookEntryId = pbEntry.Id, TotalPrice = 200));
        }    
        insert oppLitems;
        opp1.Custom_Status__c = 'Reset';
        update opp1;
        System.assertEquals(0, [SELECT COUNT() FROM OpportunityLineItem]);
    }
    
    private static testMethod void testHandleLoanInsert(){
        List<CityManager__c> cityManagers = new List<CityManager__c>();
        for(Integer i = 0; i < 100; i++){
            cityManagers.add(new CityManager__c(City__c = 'Test City' + i, Manager__c = UserInfo.getUserId()));
        }
        insert cityManagers;
        cityManagers = [SELECT Id, Manager__c FROM CityManager__c ORDER BY Name];
        List<Loan__c> loans = new List<Loan__c>();
        for(Integer i = 0; i < 100; i++){
            loans.add(new Loan__c(Name = 'Test Loan' + i, CityManager__c = cityManagers.get(i).Id));
        }
        insert loans;
        loans = [SELECT Id, Manager__c FROM Loan__c ORDER BY Name];
        System.assertEquals(cityManagers.get(0).Manager__c, loans.get(0).Manager__c);
    }
    
    private static testMethod void testHandleMyCountAndMaxSize(){
        Class__c cls = new Class__c(ClassName__c = 'XXX', MaxSize__c = 100);
        insert cls;
        List<Student__c> students = new List<Student__c>();
        for(Integer i = 0; i < 50; i++){
            students.add(new Student__c(LastName__c = 'ST' + i, Class__c = cls.Id));
        }
        insert students;
        cls = [SELECT Id, MyCount__c FROM Class__c];
        System.assertEquals(50, cls.MyCount__c);
        cls.MyCount__c = 51;
        update cls;
        cls = [SELECT Id, MyCount__c, MaxSize__c FROM Class__c];
        System.assertEquals(51, cls.MyCount__c);
        students = new List<Student__c>();
        for(Integer i = 0; i < 51; i++){
            students.add(new Student__c(LastName__c = 'ST' + i, Class__c = cls.Id));
        }
        
        try{
            insert students;
            System.assert(false, 'Error was expected while inserting students');
        }catch(Exception e){
            System.assert(e.getMessage().contains('The class has already reached it\'s maximum size of ' + cls.MaxSize__c + '. More Students cannot be added'), e.getMessage());
        }
            
    }
    
    private testMethod static void testHandleOpportunityStatusChange(){
        List<Opportunity> opportunities = new List<Opportunity>();
        for(Integer i = 0; i < 500; i++){
            opportunities.add(new Opportunity(Name = 'Test Opp', StageName = 'Prospecting', CloseDate=Date.newInstance(2018, 1, 1), Custom_Status__c = 'New'));
        }
        insert opportunities;
        for(Opportunity opp : opportunities){
            opp.Custom_Status__c = 'Open';
        }
        try{
            Test.startTest();
            update opportunities;
            Test.stopTest();
        }catch(Exception e){
            System.assert(false, e);
        }
    }
    
    private testMethod static void testHandleChildAccounts(){
        List<Account> parentAccounts = new List<Account>();
        for(Integer i = 0 ; i < 10; i++){
            parentAccounts.add(new Account(Name = 'Parent Test Account' + i));
        }
        insert parentAccounts;
        Map<Id, List<Account>> childAccountsMap = new Map<Id, List<Account>>();
        List<Account> childAccountsToInsert = new List<Account>();
        for(Account acc : parentAccounts){
            List<Account> childAccounts = new List<Account>();
            for(Integer i = 0 ; i < 100; i++){
                Account ac = new Account(Name = 'Child Test Account' + i + ' - ' + acc.Name, Parent_Account__c = acc.Id);
                childAccounts.add(ac);
                childAccountsToInsert.add(ac);
            }
            childAccountsMap.put(acc.Id, childAccounts);
        }
        insert childAccountsToInsert;
        for(Account acc : [SELECT Child_Count__c FROM Account WHERE Id in :childAccountsMap.keySet()]){
            System.assertEquals(100, acc.Child_Count__c, 'Failed for ' + acc);
        }
        List<Id> parentAccountIds = new List<Id>(childAccountsMap.keySet());
        Id parent1Id = parentAccountIds.get(0);
        Id parent2Id = parentAccountIds.get(1);
        Account parent1Child1 = childAccountsMap.get(parent1Id).get(0);
        Account parent1Child2 = childAccountsMap.get(parent1Id).get(1);
        Account parent1Child3 = childAccountsMap.get(parent1Id).get(2);
        delete parent1Child1;
        parent1Child2.Parent_Account__c = null; 
        parent1Child3.Parent_Account__c = parent2Id;
        update new List<Account>{parent1Child2, parent1Child3};
        for(Account acc : [SELECT Id, Child_Count__c FROM Account WHERE Id IN :new Set<Id>{parent1Id, parent2Id}]){
            if(acc.Id == parent1Id){
                System.assertEquals(97, acc.Child_Count__c);
            }else{
                System.assertEquals(101, acc.Child_Count__c);
            }
        }
        
        for(Account acc : [SELECT Child_Count__c FROM Account WHERE Id in :childAccountsMap.keySet() AND Id NOT IN :new Set<Id>{parent1Id, parent2Id}]){
            System.assertEquals(100, acc.Child_Count__c, 'Failed For ' + acc);
        }
    }
}