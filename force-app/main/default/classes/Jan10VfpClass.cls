public class Jan10VfpClass {

    public List<OpportunityWrapper> oppWrapperList { get; set; }
    public Opportunity newOpp { get; set; }
    public Id selectedId { get; set; }

    public Jan10VfpClass() {
        initOpp();
    }
    
    public class OpportunityWrapper {
        public Opportunity opp { get; set; }
        public Boolean isSelected { get; set; }

        public OpportunityWrapper(Opportunity o) {
            opp = o;
            isSelected = false;
        }
    }

    public void initOpp() {
        newOpp = new Opportunity(
            CloseDate = Date.today() + 7
        );
        loadOpps();
    }

    private void loadOpps() {
        oppWrapperList = new List<OpportunityWrapper>();

        for (Opportunity o : [ SELECT Id, Name, StageName, CloseDate FROM Opportunity ORDER BY CreatedDate DESC]) {
            oppWrapperList.add(new OpportunityWrapper(o));
        }
    }
    
    public void createOpp() {
        insert newOpp;
        initOpp();
    }
    
    public void deleteOpp() {
        for(Integer i = 0; i < oppWrapperList.size(); i++) {
            if(!oppWrapperList[i].isSelected && oppWrapperList[i].opp.Id == selectedId) {
               delete oppWrapperList[i].opp;
               oppWrapperList.remove(i);
               selectedId = null;
               break;
            }
        }
    }

    public void editOpp() {
        for (OpportunityWrapper ow : oppWrapperList) {
            if(ow.opp.Id == selectedId){
                ow.isSelected = true;
            }
        }
        selectedId = null;
    }

    public void saveOpp() {
        for (OpportunityWrapper ow : oppWrapperList) {
            if (ow.isSelected && ow.opp.Id == selectedId) {
                update ow.opp;
                ow.isSelected = false;
                selectedId = null;
                break;
            }
        }
    }

    public void cancelEdit() {
        for (OpportunityWrapper ow : oppWrapperList) {
            if (ow.isSelected && ow.opp.Id == selectedId) {
                ow.isSelected = false;
                selectedId = null;
                break;
            }
        }
    }
}