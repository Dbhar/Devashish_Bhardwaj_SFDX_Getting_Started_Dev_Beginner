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
    public string sortField{get;set;}
    public string sortOrder{get;set;}
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
        String fields = correctedQuery.substringBetween('SELECT', 'FROM').trim();
        String conditions = correctedQuery.substringAfterLast('FROM');
        List<String> fieldTokens = fields.split(',');
        if(!fieldTokens.contains('ID')){
            fieldTokens.add(0, 'Id');
           	correctedQuery = 'SELECT ' + String.join(fieldTokens, ', ') + ' FROM ' + conditions;
        }
        System.debug(correctedQuery);
        sObjs = Database.query(correctedQuery);
        getQueriedFieldsAndLabels(sObjs.get(0), query);
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
        for(Sobject o : sObj){
            Map<String, Object> r = new Map<String, Object>();
            for(String field : queriedFields){
                if(o.get(field) != null ){
                	r.put(field, o.get(field));    
                }else{
                    r.put(field,'');
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
                }else if(!String.isEmpty('LIMIT')){
                   whereCondition = 'WHERE' + whereAndBeyond.substringBeforeLast('LIMIT');
                }else{
                    whereCondition = whereAndBeyond;
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
        
    private void getQueriedFieldsAndLabels(SObject sObj, String query){
        if(fieldLabels == null && queriedFields == null){
            fieldLabels = new Map<String, String>();
            queriedFields = new List<String>();
            Schema.DescribeSObjectResult describe = sObj.getSObjectType().getDescribe();
            type = describe.getName();
            Map<String, Schema.SObjectField> fieldMap = describe.fields.getMap();
            for(String field : fieldMap.keySet()){
                String fld = (String)field;
                if(query.contains(fld.toUpperCase())){
                    System.debug(field);
                    fieldLabels.put(fld, fieldMap.get(fld).getDescribe().getLabel());
                    queriedFields.add(fld);
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