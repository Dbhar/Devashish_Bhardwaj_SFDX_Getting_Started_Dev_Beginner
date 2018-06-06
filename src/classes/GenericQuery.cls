public class GenericQuery {
    public string query;
    private string correctedQuery;
    public List<Map<String, Object>> records{get;set;}
    public Boolean isQuerySuccessful{get;set;}
    public List<String> queriedFields{get;set;}
    public Map<String, String> fieldLabels{get;set;}
    public Id recordToOpenId{get;set;}
    public Boolean hasError{get;set;}
    public Boolean hasNext{get;set;}
    public Boolean hasPrevious{get;set;}
    public Integer pageNumber{get;set;}
    public Integer maxPages{get;set;}
    public string sortOrder{get;set;}
    public string recordName{get;set;}
    private string type;
    
    public ApexPages.StandardSetController controller{get;set;}
    public void setQuery(String s){
        if(query == null){
            try{
                System.debug('Setting query');
                query = s.toUpperCase();
                initializeController();
                loadRecords();
                isQuerySuccessful = true;
           }catch(Exception e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage() + e.getStackTraceString()));
                hasError = true;
                isQuerySuccessful = false;
           }
       }
    }
    
    public String getQuery(){
        return query;
    }
    
    private void initializeController(){
        if(correctedQuery == null){
            correctedQuery = query;
        }
        List<SObject> sObjs = new List<sObject>();
        String fields = correctedQuery.substringBetween('SELECT', 'FROM').trim().replaceAll(' ','').toLowerCase();
        String conditions = correctedQuery.substringAfterLast('FROM');
        List<String> fieldTokens = fields.split(',');
        queriedFields = new List<String>(fieldTokens);
        if(!fieldTokens.contains('id')){
            fieldTokens.add(0, 'Id');
            correctedQuery = 'SELECT ' + String.join(fieldTokens, ', ') + ' FROM ' + conditions;
        }
        System.debug(correctedQuery);
        sObjs = Database.query(correctedQuery);
        getFieldLabels(sObjs.get(0));
        controller = new ApexPages.StandardSetController(sObjs);
        controller.setPageSize(10);
        hasNext = controller.getHasNext();
        hasPrevious = controller.getHasPrevious();
        pageNumber = controller.getPageNumber();
        maxPages = (Integer)Math.ceil(controller.getResultSize()/10.0);
    }
    
    private void loadRecords(){
        System.debug('load Records called');
        records = new List<Map<String, Object>>();
        List<Sobject> sObj = controller.getRecords();
        records = new List<Map<String, Object>>();
        List<String> queriedFieldsWithId = new List<String>(queriedFields);
        if(!queriedFieldsWithId.contains('id')){
            queriedFieldsWithId.add('id');    
        }
        for(Sobject o : sObj){
            Map<String, Object> r = new Map<String, Object>();
            for(String field : queriedFieldsWithId){
               if(!field.contains('.')){
                   	if(o.get(field) != null ){
                    	r.put(field, o.get(field));    
                	}else{
                    	r.put(field,'');
                	}
               }else{
                   List<String> fieldRelationship = field.split('\\.');
                   String parentObject = fieldRelationship.get(0).capitalize();
                   String parentField = fieldRelationShip.get(1);
                   if(o.getSObject(parentObject) != null){
                       r.put(field, o.getSObject(parentObject).get(parentField));
                   }else{
                       r.put(field, '');
                   }
              	    	     
               }   
            }
            records.add(r);
        }
    }
    
    public void sort(){
        try{
            String sortField = ApexPages.currentPage().getParameters().get('sortField');
            String orderByQuery = '';
            if(sortOrder == null || sortOrder == 'DESC'){
                sortOrder = 'ASC';
            }else{
                sortOrder = 'DESC';
            }
            System.debug(correctedQuery);
            String whereAndBeyond = correctedQuery.substringAfterLast('WHERE');
            String orderByAndBeyond = correctedQuery.substringAfter('ORDER BY');
            String limitAndBeyond = correctedQuery.substringAfterLast('LIMIT');
            if(String.isEmpty(limitAndBeyond)){
                limitAndBeyond = '';
            }else{
                limitAndBeyond = ' LIMIT ' + limitAndBeyond;
            }
            System.debug(whereAndBeyond);
            System.debug(orderByAndBeyond);
            String whereCondition = '';
            if(!String.isEmpty(whereAndBeyond)){
                if(!String.isEmpty(orderByAndBeyond)){
                   whereCondition = 'WHERE ' + whereAndBeyond.substringBeforeLast('ORDER BY');
                }else if(!String.isEmpty(limitAndBeyond)){
                   whereCondition = 'WHERE' + whereAndBeyond.substringBeforeLast('LIMIT');
                }else{
                    whereCondition = 'WHERE ' + whereAndBeyond;
                }
            }
            correctedQuery = 'SELECT ' + String.join(queriedFields, ',') + ' FROM ' + type + ' ' + whereCondition + ' Order By ' + sortField + ' ' + sortOrder + ' ' + limitAndBeyond;  
            correctedQuery = correctedQuery.toUpperCase();
            system.debug(correctedQuery);
            Integer currentPage = controller.getPageNumber();
            initializeController();
            loadRecords();
            System.debug(records);
            System.debug(queriedFields);
        }catch(Exception e){
            hasError = true;
            System.debug(e.getMessage() + ' ' + e.getStackTraceString());
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, e.getMessage() + ' ' + e.getStackTraceString()));
        }
        
    }
        
    private void getFieldLabels(SObject sObj){
        if(fieldLabels == null){
            fieldLabels = new Map<String, String>();
            Schema.DescribeSObjectResult describe = sObj.getSObjectType().getDescribe();
            type = describe.getName();
            recordName = describe.getLabelPlural();
            Map<String, Schema.SObjectField> fieldMap = describe.fields.getMap();
            for(String field : queriedFields){
                String fld = (String)field;
                if(fieldMap.containsKey(fld)){
                    System.debug(fld);
                    fieldLabels.put(fld, fieldMap.get(fld).getDescribe().getLabel());
                }else{
                    if(fld.contains('.')){
                        List<String> fieldRelationship = fld.split('\\.');
                        if(fieldRelationship.size() > 2){
                            throw new QueryException('Only one level of nesting to parent objects is supported');
                        }
                        String parentObject = fieldRelationship.get(0).replaceAll('__r', '__c');
                        String parentField = fieldRelationShip.get(1);
                        Schema.DescribeSObjectResult parentDescribe = Schema.getGlobalDescribe().get(parentObject).getDescribe();
                        Map<String, SObjectField> parentFieldMap = parentDescribe.fields.getMap();
                        String parentFieldLabel = parentFieldMap.get(parentField).getDescribe().getLabel();
                        parentObject = parentObject.replaceAll('__c', '');
                        if(!parentFieldLabel.containsIgnoreCase(parentObject)){
                            parentFieldLabel = parentObject.capitalize() + ' ' + parentFieldLabel;
                        }
                        fieldLabels.put(fld, parentFieldLabel);
                    }
                 }   
            }    
        }
    }
    
    public void next(){
        if(hasNext){
            System.debug('next called');
            controller.next();
            hasNext = controller.getHasNext();
            hasPrevious = controller.getHasPrevious();
            pageNumber = controller.getPageNumber();
            loadRecords();
            System.debug(records);
        }
    }
    
    public void previous(){
        if(hasPrevious){
            controller.previous();
            hasNext = controller.getHasNext();
            hasPrevious = controller.getHasPrevious();
            pageNumber = controller.getPageNumber();
            loadRecords();
        }
    }
    
    public void first(){
        if(hasPrevious){
            controller.first();
            hasNext = controller.getHasNext();
            hasPrevious = controller.getHasPrevious();
            pageNumber = controller.getPageNumber();
            loadRecords();
            System.debug(records);
        }
    }
    
    public void last(){
        if(hasNext){
            controller.last();
            hasNext = controller.getHasNext();
            hasPrevious = controller.getHasPrevious();
            pageNumber = controller.getPageNumber();
            loadRecords();
        }
    }
    
    public void goToPageNumber(){
        controller.setPageNumber(pageNumber);
        hasNext = controller.getHasNext();
        hasPrevious = controller.getHasPrevious();
        pageNumber = controller.getPageNumber();
        loadRecords();
    }
    
    class QueryException extends Exception{}

}