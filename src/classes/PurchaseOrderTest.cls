@isTest
private class PurchaseOrderTest {
    @testSetup
    private static void setup(){
        Purchase_Order__c po = new Purchase_Order__c();
        insert po;
        List<Item__c> items = new List<Item__c>();
        for(Integer i = 0; i < 50; i++){
            items.add(new Item__c(Item_Name__c = 'Book' + (i + 1), Category__c = 'Books', Price__c = 30));
        }
        
        for(Integer i = 0; i < 50; i++){
            items.add(new Item__c(Item_Name__c = 'Cosmetics' + (i + 1), Category__c = 'Cosmetics', Price__c = 50));
        }
        insert items;
    }
    
    private static testMethod void testNew(){
        delete [SELECT Id FROM Purchase_Order__c];
        Purchase_Order__c po = new Purchase_Order__c();
        NewPurchaseOrder newPo = new NewPurchaseOrder(new ApexPages.StandardController(po));
        String url = newPo.save().getUrl();
        List<Purchase_Order__c> purchaseOrders = [SELECT Id FROM Purchase_Order__c];
        System.assertEquals(1, purchaseOrders.size());
        String id = purchaseOrders.get(0).Id;
        id = id.substring(0, 15);
        System.assertEquals(new PageReference('/apex/PurchaseOrder?id=' + id).getUrl(), url);
    }
    
    private static testMethod void testLoadItemsAndItemPagination(){
        Purchase_Order__c po = [SELECT Id FROM Purchase_Order__c];
        Test.setCurrentPage(Page.PurchaseOrder);
        ApexPages.currentPage().getParameters().put('id', po.Id);
        PurchaseOrderController controller = new PurchaseOrderController();
        System.assertEquals([SELECT Id, Name, Item_Name__c, Category__c, Price__c FROM Item__c WHERE Category__c = 'Books' LIMIT 10], controller.items);
        controller.selectedCategory = 'Cosmetics';
        controller.loadItems();
        System.assertEquals([SELECT Id, Name, Item_Name__c, Category__c, Price__c FROM Item__c WHERE Category__c = 'Cosmetics' LIMIT 10], controller.items);
        controller.nextItems();
        System.assertEquals(2, controller.ItemspageNumber);
        controller.lastItems();
        System.assertEquals(5, controller.ItemspageNumber);
        controller.firstItems();
        System.assertEquals(1, controller.ItemspageNumber);
        controller.ItemspageNumber = 3;
        controller.goToItemsPageNumber();
        System.assertEquals(3, controller.ItemspageNumber);
        controller.previousItems();
        System.assertEquals(2, controller.ItemspageNumber);
    }
    
    private static testMethod void testAddItemsAndEditDeleteLineItems(){
        Purchase_Order__c po = [SELECT Id FROM Purchase_Order__c];
        Test.setCurrentPage(Page.PurchaseOrder);
        ApexPages.currentPage().getParameters().put('id', po.Id);
        PurchaseOrderController controller = new PurchaseOrderController();
        ApexPages.currentPage().getParameters().put('itemId', controller.items.get(0).Id);
        controller.addItem();
        ApexPages.currentPage().getParameters().put('itemId', controller.items.get(0).Id);
        controller.addItem();
        System.assertEquals(1, controller.lineItems.size());
        System.assertEquals('Book1', controller.lineItems.get(0).Item_Name__c);
        System.assertEquals(2, controller.lineItems.get(0).Quantity__c);
        System.assertEquals(30, controller.lineItems.get(0).Unit_Price__c);
        System.assertEquals(60, controller.lineItems.get(0).Total_Price__c);
        ApexPages.currentPage().getParameters().put('itemId', controller.items.get(1).Id);
        controller.addItem();
        System.assertEquals(2, controller.lineItems.size());
        System.assertEquals('Book1', controller.lineItems.get(0).Item_Name__c);
        System.assertEquals(2, controller.lineItems.get(0).Quantity__c);
        System.assertEquals(30, controller.lineItems.get(0).Unit_Price__c);
        System.assertEquals(60, controller.lineItems.get(0).Total_Price__c);
        System.assertEquals('Book2', controller.lineItems.get(1).Item_Name__c);
        System.assertEquals(1, controller.lineItems.get(1).Quantity__c);
        System.assertEquals(30, controller.lineItems.get(1).Unit_Price__c);
        System.assertEquals(30, controller.lineItems.get(1).Total_Price__c);
        
        controller.lineItems.get(0).Quantity__c = 3;
        controller.saveLineItems();
        System.assertEquals(2, controller.lineItems.size());
        System.assertEquals('Book1', controller.lineItems.get(0).Item_Name__c);
        System.assertEquals(3, controller.lineItems.get(0).Quantity__c);
        System.assertEquals(30, controller.lineItems.get(0).Unit_Price__c);
        System.assertEquals(90, controller.lineItems.get(0).Total_Price__c);
        System.assertEquals('Book2', controller.lineItems.get(1).Item_Name__c);
        System.assertEquals(1, controller.lineItems.get(1).Quantity__c);
        System.assertEquals(30, controller.lineItems.get(1).Unit_Price__c);
        System.assertEquals(30, controller.lineItems.get(1).Total_Price__c);
        ApexPages.currentPage().getParameters().put('lId', controller.lineItems.get(1).Id);
        controller.deleteLineItem();
        System.assertEquals(1, controller.lineItems.size());
        controller.lineItems.get(0).Quantity__c = 0;
        controller.saveLineItems();
        System.assertEquals(0, controller.lineItems.size());
    }
    
    private static testMethod void testSaveCancelDelete(){
        Purchase_Order__c po = [SELECT Id FROM Purchase_Order__c];
        Test.setCurrentPage(Page.PurchaseOrder);
        ApexPages.currentPage().getParameters().put('id', po.Id);
        PurchaseOrderController controller = new PurchaseOrderController();
        String url = controller.save().getUrl();
        System.assertEquals(new PageReference('/' + po.Id).getUrl(), url);
        url = controller.cancel().getUrl();
        Schema.DescribeSObjectResult result = Purchase_Order__c.SObjectType.getDescribe();
  		PageReference pageRef = new PageReference('/' + result.getKeyPrefix());
        System.assertEquals(pageRef.getUrl(), url);
        url = controller.deleteOrder().getUrl();
        System.assertEquals(new PageReference('/').getUrl(), url);
        System.assertEquals(0, [SELECT COUNT() FROM Purchase_Order__c]);
        System.assertEquals(0, [SELECT COUNT() FROM Purchase_Order_Line_Item__c]);
    }
}