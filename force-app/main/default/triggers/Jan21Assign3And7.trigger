trigger Jan21Assign3And7 on Case (before insert, before update) {
 
    Set<Id> accSet = new Set<Id>();
    
    for(Case c : Trigger.new) {
        if(c.AccountId != null) {
            accSet.add(c.AccountId);
        }
    }
    
    if(Trigger.isUpdate) {
        Jan21 j = new Jan21();
        j.Jan21Assign7(Trigger.new);
    }
    
    if(!accSet.isEmpty()) {
        	List<Account> accountList = [ SELECT Id, Phone FROM Account WHERE Id IN :accSet ];
            Map<Id, Account > acc = new Map<Id, Account>(accountList);    
          
            for(Case c : Trigger.new) {
                 if(c.AccountId != null && acc.containsKey(c.AccountId)) {
                    Account temp = acc.get(c.AccountId);
    
                    if(temp.Phone != null) {
                        c.Custom_Contact_Phone__c = temp.Phone;
                    }
                }
            }
    }
}