trigger HandleMaxSizeAndMyCount on Student__c (before insert, before update) {
    Map<Id, Class__c> classes = new Map<Id, Class__c>();
    for(Class__c cls : [SELECT Id, MaxSize__c, NumberOfStudents__c FROM Class__c]){
        classes.put(cls.Id, cls);
    }
    for(Student__c student : Trigger.new){
        Decimal maxSize = classes.get(Student.Class__c).MaxSize__c;
        Decimal numberOfStudents = classes.get(Student.Class__c).NumberOfStudents__c;
        if(Trigger.IsInsert){
            if(maxSize == numberOfStudents){
            	student.addError('The class has already reached it\'s maximum size of ' + maxSize + '. More Students cannot be added');    
            }else{
            	classes.get(Student.Class__c).MyCount__c = numberOfStudents + 1;    
            }
        }else{
            classes.get(Student.Class__c).MyCount__c = numberOfStudents;
        } 
    }
    update classes.values();

}