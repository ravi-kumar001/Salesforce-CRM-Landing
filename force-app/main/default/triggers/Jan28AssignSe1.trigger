trigger Jan28AssignSe1 on Contact (before insert) {
    
    Set<String> uniqueSet = new Set<String>();
    
    Set<String> fn = new Set<String>();
    Set<String> ln = new Set<String>();
    Set<String> email = new Set<String>();
    
    for(Contact c : Trigger.new) {
        if(c.FirstName != '') {
            fn.add(c.FirstName);
        }
        if(c.LastName != '') {
            ln.add(c.LastName);
        }
        if(c.Email != '') {
            email.add(c.Email);
        }
    }
    
    List<Contact> conList = [ SELECT FirstName, Email, LastName FROM Contact WHERE Email IN :email OR (FirstName IN :fn And LastName In :ln) ];
        
    for(Contact contact : Trigger.new) {      
        
        String uniqueKey = contact.FirstName + contact.Email + contact.LastName;
        Boolean isHit = false;
        for(Contact c : conList) {
                if(contact.FirstName == c.FirstName && contact.LastName == c.LastName) {
                   isHit = true;
                }
        }
        
        if(uniqueSet.contains(uniqueKey) || isHit) {
             contact.addError('You are trying to inset duplicate contact');
        } else {
            uniqueSet.add(uniqueKey);
        }
    }
}