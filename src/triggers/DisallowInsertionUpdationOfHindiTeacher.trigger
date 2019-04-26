trigger DisallowInsertionUpdationOfHindiTeacher on Contact (before insert, before update) {
    for(Contact con : Trigger.new){
        if(con.Subjects__c != null && con.Subjects__c.contains('Hindi')){
            con.addError('We don\'t want anymore Hindi Teachers and Hindi Teacher\'s records cannot be updated');
        }
    }

}