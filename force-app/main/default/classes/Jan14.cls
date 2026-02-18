public class Jan14 {
    public Opportunity oppObj{get; set;}
    public List<OpportunityContactRole> contactLst {get; set;}
    public OpportunityContactRole ocr {get; set;}
    public List<OpportunityWithContactRoleWrapper> ocrWrapper {get; set;}
    
    
    public class OpportunityWithContactRoleWrapper {
        public Opportunity opp {get;set;}
        public List<OpportunityContactRole> conLst{get; set;}
        
        public OpportunityWithContactRoleWrapper(Opportunity oppObj , List<OpportunityContactRole> contactLst) {
            this.opp = oppObj;
            this.conLst = contactLst;
        }
    }
    
    public Jan14 () {
        initOpp();
    }
    
     public void initOpp() {
         ocr = new OpportunityContactRole();
         oppObj = new Opportunity();
         contactLst = new List<OpportunityContactRole>();
         ocrWrapper = new List<OpportunityWithContactRoleWrapper>();
	}
    
    public void addConRole () {
        if(ocr.ContactId != null && ocr.Role != null) {
            contactLst.add(ocr);
            ocr = new OpportunityContactRole(
            	ContactId = null,
                Role = null
            );
        }
    }
    
    public void addSingleOpp () {
        List<OpportunityContactRole> tempList = new List<OpportunityContactRole>();
        tempList.addAll(contactLst);
    
        OpportunityWithContactRoleWrapper ow =
            new OpportunityWithContactRoleWrapper(oppObj, tempList);
    
        ocrWrapper.add(ow);
        oppObj = new Opportunity();
        contactLst = new List<OpportunityContactRole>();
    }

    
    public void finalAddOpp() {
        for(OpportunityWithContactRoleWrapper ow : ocrWrapper ) {
            finalAdd(ow.opp , ow.conLst);
        }
		ocrWrapper.clear();
    }
    
    public void finalAdd (Opportunity oppObj , List <OpportunityContactRole> contactLst) {
        insert oppObj;
        for(OpportunityContactRole ocr : contactLst){
            ocr.OpportunityId = oppObj.Id;
        }
        insert contactLst;
        oppObj = new Opportunity(
        	Name = ''
            , StageName = ''
            , CloseDate = Date.today() + 7
            , Probability = null
        );
        contactLst.clear();
    }
}