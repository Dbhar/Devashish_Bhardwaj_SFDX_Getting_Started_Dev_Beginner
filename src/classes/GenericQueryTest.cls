@isTest
private class GenericQueryTest {
    private testMethod static void testQuery(){
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < 200; i++){
            accounts.add(new Account(Name = 'Test Account' + i, BillingCity = 'Test City' + i, BillingState = 'Test State' + i, BillingCountry = 'Test Country' + i));
        }
        insert accounts;
        GenericQuery genQuery = new GenericQuery();
        genQuery.setQuery('SELECT Id, Name, Phone FROM Account');
        System.assertEquals(null, genQuery.hasError);
        System.assertEquals(true, genQuery.isQuerySuccessful);
        genQuery = new GenericQuery();
        genQuery.setQuery('SELECT Name, Phone FROM Foo__c');
        System.assertEquals(true, genQuery.hasError);
        System.assertEquals(false, genQuery.isQuerySuccessful);    
    }
    
    private testMethod static void testSortingAndPagination(){
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < 200; i++){
            accounts.add(new Account(Name = 'Test Account' + i, BillingCity = 'Test City' + i, BillingState = 'Test State' + i, BillingCountry = 'Test Country' + i));
        }
        insert accounts;
        Test.setCurrentPage(Page.BogusQuery);
        
        GenericQuery genQuery = new GenericQuery();
        genQuery.setQuery('SELECT Id, Name, Phone FROM Account WHERE Name LIKE \'%Test Account%\' ORDER BY NAME');
        System.debug(genQuery.records);
        System.assertEquals(null, genQuery.hasError);
        System.assertEquals(true, genQuery.isQuerySuccessful);
        ApexPages.currentPage().getParameters().put('sortfield','name');
        genQuery.sort();
        System.assertEquals(1, genQuery.pageNumber);
        System.assertEquals('Test Account0', genQuery.records.get(0).get('name'), genQuery.records);
        genQuery.sort();
        System.assertEquals(1, genQuery.pageNumber);
        System.assertEquals('Test Account99', genQuery.records.get(0).get('name'), genQuery.records);
        genQuery.sort();
        genQuery.next();
        System.assertEquals(2, genQuery.pageNumber);
        System.assertEquals('Test Account107', genQuery.records.get(0).get('name'), genQuery.records);
        genQuery.previous();
        System.assertEquals(1, genQuery.pageNumber);
        System.assertEquals('Test Account0', genQuery.records.get(0).get('name'), genQuery.records);
        genQuery.last();
        System.assertEquals(20, genQuery.pageNumber);
        System.assertEquals('Test Account90', genQuery.records.get(0).get('name'), genQuery.records);
        genQuery.first();
        System.assertEquals(1, genQuery.pageNumber);
        System.assertEquals('Test Account0', genQuery.records.get(0).get('name'), genQuery.records);
        genQuery.pageNumber = 3;
        genQuery.goToPageNumber();
        System.assertEquals(3, genQuery.pageNumber);
        System.assertEquals('Test Account116', genQuery.records.get(0).get('name'), genQuery.records);
        
        //Testing other combinations of query
       	genQuery = new GenericQuery();
        genQuery.setQuery('SELECT Id, Name, Phone FROM Account ORDER BY NAME LIMIT 50');
        System.debug(genQuery.records);
        System.assertEquals(null, genQuery.hasError);
        System.assertEquals(true, genQuery.isQuerySuccessful);
        ApexPages.currentPage().getParameters().put('sortfield','name');
        genQuery.sort();
        System.assertEquals(1, genQuery.pageNumber);
        System.assertEquals('Test Account0', genQuery.records.get(0).get('name'), genQuery.records);
        genQuery.sort();
        
        //Testing other combinations of query
       	genQuery = new GenericQuery();
        genQuery.setQuery('SELECT Id, Name, Phone FROM Account LIMIT 50');
        System.debug(genQuery.records);
        System.assertEquals(null, genQuery.hasError);
        System.assertEquals(true, genQuery.isQuerySuccessful);
        ApexPages.currentPage().getParameters().put('sortfield','name');
        genQuery.sort();
        System.assertEquals(1, genQuery.pageNumber);
        System.assertEquals('Test Account0', genQuery.records.get(0).get('name'), genQuery.records);
        genQuery.sort();
        
        //Testing other combinations of query
       	genQuery = new GenericQuery();
        genQuery.setQuery('SELECT Id, Name, Phone FROM Account WHERE Name LIKE \'%Test Account%\' LIMIT 50');
        System.debug(genQuery.records);
        System.assertEquals(null, genQuery.hasError);
        System.assertEquals(true, genQuery.isQuerySuccessful);
        ApexPages.currentPage().getParameters().put('sortfield','name');
        genQuery.sort();
        System.assertEquals(1, genQuery.pageNumber);
        System.assertEquals('Test Account0', genQuery.records.get(0).get('name'), genQuery.records);
        genQuery.sort();
        
        //Testing other combinations of query
       	genQuery = new GenericQuery();
        genQuery.setQuery('SELECT Id, Name, Phone FROM Account WHERE Name LIKE \'%Test Account%\'');
        System.debug(genQuery.records);
        System.assertEquals(null, genQuery.hasError);
        System.assertEquals(true, genQuery.isQuerySuccessful);
        ApexPages.currentPage().getParameters().put('sortfield','name');
        genQuery.sort();
        System.assertEquals(1, genQuery.pageNumber);
        System.assertEquals('Test Account0', genQuery.records.get(0).get('name'), genQuery.records);
        genQuery.sort();
    }
}