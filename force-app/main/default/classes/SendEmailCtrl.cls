public class SendEmailCtrl {

    public List<String> toList {get;set;}
    public List<String> toEmails {get;set;}
    public String subject {get;set;}
    public String body {get;set;}

    public Boolean showAttachmentFrame {get;set;}
    public List<ContentVersionWrapper> cvWrapper {get;set;}
    public List<AttachmentWrapper> attachments {get;set;}

    public SendEmailCtrl(){

    attachments = new List<AttachmentWrapper>();
    cvWrapper = new List<ContentVersionWrapper>();

    toList = new List<String>();
    toEmails = new List<String>();

    String ids = ApexPages.currentPage().getParameters().get('ids');

    if (ids != null) {
        List<Contact> cons = [
            SELECT Name, Email
            FROM Contact
            WHERE Id IN :ids.split(',')
        ];
        for(Contact c : cons){
            toList.add(c.Name);
            if(c.Email != null){
                toEmails.add(c.Email);
            }
        }
    }

    showAttachmentFrame = false;
    loadFiles();
}


    public void attachFile(){
        showAttachmentFrame = true;
    }

	public void loadFiles() {

    cvWrapper.clear();

    String idsParam = ApexPages.currentPage().getParameters().get('ids');
    if (idsParam == null) return;

    List<Id> recordIds = new List<Id>();
    for (String s : idsParam.split(',')) {
        recordIds.add((Id)s);
    }
    
    Set<Id> contentDocIds = new Set<Id>();

    for (ContentDocumentLink cdl : [
        SELECT ContentDocumentId
        FROM ContentDocumentLink
        WHERE LinkedEntityId IN :recordIds
    ]) {
        contentDocIds.add(cdl.ContentDocumentId);
    }

    if (contentDocIds.isEmpty()) return;
    
    for (ContentVersion cv : [
        SELECT Id, Title, FileExtension, VersionData,
               ContentSize, FileType
        FROM ContentVersion
        WHERE IsLatest = true
        AND ContentDocumentId IN :contentDocIds
    ]) {
        cvWrapper.add(new ContentVersionWrapper(cv));
    }
}


    public void addAllSelectedAttachments(){
        for(ContentVersionWrapper w : cvWrapper){
            if(w.isSelected){
                attachments.add(
                    new AttachmentWrapper(
                        w.cv.Title + '.' + w.cv.FileExtension,
                        w.cv.VersionData
                    )
                );
            }
        }
        showAttachmentFrame = false;
    }

    public void send(){
        List<Messaging.EmailFileAttachment> files =
            new List<Messaging.EmailFileAttachment>();

        for(AttachmentWrapper a : attachments){
            Messaging.EmailFileAttachment efa =
                new Messaging.EmailFileAttachment();
            efa.setFileName(a.fileName);
            efa.setBody(a.body);
            files.add(efa);
        }

        Messaging.SingleEmailMessage mail =
            new Messaging.SingleEmailMessage();
        mail.setToAddresses(toEmails);
        mail.setSubject(subject);
        mail.setHtmlBody(body);
        mail.setFileAttachments(files);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }

    public class ContentVersionWrapper{
        public ContentVersion cv {get;set;}
        public Boolean isSelected {get;set;}
        public ContentVersionWrapper(ContentVersion c){
            cv = c;
            isSelected = false;
        }
    }

    public void closeAttachPopup(){
        showAttachmentFrame = false;
    }


    public class AttachmentWrapper{
        public String fileName {get;set;}
        public Blob body {get;set;}
        public AttachmentWrapper(String f, Blob b){
            fileName = f;
            body = b;
        }
    }
}