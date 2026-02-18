public class SendAttachment {
    public List<ContentVersionWrapper> cvWrapper { get; set; }

    public class ContentVersionWrapper {
        public ContentVersion cv { get; set; }
        public Boolean isSelected { get; set; }

        public ContentVersionWrapper(ContentVersion c) {
            this.cv = c;
            this.isSelected = false;
        }
    }
    
    public SendAttachment() {
        findAllDocument();
    }

    public void findAllDocument() {
        cvWrapper = new List<ContentVersionWrapper>();

        for (ContentVersion c : [ SELECT Id, Title, FileExtension, VersionData, ContentSize, ContentDocumentId FROM ContentVersion LIMIT 2 ]) {
            cvWrapper.add(new ContentVersionWrapper(c));
        }
    }
}