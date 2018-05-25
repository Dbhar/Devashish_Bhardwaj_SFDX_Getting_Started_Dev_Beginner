@isTest
private class SObjectDescribeTest {
    private testMethod static void testGetAllSObjects(){
        List<String> sObjects = SObjectDescribe.getAllSObjects();
       	System.assertEquals(new List<String>(Schema.getGlobalDescribe().keySet()), sObjects);
    }
}