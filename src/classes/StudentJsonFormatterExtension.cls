public class StudentJsonFormatterExtension {
    public String studentAsJson{get;set;}
    public StudentJsonFormatterExtension(ApexPages.StandardController controller) {
        List<String> studentFields = new List<String>(Student__c.SObjectType.getDescribe().fields.getMap().keySet());
        controller.addFields(studentFields);
        Student__c student = (Student__c)controller.getRecord();
        System.debug(student.FirstName__c);
        studentAsJson = JSon.serializePretty(student);
    }
}