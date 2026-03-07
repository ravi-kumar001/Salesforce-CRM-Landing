public with sharing class FileController {
    @AuraEnabled(cacheable=true)
    public static List<Id> getFileIds(Id recordId) {
        System.debug('Called');
        System.debug('recordId: ' + recordId);
        List<Id> fileIds = new List<Id>();
        List<ContentDocumentLink> cdlList = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
        for (ContentDocumentLink cdl : cdlList) {
            fileIds.add(cdl.ContentDocumentId);
        }
        return fileIds;
    }
}