trigger Jan28AssignSe5 on Accounts_RelationShip_Maps__c (after insert, after delete) {
    if(Trigger.isAfter) {
        if(Trigger.isInsert) {
            Jan28AssignSe5Class.afterInsert(Trigger.new);
        }
        
        if(Trigger.isDelete) {
            Jan28AssignSe5Class.afterDelete(Trigger.old);
        }
    }
}