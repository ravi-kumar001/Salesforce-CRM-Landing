trigger Jan28AssignSe2 on OpportunityLineItem (after insert, after update, after delete) {
    
    if(Trigger.isInsert || Trigger.isUpdate) {
        Set<Id> oppIdSet = new Set<Id>();
        for(OpportunityLineItem oli : Trigger.new) {
            
            oppIdSet.add(oli.OpportunityId);
        }
        
        List<Opportunity> oppList = [ SELECT Id, TotalOpportunityAmount__c, Amount, ( SELECT TotalPrice From OpportunityLineItems ) FROM  Opportunity WHERE Id IN :oppIdSet ];
        
        for(Opportunity o : oppList) {
            Decimal amount = 0;
            if(o.Id != null) {
                for(OpportunityLineItem oLiItem : o.OpportunityLineItems ) {
                	amount += oLiItem.TotalPrice;
            	}
                o.TotalOpportunityAmount__c = amount;
            }
        }
        
        if(!oppList.isEmpty()) {
            update oppList;
        }
    }
    
    if(Trigger.isDelete) {
        Set<Id> oppIdSet = new Set<Id>();
        for(OpportunityLineItem oli : Trigger.old) {
            oppIdSet.add(oli.OpportunityId);
        }
        
        List<Opportunity> oppList = [ SELECT Id, TotalOpportunityAmount__c, Amount, ( SELECT TotalPrice From OpportunityLineItems ) FROM  Opportunity WHERE Id IN :oppIdSet ];
        
        for(Opportunity o : oppList) {
            Decimal amount = 0;
            if(o.Id != null) {
                for(OpportunityLineItem oLiItem : o.OpportunityLineItems ) {
                	amount += oLiItem.TotalPrice;
            	}
                o.TotalOpportunityAmount__c = amount;
            }
        }
        
        if(!oppList.isEmpty()) {
            update oppList;
        }
    }
}