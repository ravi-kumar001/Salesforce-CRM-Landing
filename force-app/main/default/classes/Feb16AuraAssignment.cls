public with sharing class Feb16AuraAssignment {
    @AuraEnabled
    public static Map<String, Object> getRelatedData(Id recordId) {
        String sObjName = recordId.getSObjectType().getDescribe().getName();
        List<SObject> relatedRecords = new List<SObject>();
        String title = '';

        if (sObjName == 'Account') {
            title = 'Related Contacts';
            relatedRecords = [SELECT Name, Email FROM Contact WHERE AccountId = :recordId LIMIT 10];
        } else if (sObjName == 'Opportunity') {
            title = 'Related Products';
            relatedRecords = [SELECT Name, Quantity, ListPrice FROM OpportunityLineItem WHERE OpportunityId = :recordId LIMIT 10];
        }

        Map<String, Object> result = new Map<String, Object>();
        result.put('records', relatedRecords);
        result.put('title', title);
        result.put('objType', sObjName);
        return result;
    }
}