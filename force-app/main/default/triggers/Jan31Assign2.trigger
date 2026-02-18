trigger Jan31Assign2 on Contact (before insert, before update) {
    if(Trigger.isInsert) {
        Map<Id, List<Contact>> accToCon = new Map<Id, List<Contact>>();
        for(Contact c : Trigger.new) {
            if( c != null && c.Role__c != null && c.Role__c == 'Decision Maker' && c.AccountId != null) {
                if(!accToCon.containsKey(c.AccountId)) {
                    accToCon.put(c.AccountId, new List<Contact>());
                }
                accToCon.get(c.AccountId).add(c);
            }
        }
        
        Map<Id,Account> mapAccount = new Map<Id,Account>();
        for(Account a : [SELECT Id, ActiveDecision_Maker__c FROM Account WHERE Id = :accToCon.keySet() ]) {
            if(a != null && a.Id != null && !mapAccount.containsKey(a.Id) && a.ActiveDecision_Maker__c != null ) {
                mapAccount.put(a.id , a);
            }
        }
        
        if(accToCon.isEmpty()) {
            return;
        }
        
        List<Contact> prevConList = [ SELECT AccountId, Role__c FROM Contact WHERE AccountId IN :accToCon.keySet() AND Role__c = 'Decision Maker' ];
        
        if(prevConList.isEmpty()) return;
        
        
        for(Contact c : Trigger.new) {
            for(Contact con : prevConList) {
                if(c != null && con != null && c.AccountId != null && mapAccount.get(c.AccountId).ActiveDecision_Maker__c != null ) {
                    Integer contactSize = accToCon.get(c.AccountId).size();
                    if(con.AccountId == c.AccountId && contactSize++ >= mapAccount.get(c.AccountId).ActiveDecision_Maker__c) {
                        c.addError('You Can Not Insert With This Role');
                    }
                }
            }
        }
    }
    
    if(Trigger.isUpdate) {
        Map<Id, List<Contact>> accToCon = new Map<Id, List<Contact>>();
        for(Contact c : Trigger.new) {
            if( c != null && c.Role__c != null && c.Role__c == 'Decision Maker' && c.AccountId != null && Trigger.oldMap.get(c.Id).Role__c != 'Decision Maker' ) {
                if(!accToCon.containsKey(c.AccountId)) {
                    accToCon.put(c.AccountId, new List<Contact>());
                }
                accToCon.get(c.AccountId).add(c);
            }
        }
        
        Map<Id,Account> mapAccount = new Map<Id,Account>();
        for(Account a : [SELECT Id, ActiveDecision_Maker__c FROM Account WHERE Id = :accToCon.keySet() ]) {
            if(a != null && a.Id != null && !mapAccount.containsKey(a.Id) && a.ActiveDecision_Maker__c != null ) {
                mapAccount.put(a.id, a);
            }
        }
        
        if(accToCon.isEmpty()) {
            return;
        }
        List<Contact> prevConList = [ SELECT AccountId, Role__c FROM Contact WHERE AccountId IN :accToCon.keySet() AND Role__c = 'Decision Maker' ];
        if(prevConList.isEmpty()) return;
        
        for(Contact c : Trigger.new) {
            for(Contact con : prevConList) {
                if(c != null && con != null && c.AccountId != null && mapAccount.get(c.AccountId).ActiveDecision_Maker__c != null ) {
                    Integer contactSize = accToCon.get(c.AccountId).size();
                    if(con.AccountId == c.AccountId && contactSize++ >= mapAccount.get(c.AccountId).ActiveDecision_Maker__c) {
                        c.addError('You Can Not Insert With This Role');
                    }
                }
            }
        }
    }
}