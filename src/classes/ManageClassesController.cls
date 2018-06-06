public class ManageClassesController {
    //public ApexPages.StandardSetController controller{get;set;}
    public List<Class__c> classes{get;set;}
    public Id recordId{get;set;}
    public Class__c mockClass{get;set;}
    public Boolean isRecordBeingEdited{get;set;}
    public ManageClassesController(){
                fetchRecords();
    }
    
    public void deleteRecord(){
        System.debug(recordId);
        delete [SELECT Id FROM Class__c WHERE Id = :recordId];    
        fetchRecords();
        isRecordBeingEdited = false;
    }
    
    public void edit(){
        isRecordBeingEdited = true;
        mockClass = [SELECT Id, ClassName__c, Fee__c, ClassTeacher__c, Board__c, MaxSize__c FROM Class__c WHERE Id = :recordId];
    }
    
    public void saveRecord(){
        Class__c cls = new Class__c(Id = mockClass.Id,ClassName__c = mockClass.ClassName__c,
                                    Fee__c = mockClass.Fee__c,
                                    Board__c = mockClass.Board__c,
                                    MaxSize__c = mockClass.MaxSize__c,
                                    ClassTeacher__c = mockClass.ClassTeacher__c);
        update cls;
        fetchRecords();
        isRecordBeingEdited = false;
    }
    
    public void cancel(){
        mockClass = new Class__c();
        isRecordBeingEdited = false;
    }
    
    public void fetchRecords(){
        //controller = new ApexPages.StandardSetController([SELECT Id, ClassName__c, Fee__c, ClassTeacher__c, Board__c, MaxSize__c FROM Class__c]);
        //classes = controller.getRecords();
        classes = [SELECT Id, ClassName__c, Fee__c, ClassTeacher__c, Board__c, MaxSize__c FROM Class__c];
    }
}