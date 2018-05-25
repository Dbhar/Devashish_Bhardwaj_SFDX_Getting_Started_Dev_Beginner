@isTest
private class AccountExtensionTest {
    private static testMethod void testSearch(){
        List<Account> accounts = new List<Account>();
        for(Integer i = 0; i < 200; i++){
            accounts.add(new Account(Name = 'Test Account' + i, BillingCity = 'Test City' + i, BillingState = 'Test State' + i, BillingCountry = 'Test Country' + i));
        }
        insert accounts;
        AccountFilterExtension ext = new AccountFilterExtension(new ApexPages.StandardController(accounts[0]));
        ext.filterCriteria.BillingCity = 'Test City0';
        ext.filterCriteria.BillingState = '';
        ext.filterCriteria.BillingCountry = '';
        ext.search();
        System.assertEquals(new List<Account>{accounts[0]}, ext.filteredAccounts);
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
        ext.filterCriteria.BillingCity = 'Test City0';
        ext.filterCriteria.BillingState = '';
        ext.filterCriteria.BillingCountry = 'Test Country0';
        ext.search();
        System.assertEquals(new List<Account>{accounts[0]}, ext.filteredAccounts);
        ext.filterCriteria.BillingCity = 'Test City0';
        ext.filterCriteria.BillingState = 'Test State0';
        ext.filterCriteria.BillingCountry = '';
        ext.search();
        System.assertEquals(new List<Account>{accounts[0]}, ext.filteredAccounts);
        System.assertEquals(new List<Account>{accounts[0]}, ext.filteredAccounts);
        System.assertEquals(new List<Account>{accounts[0]}, ext.filteredAccounts);
        ext.filterCriteria.BillingCity = 'Test City0';
        ext.filterCriteria.BillingState = 'Test State0';
        ext.filterCriteria.BillingCountry = 'Test Country0';
        ext.search();
        System.assertEquals(new List<Account>{accounts[0]}, ext.filteredAccounts);
    }
}