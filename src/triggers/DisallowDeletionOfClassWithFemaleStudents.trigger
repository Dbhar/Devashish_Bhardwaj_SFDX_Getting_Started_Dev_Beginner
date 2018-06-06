trigger DisallowDeletionOfClassWithFemaleStudents on Class__c (before delete) {
    Set<Id> classesWithFemaleStudents = new Set<Id>();
    
    for(Student__c student : [SELECT Id, Class__c FROM Student__c WHERE Sex__c = 'Female' AND Class__c in :Trigger.oldMap.keySet()]){
        classesWithFemaleStudents.add(Student.class__c);
    }
    
    for(Id classId : classesWithFemaleStudents){
        Trigger.oldMap.get(classId).addError('Cannot delete a class with female students');
    }    
}