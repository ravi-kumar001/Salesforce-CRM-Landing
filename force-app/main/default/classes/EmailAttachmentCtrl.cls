public class EmailAttachmentCtrl{

    public String accId {get; set;}
    public List<AttWrap> attWrap {get; set;}

    public EmailAttachmentCtrl(){

        accId = ApexPages.currentPage()
                .getParameters().get('accId');

        attWrap = new List<AttWrap>();

        if(String.isBlank(accId)) return;

        // STEP 1: Get Task Ids
        List<Task> tasks = [
            SELECT Id
            FROM Task
            WHERE WhatId = :accId
        ];

        if(tasks.isEmpty()) return;

        Set<Id> taskIds = new Set<Id>();
        for(Task t : tasks){
            taskIds.add(t.Id);
        }

        // STEP 2: Get Attachments
        List<Attachment> atts = [
            SELECT Id, Name, ContentType, BodyLength
            FROM Attachment
            WHERE ParentId IN :taskIds
        ];

        for(Attachment a : atts){
            attWrap.add(new AttWrap(a));
        }
    }

    public class AttWrap{
        public Attachment att {get;set;}
        public Boolean sel {get;set;}

        public AttWrap(Attachment a){
            att = a;
            sel = false;
        }
    }
}