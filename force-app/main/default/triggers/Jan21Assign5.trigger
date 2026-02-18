trigger Jan21Assign5 on Contact (before update) {
	Set<Id > accSet = new Set<Id>();
    
    for(Contact c : Trigger.new) {
        if(c.AccountId != null) {
            accSet.add(c.AccountId);
        }
    }
    
    if(!accSet.isEmpty()) {
        List<Account> accountList = [ SELECT Id, Name, BillingCountry, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountryCode FROM Account WHERE Id IN :accSet ];
        Map<Id, Account> accountMap = new Map<Id, Account> (accountList);
        
        for(Contact c : Trigger.new) {
            if(c.Copy_Address_From_Account__c == true && c.AccountId != null && accountMap.containsKey(c.AccountId) ) {
                Account temp = accountMap.get(c.AccountId);
                c.MailingCountry = temp.BillingCountry ?? c.MailingCountry;
                c.MailingStreet = temp.BillingStreet ?? c.MailingStreet;
                c.MailingCity = temp.BillingCity ?? c.MailingCity;
                c.MailingState = temp.BillingState ?? c.MailingState;
                c.MailingPostalCode = temp.BillingPostalCode ?? c.MailingPostalCode;
                c.MailingCountryCode = temp.BillingCountryCode ?? c.MailingCountryCode;
            }
        }
    }
}