public class EmailFileSelectorCtrl {

    public List<FileWrap> wrap {get;set;}

    public EmailFileSelectorCtrl(){
        wrap = new List<FileWrap>();

        String ids = ApexPages.currentPage().getParameters().get('ids');

Set<Id> contactIds = new Set<Id>();
for(String s : ids.split(',')){
    contactIds.add((Id)s);
    
    
}


        // 1️⃣ Get ContentDocumentIds
        Set<Id> docIds = new Set<Id>();

        for(ContentDocumentLink cdl : [
            SELECT ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId IN :contactIds
        ]){
            docIds.add(cdl.ContentDocumentId);
        }

        if(docIds.isEmpty()) return;

        // 2️⃣ Get latest versions
        for(ContentVersion cv : [
            SELECT Id, Title, FileExtension, VersionData
            FROM ContentVersion
            WHERE IsLatest = true
            AND ContentDocumentId IN :docIds
        ]){
            wrap.add(new FileWrap(cv));
        }
    }

    public class FileWrap{
        public ContentVersion cv {get;set;}
        public FileWrap(ContentVersion c){
            cv = c;
        }
    }
}