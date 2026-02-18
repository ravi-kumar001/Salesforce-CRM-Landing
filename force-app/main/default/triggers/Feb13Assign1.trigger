trigger Feb13Assign1 on Opportunity (after insert, after update) {
    if(Trigger.isInsert || Trigger.isUpdate && Trigger.isAfter) {
        Feb13Assign1Handler.afterInsert(Trigger.new, Trigger.isUpdate ? Trigger.oldMap : null);
    }
}