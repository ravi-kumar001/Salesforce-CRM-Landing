trigger Jan21 on Contact (before insert, after update) {
    
    Map<Id,Account> accMap = new Map<Id,Account>();
    
    for(Contact cont : trigger.new){
        
        if(cont.AccountId == null ) return;
        
        if(trigger.isInsert || (cont.Email != trigger.oldmap.get(cont.Id).Email || cont.Phone != trigger.oldmap.get(cont.Id).Phone)){
            
            if(!accMap.containsKey(cont.AccountId)){
                Account acc = new Account();
                acc.Id = cont.accountId;
                String temp = 'Email : ' + (cont.Email == null ? '' : cont.Email) + '; Phone : ' + (cont.Phone == null ? '' : cont.Phone);
                acc.CompleteContactDetails__c = temp;
                accMap.put(acc.Id,acc);    
            }
        }
    }
    
    if(!accMap.isEmpty()){
        update accMap.values();
    }
}