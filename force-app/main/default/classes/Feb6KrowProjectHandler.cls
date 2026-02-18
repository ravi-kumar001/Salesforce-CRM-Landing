public class Feb6KrowProjectHandler {
    public static void afterUpdate(List<Opportunity> oppLst, Map<Id, Opportunity> oppMap) {
        List<Krow_Project__c> kpLst = new List<Krow_Project__c>();
        for(Opportunity opp : oppLst) {
            if(oppMap.get(opp.Id).StageName != 'Signature' && opp.StageName != null) {
                Krow_Project__c kp = new Krow_Project__c();
                kp.Opportunity__c = opp.Id;
                kp.Onboarding_Type__c = 'Onboarding';
                
                kpLst.add(kp);
            }
        }
        
        if(!kpLst.isEmpty()) insert kpLst;
    }
}