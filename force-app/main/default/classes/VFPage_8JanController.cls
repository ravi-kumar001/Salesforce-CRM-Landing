public class VFPage_8JanController {
   /* public String searchNm{get;set;}
    public String searchdt{get;set;}
    public String searchstage{get;set;}
    public String searchPro{get;set;}
    */
    public Opportunity oppSearchObj{get;set;}
    public List<Opportunity> oppLst{get;set;}
    public VFPage_8JanController(){
        oppLst = [select id,name,stagename,closeDate from Opportunity];
        oppSearchObj = new Opportunity();
    }
    public void searchOpp(){
        /*String searchNm1 = '%' + searchNm + '%';
        oppLst = [select id,name,stagename,closeDate from Opportunity where stage like :searchNm1 ];*/
        oppLst = [select id,name,stagename,closeDate from Opportunity where stagename = :oppSearchObj.StageName  ];
    }
}