public class AccountFilterExtension {
    public List<Account> filteredAccounts{get;set;}
    public AccountFilterCriteria filterCriteria{get;set;}
    public AccountFilterExtension(ApexPages.StandardController accountController){
        filteredAccounts = new List<Account>();
        filterCriteria = new AccountFilterCriteria();
    }
    
    public void search(){
        if(filterCriteria.BillingCity != '' && filterCriteria.BillingState != '' && filterCriteria.BillingCountry != ''){
        	filteredAccounts = [SELECT Id, Name, BillingCity, BillingState, BillingCountry FROM Account WHERE 
                            BillingCity = :filterCriteria.billingCity AND 
                            BillingState = :filterCriteria.billingState AND
                            BillingCountry = :filterCriteria.billingCountry LIMIT 100];
    
        }else if(filterCriteria.BillingCity != '' && filterCriteria.BillingState != ''){
            filteredAccounts = [SELECT Id, Name, BillingCity, BillingState, BillingCountry FROM Account WHERE 
                            	BillingCity = :filterCriteria.billingCity AND
                                BillingState = :filterCriteria.billingState LIMIT 100]; 
        }else if(filterCriteria.BillingCity != '' && filterCriteria.BillingCountry != ''){
            filteredAccounts = [SELECT Id, Name, BillingCity, BillingState, BillingCountry FROM Account WHERE 
                            	BillingCity = :filterCriteria.billingCity AND
                                BillingCountry = :filterCriteria.billingCountry LIMIT 100]; 
        }else if(filterCriteria.BillingState != '' && filterCriteria.BillingCountry != ''){
            filteredAccounts = [SELECT Id, Name, BillingCity, BillingState, BillingCountry FROM Account WHERE 
                            	BillingState = :filterCriteria.billingState AND
                                BillingCountry = :filterCriteria.billingCountry LIMIT 100]; 
        }else if(filterCriteria.BillingCity != ''){
            filteredAccounts = [SELECT Id, Name, BillingCity, BillingState, BillingCountry FROM Account WHERE 
                            BillingCity = :filterCriteria.billingCity LIMIT 100];
        }else if(filterCriteria.BillingState != ''){
            filteredAccounts = [SELECT Id, Name, BillingCity, BillingState, BillingCountry FROM Account WHERE 
                            BillingState = :filterCriteria.billingState LIMIT 100];
        }else if(filterCriteria.BillingCountry != ''){
            filteredAccounts = [SELECT Id, Name, BillingCity, BillingState, BillingCountry FROM Account WHERE 
                            BillingCountry = :filterCriteria.billingCountry LIMIT 100];

        }
        system.debug(filteredAccounts.size());
    }
    
    public class AccountFilterCriteria{
        public string billingCity{get;set;}
        public string billingState{get;set;}
        public string billingCountry{get;set;}
    }

}