public class StudentWebsiteController {
    public String selectedStudentName{get;set;}
    public Set<String> studentNames{get;set;}
    public List<Student__c> students{get;set;}
    public StudentWebsiteController(){
        students = new List<Student__c>();
        studentNames = new Set<String>();
        for(Student__c student : [SELECT Id, Custom_Name__c FROM Student__c ORDER BY Custom_Name__c]){
            studentNames.add(student.Custom_Name__c);
        }
        System.debug(selectedStudentName);
    }
    
    public PageReference loadRecords(){
        System.debug(selectedStudentName);
        students = [SELECT Id, Custom_Name__c, DOB__c, Married__c, Class__r.Name FROM Student__c WHERE Custom_Name__c = :selectedStudentName];
        System.debug(students);
        return null;
    }

}