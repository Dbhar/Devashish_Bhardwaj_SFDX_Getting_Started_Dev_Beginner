trigger handleLoanInsert on Loan__c (before insert) {
    Map<Id, CityManager__c> cityManagersMap = new Map<Id, CityManager__c>(); 
    for(CityManager__c manager : [SELECT Id, Manager__r.Name FROM CityManager__c]){
        cityManagersMap.put(manager.Id, manager);
    }
    for(Loan__c loan : Trigger.New){
        loan.Manager__c = cityManagersMap.get(loan.CityManager__c).Manager__c;
    }
}