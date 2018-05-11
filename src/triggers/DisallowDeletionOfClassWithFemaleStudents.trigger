trigger DisallowDeletionOfClassWithFemaleStudents on Class__c (before delete) {
    for(Student__c student : [SELECT Id, Class__c FROM Student__c WHERE Sex__c = 'Female' AND Class__c in :Trigger.oldMap.keySet()]){
        System.debug(student);
        Trigger.oldMap.get(student.Class__c).addError('Cannot delete a class with female students');
    }

}