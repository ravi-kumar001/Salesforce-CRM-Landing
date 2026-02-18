trigger Jan31Assign1 on Contact (before insert, before update) {
    List<Email_Domain_Config__mdt> domainList = [ SELECT Domain__c, Id FROM Email_Domain_Config__mdt ];

    if(!domainList.isEmpty()) {
            String allowedDomain = '';
    
            for(Integer i = 0; i < domainList.size(); i++) {
                allowedDomain +=  i != domainList.size() - 1 ? domainList[i].Domain__c + ', ' : domainList[i].Domain__c + ' ';
            }
            
            for(Contact c : Trigger.new) {
                if(Trigger.isInsert && c.Email != null && !check(c.email, domainList)) {
                    c.Email.addError('Domain should be [ ' + allowedDomain + ' ]');
                } else if (Trigger.isUpdate && c.Email != null && !check(Trigger.oldMap.get(c.Id).Email , domainList) && !check(c.email, domainList) ) {
                    c.Email.addError('Domain should be [ ' + allowedDomain + ' ]');
                }
            }
    }
    
    public boolean check(String email, List<Email_Domain_Config__mdt> domainList) {
        for(Email_Domain_Config__mdt md : domainList) {
            if(email.contains(md.Domain__c)) return true;
        }
        return false;
    }
}