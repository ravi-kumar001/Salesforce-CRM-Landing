public class FileUploadController {

    public Blob uploadedFile { get; set; }
    public String fileName { get; set; }

    public void uploadFile() {

        if (uploadedFile == null || String.isBlank(fileName)) {
            ApexPages.addMessage(
                new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select a file.')
            );
            return;
        }

        ContentVersion cv = new ContentVersion();
        cv.Title = fileName;
        cv.PathOnClient = fileName;
        cv.VersionData = uploadedFile;

        insert cv;

        ApexPages.addMessage(
            new ApexPages.Message(ApexPages.Severity.CONFIRM, 'File uploaded successfully.')
        );
    }
}