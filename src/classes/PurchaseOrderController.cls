public class PurchaseOrderController {
    public Purchase_Order__c purchaseOrder{get;set;}
    public Map<Id, Purchase_Order_Line_Item__c> lineItemMap{get;set;}
    private Map<Id, Purchase_Order_Line_Item__c> itemToLineItemMap;
    public List<Purchase_Order_Line_Item__c> lineItems{get;set;}
    public List<Item__c> items{get;set;}
    
    public PurchaseOrderController(){
        Id purchaseOrderId = ApexPages.currentPage().getParameters().get('id');
        purchaseOrder = [SELECT Partner_Account__r.Name, Name, Type_of_smart_pack_assembly__c FROM Purchase_Order__c WHERE Id = :purchaseOrderId];
        lineItemMap = new Map<Id, Purchase_Order_Line_Item__c>();
        itemToLineItemMap = new Map<Id, Purchase_Order_Line_Item__c>();
        String itemCategoryDefaultValue = (String)Item__c.Category__c.getDescribe().getDefaultValue();
        items = [SELECT Id, Name, Item_Name__c, Category__c, Price__c FROM Item__c ];
        for(Purchase_Order_Line_Item__c lineItem : [SELECT Id, Item__c, Item_Code__c, Item_Name__c, It_is_Smart_Pack__c, Quantity__c, Unit_Price__c, Total_Price__c FROM Purchase_Order_Line_Item__c WHERE Purchase_Order__c = :purchaseOrder.Id]){
           lineItemMap.put(lineItem.Id, lineItem);
           itemToLineItemMap.put(lineItem.Item__c, lineItem); 
        }
        lineItems  = lineItemMap.values();
    }
    
    public void saveLineItem(){
        id lineItemId = ApexPages.currentPage().getParameters().get('lId');
        Decimal quantity = lineItemMap.get(lineItemId).Quantity__c;
        handleLineItemUpdate(lineItemId, Quantity);
    }
    
    public void deleteLineItem(){
        id lineItemId = ApexPages.currentPage().getParameters().get('lId');
        handleLineItemUpdate(lineItemId, 0);
    }
    
    public void addItem(){
        Id itemId = ApexPages.currentPage().getParameters().get('itemId');
        System.debug(itemId);
        Purchase_Order_Line_Item__c lineItem = itemToLineItemMap.get(itemId);
        if(lineItem == null){
            createLineItem(1, itemId);
        }else{
            Decimal quantity = lineItem.Quantity__c + 1;
            handleLineItemUpdate(lineItem.Id, quantity);
        }
    }
    
    private void createLineItem(Decimal quantity, Id itemId){
        Purchase_Order_Line_Item__c lineItem = new Purchase_Order_Line_Item__c(Item__c = itemId, Purchase_Order__c = purchaseOrder.Id, Quantity__c = quantity);
        insert lineItem;
        reloadLineItem(lineItem.Id);
    }
    
    private void handleLineItemUpdate(Id lineItemId, Decimal quantity){
        if(quantity == 0){
            Purchase_Order_Line_Item__c lineItem = [SELECT Id, Item__c FROM Purchase_Order_Line_Item__c WHERE Id = :lineItemId];
            delete lineItem;
            lineItemMap.remove(lineItemId);
            itemToLineItemMap.remove(lineItem.Item__c);
            lineItems = lineItemMap.values();
        }else{
            Purchase_Order_Line_Item__c lineItem = new Purchase_Order_Line_Item__c(Id = lineItemId, Quantity__c = quantity);
        	update lineItem;
            reloadLineItem(lineItemId);
        }
    }
    
    private void reloadLineItem(Id lineItemId){
        Purchase_Order_Line_Item__c lineItem = [SELECT Id, Item__c, Item_Code__c, Item_Name__c, It_is_Smart_Pack__c, Quantity__c, Unit_Price__c, Total_Price__c FROM Purchase_Order_Line_Item__c WHERE Id = :lineItemId];
        lineItemMap.put(lineItemId, lineItem);
        itemToLineItemMap.put(lineItem.Item__c, lineItem);
        lineItems = lineItemMap.values();
    }
    
    
}