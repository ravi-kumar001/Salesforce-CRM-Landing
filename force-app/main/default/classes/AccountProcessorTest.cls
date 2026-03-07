@isTest
public class AccountProcessorTest {
    @isTest
    static void testCountContacts() {
        System.Test.setMock(HttpCalloutMock.class, new SMSCalloutMock());
        Account newAcc = new Account(Name = 'Test Account', Industry = 'Industry');
        insert newAcc;
        
        Contact newCon1 = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = newAcc.Id);
        Contact newCon2 = new Contact(FirstName = 'Jane', LastName = 'Doe', AccountId = newAcc.Id);
        insert new List<Contact>{newCon1, newCon2};
        
        List<Id> accountIds = new List<Id>{newAcc.Id};
        System.Test.startTest();
        AccountProcessor.countContacts(accountIds);
        System.Test.stopTest();
        Account updatedAcc = [SELECT Number_of_Contacts__c FROM Account WHERE Id = :newAcc.Id LIMIT 1];
        System.assertEquals(2, updatedAcc.Number_of_Contacts__c, 'The contact count should be 2');
    }
}