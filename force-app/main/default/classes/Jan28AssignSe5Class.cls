public class Jan28AssignSe5Class {
    public static void afterInsert(List<Accounts_RelationShip_Maps__c> accountRelationShipMapList) {
        Map<Id,Id> fromMapForToAccount = new Map<Id,Id>();
        
        for(Accounts_RelationShip_Maps__c ars : accountRelationShipMapList) {
            if(ars != null && ars.From_Account__c != null && ars.To_Account__c != null ) {
                fromMapForToAccount.put(ars.From_Account__c, ars.To_Account__c);
            }
        }
        
        if(fromMapForToAccount.isEmpty()) return;
        
        List<Contact> fromAccountContactList = [ SELECT Id, AccountId, FirstName, LastName, Email, Phone, Title FROM Contact WHERE AccountId IN :fromMapForToAccount.keySet() ];
        if(fromAccountContactList.isEmpty()) return;
        
        List<Contact> insertedList = new List<Contact>();
        
        System.debug(fromAccountContactList);
        
        for(Contact c : fromAccountContactList ) {
            Contact clone = c.clone();
            clone.AccountId = fromMapForToAccount.get(c.AccountId);
            clone.Parent_Contact__c = c.Id;
            insertedList.add(clone);
        }
        System.debug(insertedList);
        
        if(insertedList.size() > 0 ) {
            Database.DMLOptions dml = new Database.DMLOptions();
			dml.DuplicateRuleHeader.allowSave = true;
            Database.insert(insertedList, dml);
        }
    }
    
    public static void afterDelete(List<Accounts_RelationShip_Maps__c> accountRelationShipMapList) {
        Set<Id> toAccountIdSet = new Set<Id>();
        
        for(Accounts_RelationShip_Maps__c ars : accountRelationShipMapList) {
            if(ars != null) {
                toAccountIdSet.add(ars.To_Account__c);
            }
        }
        
        if(toAccountIdSet.isEmpty()) {
            return;
        }
        
        List<Contact> toAccountContactList = [ SELECT Id, AccountId FROM Contact WHERE AccountId IN :toAccountIdSet AND Parent_Contact__c != null ];
        
        if(!toAccountContactList.isEmpty()) {
            delete toAccountContactList;
        }
    }
}