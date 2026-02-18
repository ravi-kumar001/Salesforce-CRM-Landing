trigger Feb5Assign1 on Fee_Payment__c (after insert) {
    if(Trigger.isAfter && Trigger.isInsert) {
        Feb5Assign1Handler.afterInsert(Trigger.new);
    }
}