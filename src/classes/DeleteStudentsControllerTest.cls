@isTest
private class DeleteStudentsControllerTest {
    private testMethod static void testDeleteRecords(){
        Class__c cls = new Class__c(ClassName__c = 'C1', MaxSize__c = 100);
        insert cls;
        Student__c student = new Student__c(LastName__c = 'XXX', Class__c = cls.Id);
        insert student;
        ApexPages.StandardSetController stdSetcntrl = new ApexPages.StandardSetController(new List<Student__c>{student});
        stdSetcntrl.setSelected(new List<SObject>{student});
        DeleteStudentsController controller = new DeleteStudentsController(stdSetcntrl);
        String redirectUrl = controller.deleteRecords().getUrl();
        System.assertEquals(stdSetcntrl.cancel().getUrl(), redirectUrl);
        System.assertEquals(0, [SELECT COUNT() FROM Student__c]);
    }
    
    private testMethod static void testcancel(){
        Class__c cls = new Class__c(ClassName__c = 'C1', MaxSize__c = 100);
        insert cls;
        Student__c student = new Student__c(LastName__c = 'XXX', Class__c = cls.Id);
        insert student;
        ApexPages.StandardSetController stdSetcntrl = new ApexPages.StandardSetController(new List<Student__c>{student});
        stdSetcntrl.setSelected(new List<SObject>{student});
        DeleteStudentsController controller = new DeleteStudentsController(stdSetcntrl);
        String redirectUrl = controller.cancel().getUrl();
        System.assertEquals(stdSetcntrl.cancel().getUrl(), redirectUrl);
        System.assertEquals(1, [SELECT COUNT() FROM Student__c]);
    }
    
    private testMethod static void testError(){
        Class__c cls = new Class__c(ClassName__c = 'C1', MaxSize__c = 100);
        insert cls;
        Student__c student = new Student__c(LastName__c = 'XXX', Class__c = cls.Id);
        insert student;
        ApexPages.StandardSetController stdSetcntrl = new ApexPages.StandardSetController(new List<Student__c>{student});
        Test.setCurrentPage(Page.DeleteStudents);
        DeleteStudentsController controller = new DeleteStudentsController(stdSetcntrl);
        System.assert(ApexPages.hasMessages(ApexPages.Severity.ERROR));
       
        System.assertEquals('No records selected', ApexPages.getMessages().get(0).getSummary());
    }


}