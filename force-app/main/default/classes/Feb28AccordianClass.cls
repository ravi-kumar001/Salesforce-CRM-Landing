public class Feb28AccordianClass {

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountWithContact() {
        return [SELECT Id, Name, Phone, Industry, (SELECT Id, FirstName, LastName, Email FROM Contacts)  FROM Account];
    }

    @AuraEnabled
    public static void deleteContact(Id contactId) {
        Contact recordsToDelete = [SELECT Id FROM Contact WHERE Id = :contactId];
        if (recordsToDelete != null) {
            delete recordsToDelete;
        }   
    }
}