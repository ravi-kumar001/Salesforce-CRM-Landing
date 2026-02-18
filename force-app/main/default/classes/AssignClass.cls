public class AssignClass {
    public String filterWithName{get;set;}
    public Opportunity oppSearchObj{get;set;}
    public List<Opportunity> oppLst{get;set;}
    public AssignClass(){
        oppLst = [select id,name,stagename,closeDate from Opportunity];
        oppSearchObj = new Opportunity();
    }
    public void searchOpp(){
        String searchName = '%' + filterWithName + '%';
        System.debug('Entered name ' + searchName);
        oppLst = [select id,name,stagename,closeDate from Opportunity where stagename = :oppSearchObj.StageName  or closeDate = :oppSearchObj.CloseDate or name = :oppSearchObj.Name];
    }
    
    public void clearAll() {
        oppSearchObj = new Opportunity();
        oppLst = [ select id,name,stagename,closeDate from Opportunity ];
        filterWithName = '';
    }
}