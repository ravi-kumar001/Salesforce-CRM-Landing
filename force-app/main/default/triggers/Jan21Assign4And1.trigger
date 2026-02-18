trigger Jan21Assign4And1 on Account (before delete, before insert) {
      
    Set<Id> accountIdSet = new Set<Id>();
    
    if(Trigger.isDelete) {
        for(Account a : trigger.old){
            if(a.Id != null) {
                accountIdSet.add(a.Id);
            }
    	}
    }
    
    if(Trigger.isInsert) {
        Jan21 j = new Jan21();
        j.Jan21Assign1(Trigger.new);
    }
    
    List<Contact> contactList = [ SELECT Id FROM Contact WHERE AccountId IN :accountIdSet];
    if(contactList.size() > 0) {      
        for(Account a : trigger.old) {
            if(a.Id != null) {
                a.addError('Account Have Some Contacts');
            }
        }
    }
}