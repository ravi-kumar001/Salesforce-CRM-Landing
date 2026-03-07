public class AccountProcessor {
    @Future
    public static void countContacts(List<Id> accountIds) {
        List<Account> updateAccList = new List<Account>();
        
        List<Account> accList = [SELECT Id, (SELECT Id, Name FROM Contacts) FROM Account WHERE Id IN :accountIds];
        
        for(Account a : accList) {
            a.Number_Of_Contacts__c = a.Contacts.size();
            updateAccList.add(a);
        }
        
        if(!updateAccList.isEmpty()) {
            update updateAccList;
        }
    }
}