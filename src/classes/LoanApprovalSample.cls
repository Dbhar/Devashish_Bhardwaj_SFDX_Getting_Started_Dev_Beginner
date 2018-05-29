//Example Class For Submitting a Dummy loan for approval process
//This class is for documenting Submitting and Approving approval process through code 
public class LoanApprovalSample {
    public static void SubmitAndProcessApprovalRequest(){
        //Create a loan
        CityManager__c cityManager = new CityManager__c(City__c = 'Test City', Manager__c = UserInfo.getUserId());
        insert cityManager;
        Loan__c loan = new Loan__c(Name = 'Test Loan', Amount__c = 50000, CityManager__c = cityManager.Id);
        insert loan;
        
        //Create an Approval process
        Approval.ProcessSubmitRequest submitRequest = new Approval.ProcessSubmitRequest();
        submitRequest.setComments('Submitting Request For Approval'); // Sets the comments to be added to the approval request
        submitRequest.setObjectId(loan.Id); //Sets the ID of the record to be submitted for approval
        
        //Submit on behalf of the designated user
        submitRequest.setSubmitterId(UserInfo.getUserId());
        
        //Submit the record to the specific process and skip criteria evaluation
        submitRequest.setProcessDefinitionNameOrId('Loan_Approval_Mail');
        submitRequest.setSkipEntryCriteria(true);
        
        //Submit the approval request for Loan
        Approval.ProcessResult submitResult = Approval.process(submitRequest);
        
        //Verify that request has been submitted;
        System.assert(submitResult.isSuccess(), 'Result Status ' + submitResult.isSuccess());
        System.assertEquals('Pending', submitResult.getInstanceStatus(), 'Instance Status ' + submitResult.getInstanceStatus());
        
        
        //Approve the submitted request
        //First get the Id of the newly created item
        List<Id> newWorkItemIds = submitResult.getNewWorkitemIds();
        
        //Instantiate the new ProcessWorkitemRequest object and populate it
        Approval.ProcessWorkitemRequest approvalRequest = new Approval.ProcessWorkitemRequest();
        approvalRequest.setAction('Approve');
        approvalRequest.setComments('Approved');
        approvalRequest.setWorkitemId(newWorkItemIds.get(0));
        
        //Approve the request
        Approval.ProcessResult approvalResult = Approval.process(approvalRequest);
        
        //Verify the result
        System.assert(approvalResult.isSuccess(), 'Result Status ' + approvalResult.isSuccess());
        System.assertEquals('Approved', approvalResult.getInstanceStatus(), 'Instance Status ' + approvalResult.getInstanceStatus());
    }

}