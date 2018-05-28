@isTest
private class OpportunityAmountReportTest {
    private testMethod static void test(){
        List<Account> accounts = new List<Account>();
        for(Integer i = 0 ; i < 9; i++){
            accounts.add(new Account(Name = 'Test Account' + i));
        }
        accounts.add(new Account(Name = 'Test Account9'));
        insert accounts;
        List<Opportunity> opportunities = new List<Opportunity>();
        for(Account acc : accounts){
            for(Integer i = 0; i < 5; i++){
                opportunities.add(new Opportunity(Name = 'Test Opp - ' + acc.Name, StageName = 'Prospecting', CloseDate = Date.today().addDays(100), Amount = 500, AccountId = acc.Id ));
            }      
        }
        insert opportunities;
        OpportunityAmountReportController controller = new OpportunityAmountReportController();
        System.assertEquals(10, controller.accountWrapper.size());
        for(OpportunityAmountReportController.AccountReportWrapper wrapper : controller.accountWrapper){
            System.assertEquals(2500, wrapper.OpportunityAmount, 'Failed for ' + wrapper);
        }
        
    }

}