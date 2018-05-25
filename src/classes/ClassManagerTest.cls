@isTest
private class ClassManagerTest {
    @testSetup
    private static void setup(){
        class__c cls1, cls2;
    	Student__c student1, student2, student3, student4;
    	cls1 = new Class__c(ClassName__c = 'C1', MaxSize__c = 100);
        cls2 = new Class__c(ClassName__c = 'C2', MaxSize__c = 100);
        system.debug(cls1);
        insert new List<Class__c>{cls1, cls2};
        student1 = new Student__c(LastName__c = 'XXX', Class__c = cls1.Id);
        student2 = new Student__c(LastName__c = 'XXY', FirstName__c = 'aaa', Class__c = cls1.Id);
        student3 = new Student__c(LastName__c = 'XXZ', Class__c = cls2.Id);
        student4 = new Student__c(LastName__c = 'XYY', Class__c = cls2.Id);
        insert new List<Student__c>{student1, student2, student3, student4};
    } 
    private testMethod static void testGetStudentsAsList(){
        Id classId = [SELECT Id FROM Class__c WHERE className__c = 'C1'].Id;
    	List<String> students = ClassManager.getStudents(classId);
        System.assertEquals(new List<String>{'XXX','aaa XXY'}, students);
    }
    
    private testMethod static void testGetStudentIdsAsMap(){
        Map<Id, Set<Id>> classMap = ClassManager.getStudents();
        List<Class__c> classes = [SELECT Id FROM Class__c ORDER BY Name];
        List<Student__c> students = [SELECT Id FROM Student__c ORDER BY LastName__c];
        System.assertEquals(new Map<Id, Set<Id>>{
            classes[0].Id => new Set<Id>{
                students[0].Id, Students[1].id},
            classes[1].Id => new Set<Id>{
                students[2].Id, Students[3].id}}, classMap);
        	
        
    }

}