public class DeleteStudentsController {
    public ApexPages.StandardSetController controller{get;set;}
    public List<Student__c> selectedStudents{get;private set;}
    public Boolean hasRecordsToDelete{get;set;}
    public DeleteStudentsController(ApexPages.StandardSetController con){
        this.controller = con;
        if(!Test.isRunningTest()){
     		controller.addFields(new List<String>{'FirstName__c','LastName__c','DOB__c','Age__c','Married__c'});       
        }
        selectedStudents = controller.getSelected();
        if(selectedStudents.size() == 0){
            hasRecordsToDelete = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No records selected'));
        }else{
            hasRecordsToDelete = true;
        }    
    }
    
    public PageReference deleteRecords(){
        delete selectedStudents;
        return returnToListView();
    }
	
    public pageReference cancel(){
        return returnToListView();
    }
    
    private PageReference returnToListView(){
        return controller.cancel();
    }
}