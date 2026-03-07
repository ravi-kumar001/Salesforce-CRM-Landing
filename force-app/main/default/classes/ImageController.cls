public with sharing class ImageController {

    @AuraEnabled
    public static String getRecordImageAsBase64(Id recordId) {

        if(recordId == null){
            return null;
        }

        List<ContentDocumentLink> links = [
            SELECT ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :recordId
            LIMIT 1
        ];

        if(links.isEmpty()){
            return null;
        }

        ContentVersion cv = [
            SELECT Id, VersionData, FileExtension
            FROM ContentVersion
            WHERE ContentDocumentId = :links[0].ContentDocumentId
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];

        Blob imageBlob = cv.VersionData;
        String base64Data = EncodingUtil.base64Encode(imageBlob);
        String mimeType = 'image/' + cv.FileExtension.toLowerCase();

        return 'data:' + mimeType + ';base64,' + base64Data;
    }
}