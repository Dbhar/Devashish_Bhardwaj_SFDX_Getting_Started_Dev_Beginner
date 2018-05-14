//This class handles operations on the Class__c Sobject
public class ClassManager {
    //Takes classid as a parameter and returns the list of the names of all students
    public static List<String> getStudents(Id classid){
        List<String> studentNames = new List<String>();
        for(Student__c student : [SELECT FirstName__c, LastName__c FROM Student__c WHERE Class__c = :classid]){
            studentNames.add(student.FirstName__c + ' ' + student.LastName__c);
        }
        return studentNames;
    }
    
    //Returns a mapping of class and the set of the Ids of all students in it
    public static Map<Id, Set<Id>> getStudents(){
        Map<Id, Set<Id>> studentsInClass = new Map<Id, Set<Id>>();
        List<Student__c> students = [SELECT Id, Class__c FROM Student__c];
        for(Student__c student : students){
            if(studentsInClass.get(student.class__c) != null){
                studentsInClass.get(student.Class__c).add(student.Id);
            }else{
                studentsInClass.put(student.Class__c, new Set<Id>{student.Id});
            }
        }
        return studentsInClass;
    }
}