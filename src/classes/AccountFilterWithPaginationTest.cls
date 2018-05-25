@isTest
private class AccountFilterWithPaginationTest {
    private static testMethod void testSearch(){
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < 200; i++){
            accounts.add(new Account(Name = 'Test Account', BillingCity = 'Test City', BillingState = 'Test State' + i, BillingCountry = 'Test Country' + i));
        }
        insert accounts;
        AccountFilterController ext = new AccountFilterController();
        ext.filterCriteria.BillingCity = '';
        ext.filterCriteria.BillingState = 'Test State0';
        ext.filterCriteria.BillingCountry = '';
        ext.search();
        System.assertEquals(new List<Account>{accounts[0]}, ext.filteredAccounts);
        ext.filterCriteria.BillingCity = '';
        ext.filterCriteria.BillingState = '';
        ext.filterCriteria.BillingCountry = 'Test Country0';
        ext.search();
        System.assertEquals(new List<Account>{accounts[0]}, ext.filteredAccounts);
        ext.filterCriteria.BillingCity = '';
        ext.filterCriteria.BillingState = 'Test State0';
        ext.filterCriteria.BillingCountry = 'Test Country0';
        ext.search();
        System.assertEquals(new List<Account>{accounts[0]}, ext.filteredAccounts);
        ext.filterCriteria.BillingCity = 'Test City';
        ext.filterCriteria.BillingState = '';
        ext.filterCriteria.BillingCountry = 'Test Country0';
        ext.search();
        System.assertEquals(new List<Account>{accounts[0]}, ext.filteredAccounts);
        ext.filterCriteria.BillingCity = 'Test City';
        ext.filterCriteria.BillingState = 'Test State0';
        ext.filterCriteria.BillingCountry = '';
        ext.search();
        System.assertEquals(new List<Account>{accounts[0]}, ext.filteredAccounts);
        ext.filterCriteria.BillingCity = 'Test City';
        ext.filterCriteria.BillingState = 'Test State0';
        ext.filterCriteria.BillingCountry = 'Test Country0';
        ext.search();
        System.assertEquals(new List<Account>{accounts[0]}, ext.filteredAccounts);
        ext.filterCriteria.BillingCity = 'Test City';
        ext.filterCriteria.BillingState = '';
        ext.filterCriteria.BillingCountry = '';
        ext.search();
        System.assertEquals(10, ext.filteredAccounts.size());
        ext.next();
        System.assertEquals(10, ext.filteredAccounts.size());
        System.assertEquals(2, ext.pageNumber);
        ext.previous();
        System.assertEquals(10, ext.filteredAccounts.size());
        System.assertEquals(1, ext.pageNumber);
        ext.last();
        System.assertEquals(10, ext.filteredAccounts.size());
        System.assertEquals(20, ext.pageNumber);
        ext.first();
        System.assertEquals(10, ext.filteredAccounts.size());
        System.assertEquals(1, ext.pageNumber);
    }
}