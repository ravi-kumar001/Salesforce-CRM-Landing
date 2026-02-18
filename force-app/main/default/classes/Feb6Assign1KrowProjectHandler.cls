public class Feb6Assign1KrowProjectHandler {
    public static void validateOrderStatus(List<Order> newOrders, Map<Id, Order> oldOrderMap) {
        Set<Id> oppIds = new Set<Id>();
        
        for (Order o : newOrders) {
            if (o.OpportunityId != null && o.Status == 'Activated') {
                oppIds.add(o.OpportunityId);
            }
        }
        
        if (!oppIds.isEmpty()) {
            
            Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>( [SELECT Id, StageName FROM Opportunity WHERE Id IN :oppIds]);
            
            if(!oppMap.isEmpty()) {
                for (Order o : newOrders) {
                    if (o.OpportunityId == null || o.Status != 'Activated') {
                        continue;
                    }
                    if (oldOrderMap != null && oldOrderMap.containsKey(o.Id) && oldOrderMap.get(o.Id).Status == 'Activated') {
                        continue;
                    }
                    
                    Opportunity opp = oppMap.get(o.OpportunityId);
                    
                    if (opp != null && opp.StageName != 'Signature') {
                        o.Status.addError('opportunity stage is not signature.');
                    }
                }
            }
        }
    }
    
    public static void afterUpdate(List<Order> orderLst, Map<Id, Order> orderMap) {
        List<Krow_Project__c> kpLst = new List<Krow_Project__c>();
        List<Krow_Project__c> krowProjectLst = [ SELECT Id, (SELECT Id FROM Krow_Tasks__r) FROM  Krow_Project__c WHERE isTemplateKrow__c = true  ];
        List<Krow_Task__c> krowTaskLst = new List<Krow_Task__c>();
        
        if(!krowProjectLst.isEmpty()) {
            for(Krow_Project__c kp : krowProjectLst) {
                if(kp.Krow_Tasks__r != null) {
                    krowTaskLst.addAll(kp.Krow_Tasks__r);
                }
            }
            
            List<Krow_Task__c> updatedKrowTask = new List<Krow_Task__c>();
            
            if(!krowTaskLst.isEmpty()) {
                for(Order o : orderLst) {
                    if(orderMap.get(o.Id).Status != 'Activated' && o.OpportunityId != null && o.Status != null && o.Status == 'Activated') {
                        Krow_Project__c kp = new Krow_Project__c();
                        kp.Opportunity__c = o.OpportunityId;
                        kp.Onboarding_Type__c = 'Installation';
                        kp.Order__c = o.Id;
                        
                        kpLst.add(kp);
                    }
                }
            }
            
            if(!kpLst.isEmpty()) insert kpLst;
            
            if(!kpLst.isEmpty()) {
                for(Krow_Project__c o : kpLst) {
                    for(Krow_Task__c kt : krowTaskLst) {
                        Krow_Task__c tempKrowTask = new Krow_Task__c();
                        tempKrowTask.Krow_Project__c = o.Id;
                        
                        updatedKrowTask.add(tempKrowTask);
                    }
                }
            }
            
            if(!updatedKrowTask.isEmpty()) insert updatedKrowTask;
        }
    }
}