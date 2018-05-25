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
            System.assert(e.getMessage().contains('We don\'t want anymore Hindi Teachers and Hindi Teacher\'s records cannot be updated'), 'Expected error to contain \'We don\'t want anymore Hindi Teachers and Hindi Teacher\'s records cannot be updated\' got ' + e.getMessage());
        }
        
        Contact englishTeacher = new Contact(LastName = 'XXX', Subjects__c = 'English;Maths');
        insert englishTeacher;
        englishTeacher.Subjects__c = 'English;Maths;Hindi';
        try{
        	update englishTeacher;
            System.assert(false, 'Record should not have been updated');
        }catch(Exception e){
            System.assert(e.getMessage().contains('We don\'t want anymore Hindi Teachers and Hindi Teacher\'s records cannot be updated'), 'Expected error to contain \'We don\'t want anymore Hindi Teachers and Hindi Teacher\'s records cannot be updated\' got ' + e.getMessage());
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
}