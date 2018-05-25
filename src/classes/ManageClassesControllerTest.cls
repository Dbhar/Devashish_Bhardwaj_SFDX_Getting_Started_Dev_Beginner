@isTest
private class ManageClassesControllerTest {
    @testSetup
    private static void setup(){
        List<Class__c> classes = new List<Class__c>();
        for(Integer i = 0; i < 200; i++){
            classes.add(new Class__c(ClassName__c = 'C' + i, MaxSize__c = 100));
        }
        insert classes;
    }
    
    private testMethod static void testFetch(){
        ManageClassesController controller = new ManageClassesController();
        System.assertEquals(controller.controller.getPageSize(), controller.classes.size());
    }
    
     private testMethod static void testEditSaveDelete(){
        ManageClassesController controller = new ManageClassesController();
        Id recordId = controller.classes.get(0).Id;
        controller.recordId = recordId;
        controller.edit();
        System.assertEquals(true, controller.isRecordBeingEdited, 'Expected that record is being edited'); 
        System.assertEquals(recordId, controller.mockClass.Id);
        controller.mockClass.ClassName__c = 'Name Changed';
        controller.saveRecord();
        System.assertEquals('Name Changed', controller.classes.get(0).ClassName__c);
        System.assertEquals(false, controller.isRecordBeingEdited);
        controller.deleteRecord();
        System.assertNotEquals(recordId, controller.classes.get(0).Id);
        System.assertEquals(0, [SELECT COUNT() FROM Class__c WHERE Id = :recordId]);
        System.assertEquals(false, controller.isRecordBeingEdited, 'Expected that record is not being edited'); 
    }
    
    private testMethod static void testCancel(){
        ManageClassesController controller = new ManageClassesController();
        Id recordId = controller.classes.get(0).Id;
        controller.recordId = recordId;
        controller.edit();
        controller.cancel();
        System.assertEquals(false, controller.isRecordBeingEdited, 'Expected that record is being edited'); 
        System.assertEquals(null, controller.mockClass.Id);
    }
}