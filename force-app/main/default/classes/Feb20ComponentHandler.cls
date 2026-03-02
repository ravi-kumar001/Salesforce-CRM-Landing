public class Feb20ComponentHandler {
    
    @AuraEnabled
    public static List<Contact> getContacts() {
        return [SELECT Id, Name, Email, Phone FROM Contact LIMIT 50];
    }
    
    @AuraEnabled
    public static void deleteContact(String contactId) {
        if(contactId != '') {
            Contact con = [SELECT Id FROM Contact WHERE Id = :contactId LIMIT 1];
            delete con;
        }
    }
    
    @AuraEnabled
    public static List<Contact> findByName(String searchKey) {
        String name = '%' + searchKey + '%';
        return [SELECT Id, Name, Phone, Email FROM Contact WHERE Name LIKE :name];
    }
}