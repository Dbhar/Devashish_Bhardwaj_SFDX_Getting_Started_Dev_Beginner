public class StudentAsPDFExtension {
    private Attachment studentDetails;
    public ApexPages.StandardController controller;
    public StudentAsPDFExtension(ApexPages.StandardController controller){
        this.controller = controller;
        
    }
    
    public PageReference saveAsPDF(){
        
        Id studentId = controller.getRecord().Id;
        PageReference currentPage = ApexPages.currentPage();
        delete [SELECT Id FROM Attachment WHERE ParentId = :studentId];
        currentPage.getParameters().put('id', studentId);
        studentDetails = new Attachment();
        if(!Test.isRunningTest()){
            studentDetails.Body = currentPage.getContentAsPDF();    
        }else{
            studentDetails.Body = Blob.valueOf(studentId);
        }
        
        studentDetails.ContentType = 'application/pdf';
        studentDetails.ParentId = studentId;
        studentDetails.Name = 'Student Details.pdf';
        insert studentDetails;
        System.debug(studentDetails);
        return new PageReference('/' + studentId);
       
    }
}