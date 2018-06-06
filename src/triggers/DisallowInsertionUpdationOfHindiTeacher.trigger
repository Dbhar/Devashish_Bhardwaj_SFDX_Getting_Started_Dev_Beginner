trigger DisallowInsertionUpdationOfHindiTeacher on Contact (before insert, before update) {
    if(Trigger.isInsert){
        for(Contact con : Trigger.new){
            if(con.Subjects__c != null && con.Subjects__c.contains('Hindi')){
                con.addError('We don\'t want anymore Hindi Teachers');
            }
        }
    }else{
        for(Contact con : Trigger.new){
            if(con.Subjects__c != null && con.Subjects__c.contains('Hindi') && !Trigger.oldMap.get(con.id).Subjects__c.contains('Hindi')){
                con.addError('A teachers subject can\'t be changed to hindi');
            }
        }
    }    
}