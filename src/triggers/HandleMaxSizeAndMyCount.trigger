trigger HandleMaxSizeAndMyCount on Student__c (before insert, before update) {
    //Map<ClassId, Class__c>
    Map<Id, Class__c> classes = new Map<Id, Class__c>([SELECT Id, MaxSize__c, NumberOfStudents__c, MyCount__c FROM Class__c]);
    //Map<ClassId, Class__c>
    Map<Id, Class__c> classesToUpdate = new Map<Id, Class__c>();
    for(Student__c student : Trigger.new){
        Class__c cls = classes.get(Student.Class__c); 
        Decimal maxSize = classes.get(Student.Class__c).MaxSize__c;
        Decimal myCount;
        if(!classesToUpdate.containsKey(cls.Id))
        	myCount = cls.NumberOfStudents__c;
        else
            myCount = cls.MyCount__c;	
        if(Trigger.IsInsert){
            if(maxSize == myCount){
                student.addError('The class has already reached it\'s maximum size of ' + maxSize + '. More Students cannot be added');    
            }else{
                myCount += 1;
                cls.MyCount__c = myCount;
                classesToUpdate.put(cls.Id, cls);    
            }
        }else{
            cls.MyCount__c = myCount;
            classesToUpdate.put(cls.Id, cls);
        } 
    }
    System.debug(classesToUpdate);
    update classesToUpdate.values();

}