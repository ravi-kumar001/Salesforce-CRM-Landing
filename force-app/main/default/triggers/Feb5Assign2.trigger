trigger Feb5Assign2 on Student__c (before insert, after update) {
    if(Trigger.isBefore) {
        Feb5Assign2Handler.afterInsert(Trigger.new);
    }
    
    if(Trigger.isUpdate && Trigger.isAfter) {
        Feb5Assign2Handler.afterUpdate(Trigger.new, Trigger.oldMap);
    }
}