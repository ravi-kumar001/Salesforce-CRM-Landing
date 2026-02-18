public class Jan13VfpClass {
    public Opportunity oppObj{get; set;}
    public List<OpportunityContactRole> contactLst {get; set;}
    public OpportunityContactRole ocr {get; set;}
    public List<Opportunity> oppLst {get; set;}
    
    public Jan13VfpClass () {
        initOpp();
        findAddOpp();
    }
    
     public void initOpp() {
         ocr = new OpportunityContactRole();
         oppObj = new Opportunity();
         contactLst = new List<OpportunityContactRole>();
	}
    
    public void findAddOpp() {
        oppLst = [SELECT Id, Name, StageName,(SELECT Contact.Name, Role From OpportunityContactRoles) FROM Opportunity ORDER BY CreatedDate DESC ];
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
    
    public void finalAddOpp () {
        insert oppObj;
        for(OpportunityContactRole ocr : contactLst){
            ocr.OpportunityId = oppObj.Id;
        }
        insert contactLst;
        oppObj = new Opportunity(
        	Name = ''
            , StageName = ''
            , CloseDate = Date.today() + 7
            , TotalOpportunityQuantity = null
            , Probability = null, AccountId = null, Amount = null
            
        );
        contactLst.clear();
        findAddOpp();
    }
}