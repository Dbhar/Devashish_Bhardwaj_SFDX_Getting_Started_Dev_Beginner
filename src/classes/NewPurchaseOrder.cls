public class NewPurchaseOrder {
    public ApexPages.StandardController controller{get;set;}
    public NewPurchaseOrder(ApexPages.StandardController controller){
        this.controller = controller;
    }
    
    public PageReference save(){
        controller.save();
        return new PageReference('/apex/PurchaseOrder?id=' + controller.getId());
    }

}