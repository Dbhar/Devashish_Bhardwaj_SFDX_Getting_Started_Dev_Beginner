public class PurchaseOrderController {
    public Purchase_Order__c purchaseOrder{get{
        	Id purchaseOrderId = ApexPages.currentPage().getParameters().get('id');
        	purchaseOrder = [SELECT Partner_Account__r.Name, Name, Type_of_smart_pack_assembly__c FROM Purchase_Order__c WHERE Id = :purchaseOrderId];
   			return purchaseOrder;
    	}private set;}
    
    private Map<Id, Purchase_Order_Line_Item__c> itemToLineItemMap;
    
    public List<Purchase_Order_Line_Item__c> lineItems{get;set;}
    
    public List<Item__c> items{get;set;}
    
    public Boolean hasNextItems{get;set;}
    
    public Boolean hasPreviousItems{get;set;}
    
    public Boolean hasItemRecords{get;set;}
    
    public Integer ItemspageNumber{get;set;}
    
    public Integer totalPages{get;set;}
    
    private Integer totalItems;
    
    public List<SelectOption> categoryOptions{get{
        	categoryOptions = new List<SelectOption>();
            List<Schema.PicklistEntry> itemCategories = (List<Schema.PicklistEntry>)Item__c.Category__c.getDescribe().getPickListValues();
            for(Schema.PicklistEntry pe : itemCategories){
                categoryOptions.add(new SelectOption(pe.getLabel(), pe.getValue()));
            }
        return categoryOptions;
    	}private set;}
    
    public String selectedCategory{get;set;}
    
    public ApexPages.StandardSetController itemController{get;set;}
    
    public PurchaseOrderController(){
        selectedCategory = categoryOptions.get(0).getValue();
        loadItems();
        loadLineItems();
    }
    
    public PageReference save(){
        return new PageReference('/' + purchaseOrder.Id);
    }
    
    public PageReference cancel(){
        Schema.DescribeSObjectResult result = Purchase_Order__c.SObjectType.getDescribe();
  		PageReference pageRef = new PageReference('/' + result.getKeyPrefix());
        return pageRef;
    }
    
    public pageReference deleteOrder(){
        delete purchaseOrder;
        return new PageReference('/');
    } 
    
    private void loadLineItems(){
        lineItems = [SELECT Id, Item__c, Item_Code__c, Item_Name__c, It_is_Smart_Pack__c, Quantity__c, Unit_Price__c, Total_Price__c FROM Purchase_Order_Line_Item__c WHERE Purchase_Order__c = :purchaseOrder.Id];
        itemToLineItemMap = new Map<Id, Purchase_Order_Line_Item__c>();
        for(Purchase_Order_Line_Item__c lineItem : lineItems){
           itemToLineItemMap.put(lineItem.Item__c, lineItem); 
        }
    }
    
    public void loadItems(){
        itemController = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id, Name, Item_Name__c, Category__c, Price__c FROM Item__c WHERE Category__c = :selectedCategory]));
        system.debug(totalItems);
        Decimal pageSize = 10;
        itemController.setPageSize((Integer)pageSize);
        items = itemController.getRecords();
        Decimal totalItems = itemController.getResultSize();
        if(Items.size() != 0){
        	totalPages = (Integer)Math.ceil(totalItems/pageSize);
    	}
        hasItemRecords = totalItems > 0;
        handleItemPagination();
    }
    
    public void nextItems(){
        if(hasNextItems){
            itemController.next();
            handleItemPagination();
        }
    }
    
    public void previousItems(){
        if(hasPreviousItems){
            itemController.previous();
            handleItemPagination();
        }
    }
    
    public void lastItems(){
        if(hasNextItems){
            itemController.last();
            handleItemPagination();
        }
    }
    
    public void firstItems(){
        if(hasPreviousItems){
            itemController.first();
            handleItemPagination();
        }
    }
    
    public void goToItemsPageNumber(){
        itemController.setPageNumber(itemsPageNumber);
        System.debug(itemsPageNumber);
        handleItemPagination();
    }
    
    private void handleItemPagination(){
        
        items = itemController.getRecords();
        hasNextItems = itemController.getHasNext();
        hasPreviousItems = itemController.getHasPrevious();
        ItemspageNumber = itemController.getPageNumber();
    }
    
    public void saveLineItems(){
        List<Purchase_Order_Line_Item__c> lineItemsToUpdate = new List<Purchase_Order_Line_Item__c>();
        List<Purchase_Order_Line_Item__c> lineItemsToDelete = new List<Purchase_Order_Line_Item__c>();
        for(Purchase_Order_Line_Item__c litem : lineItems){
            if(litem.Quantity__c == 0){
                lineItemsToDelete.add(litem);
            }else{
                lineItemsToUpdate.add(litem);
            }
        }
        delete lineItemsToDelete;
        update lineItemsToUpdate;
       	loadLineItems();
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
        loadLineItems();
    }
    
    private void handleLineItemUpdate(Id lineItemId, Decimal quantity){
        if(quantity == 0){
            Purchase_Order_Line_Item__c lineItem = [SELECT Id, Item__c FROM Purchase_Order_Line_Item__c WHERE Id = :lineItemId];
            delete lineItem;
            itemToLineItemMap.remove(lineItem.Item__c);
        }else{
            Purchase_Order_Line_Item__c lineItem = new Purchase_Order_Line_Item__c(Id = lineItemId, Quantity__c = quantity);
        	update lineItem;
        }
        loadLineItems();
    }
}