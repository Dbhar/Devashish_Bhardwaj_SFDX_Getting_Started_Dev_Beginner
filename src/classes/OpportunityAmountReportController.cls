public class OpportunityAmountReportController {
    public List<AccountReportWrapper> accountWrapper{get;set;}
    
    public OpportunityAmountReportController(){
        accountWrapper = new List<AccountReportWrapper>();
        List<AggregateResult> results = [SELECT AccountId AccountId, Account.Name AccountName, SUM(Amount) SUM FROM Opportunity WHERE AccountId != NULL GROUP BY AccountId, Account.Name LIMIT 10];
        for(AggregateResult result : results){
            AccountReportWrapper wrapper = new AccountReportWrapper();
            wrapper.accountId = (String)result.get('AccountId');
            wrapper.accountName = (String)result.get('AccountName');
            wrapper.opportunityAmount = (Decimal)result.get('SUM');
            accountWrapper.add(wrapper);
        }
    }
    
    
    public Class AccountReportWrapper{
        public String accountId{get;set;}
        public String accountName{get;set;}
        public Decimal opportunityAmount{get;set;}
    }

}