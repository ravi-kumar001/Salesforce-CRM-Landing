public class Feb14AuraForAccountControllerHandler {
    @AuraEnabled
    public static Account getAccountInfo(Id accId) {
        System.debug('Account Id' + accId);
        return [SELECT Id, Name, Phone, Industry FROM Account WHERE Id = :accId	LIMIT 1	];
    }

    @AuraEnabled
    public static List<Opportunity> getOppData(Id accountId){
        return [SELECT Id, AccountId, StageName, CloseDate, Name, Amount FROM Opportunity WHERE AccountId = :accountId];
    }
}