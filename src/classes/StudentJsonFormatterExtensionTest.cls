@isTest
private class StudentJsonFormatterExtensionTest {
    private testMethod static void testJson(){
        Class__c cls = new Class__c(ClassName__c = 'C1', MaxSize__c = 100);
        insert cls;
        Student__c student = new Student__c(LastName__c = 'XXX', Class__c = cls.Id);
        insert student;
        String expectedJson = Json.serializePretty(student);
        StudentJsonFormatterExtension ext = new StudentJsonFormatterExtension(new ApexPages.StandardController(student));
        System.assertEquals(expectedJson, ext.studentAsJson);
    }
}