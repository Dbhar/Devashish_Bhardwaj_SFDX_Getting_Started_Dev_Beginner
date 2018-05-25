trigger HandleMaxSizeAndMyCount on Student__c (before insert, before update) {
    Map<Id, Class__c> classes = new Map<Id, Class__c>();
    Map<Id, Decimal> numberOfStudents = new Map<Id, Decimal>();
    for(Class__c cls : [SELECT Id, MaxSize__c, NumberOfStudents__c, MyCount__c FROM Class__c]){
        classes.put(cls.Id, cls);
        numberOfStudents.put(cls.Id, cls.NumberOfStudents__c);
    }
    
    for(Student__c student : Trigger.new){
        Decimal maxSize = classes.get(Student.Class__c).MaxSize__c;
        if(Trigger.IsInsert){
            if(maxSize == numberOfStudents.get(Student.Class__c)){
            	student.addError('The class has already reached it\'s maximum size of ' + maxSize + '. More Students cannot be added');    
            }else{
                numberOfStudents.put(Student.Class__c, numberOfStudents.get(student.Class__c) + 1);
            	classes.get(Student.Class__c).MyCount__c = numberOfStudents.get(Student.Class__c);    
            }
        }else{
            classes.get(Student.Class__c).MyCount__c = numberOfStudents.get(Student.Class__c);
        } 
    }
    update classes.values();

}