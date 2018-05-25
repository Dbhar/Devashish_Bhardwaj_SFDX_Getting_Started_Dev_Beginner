@isTest
private class StudentAsPDFExtensionTest {
    private static testMethod void testPDFExtension(){
    	Class__c cls = new Class__c(ClassName__c = 'C1', MaxSize__c = 100);
     	insert cls;
     	Student__c student = new Student__c(LastName__c = 'XXX', Class__c = cls.Id);
     	insert student;
        Test.setCurrentPage(Page.StudentAsPDF);
        StudentAsPDFExtension ext = new StudentAsPDFExtension(new ApexPages.StandardController(student));
        String redirectUrl = ext.saveAsPDF().getUrl();
        String expectedUrl = new PageReference('/' + student.Id).getUrl();
        System.assertEquals(expectedUrl, redirectUrl);
        List<Attachment> content = [SELECT Id, Body, ContentType, Name FROM Attachment WHERE ParentID = :student.Id];
        System.assertEquals(1, content.size());
        System.assertEquals(Blob.valueOf(student.Id), content[0].Body);
        System.assertEquals('application/pdf', content[0].ContentType);
        System.assertEquals('Student Details.pdf', content[0].Name);
    }
}