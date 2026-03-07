public with sharing class JobCardController {

    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> searchProduct(String chassisNo){

        return [
            SELECT Id,
                   Quantity,
                   Opportunity.Name,
                   Chasis_Number__c,
                   PricebookEntry.Product2.Name,
                   PricebookEntry.Product2.ProductCode
            FROM OpportunityLineItem
            WHERE Chasis_Number__c LIKE :('%' + chassisNo + '%')
        ];
    }
}