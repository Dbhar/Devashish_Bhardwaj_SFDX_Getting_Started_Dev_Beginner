public class AccountFilterController {
    public AccountFilterCriteria filterCriteria{get;set;}
    public List<Account> filteredAccounts{get;set;}
    public ApexPages.StandardSetController accountController{get{if(accountController != null){
        															accountController.setPageSize(10);
    															}
        														return accountController;
    														}set;}
    
    public Boolean hasNext{get;set;}
    
    public Boolean hasPrevious{get;set;}
    
    public Integer pageNumber{get;set;}
    
    public AccountFilterController(){
        filterCriteria = new AccountFilterCriteria();
    }
    
    public void search(){
        if(filterCriteria.BillingCity != '' && filterCriteria.BillingState != '' && filterCriteria.BillingCountry != ''){
        	accountController = new ApexPages.StandardSetController(
                					Database.getQueryLocator(
                                        [SELECT Id, Name, BillingCity, BillingState, BillingCountry FROM Account WHERE 
                            				BillingCity = :filterCriteria.billingCity AND 
                            				BillingState = :filterCriteria.billingState AND
                            				BillingCountry = :filterCriteria.billingCountry
                                        ]
                                    )
            					);
    
        }else if(filterCriteria.BillingCity != '' && filterCriteria.BillingState != ''){
            accountController = new ApexPages.StandardSetController(
                					Database.getQueryLocator(
                                        [SELECT Id, Name, BillingCity, BillingState, BillingCountry FROM Account WHERE 
                            				BillingCity = :filterCriteria.billingCity AND
                                			BillingState = :filterCriteria.billingState
                                        ]
                                     )
                				);
        }else if(filterCriteria.BillingCity != '' && filterCriteria.BillingCountry != ''){
            accountController = new ApexPages.StandardSetController(
                					Database.getQueryLocator(
                                        [SELECT Id, Name, BillingCity, BillingState, BillingCountry FROM Account WHERE 
                            				BillingCity = :filterCriteria.billingCity AND
                                			BillingCountry = :filterCriteria.billingCountry
                                        ]
                                     )
                				);
        }else if(filterCriteria.BillingState != '' && filterCriteria.BillingCountry != ''){
            accountController = new ApexPages.StandardSetController(
                					Database.getQueryLocator(
                                        [SELECT Id, Name, BillingCity, BillingState, BillingCountry FROM Account WHERE 
                            				BillingState = :filterCriteria.billingState AND
                                			BillingCountry = :filterCriteria.billingCountry
                                        ]
                                     )
                                );
        }else if(filterCriteria.BillingCity != ''){
            accountController = new ApexPages.StandardSetController(
                					Database.getQueryLocator(
                                        [SELECT Id, Name, BillingCity, BillingState, BillingCountry FROM Account WHERE 
                            				BillingCity = :filterCriteria.billingCity
                                        ]
                                     )
                				);
        }else if(filterCriteria.BillingState != ''){
            accountController = new ApexPages.StandardSetController(
                					Database.getQueryLocator(
                                        [SELECT Id, Name, BillingCity, BillingState, BillingCountry FROM Account WHERE 
                            				BillingState = :filterCriteria.billingState
                                        ]
                                    )
                				);	
        }else if(filterCriteria.BillingCountry != ''){
            accountController = new ApexPages.StandardSetController(
                					Database.getQueryLocator(
                                        [SELECT Id, Name, BillingCity, BillingState, BillingCountry FROM Account WHERE 
                            				BillingCountry = :filterCriteria.billingCountry
                                        ]
                                     )
                				);
        }else{
            accountController = new ApexPages.StandardSetController(new List<Account>());
        }
        filteredAccounts = accountController.getRecords();
        hasNext = accountController.getHasNext();
        hasPrevious = accountController.getHasPrevious();
        pageNumber = accountController.getPageNumber();
        system.debug(filteredAccounts);
    }
    
    public void next(){
        accountController.next();
       	reloadRecords();
    } 
    
    public void previous(){
        accountController.previous();
        reloadRecords();
    }
    
    public void first(){
        accountController.first();
        reloadRecords();
    }
    
    public void last(){
        accountController.last();
        reloadRecords();
    }
    
    public void reloadRecords(){
        filteredAccounts = accountController.getRecords();
        hasNext = accountController.getHasNext();
        hasPrevious = accountController.getHasPrevious();
        pageNumber = accountController.getPageNumber();
    }
    
    public class AccountFilterCriteria{
        public string billingCity{get;set;}
        public string billingState{get;set;}
        public string billingCountry{get;set;}
    }

}