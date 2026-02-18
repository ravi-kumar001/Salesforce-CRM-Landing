trigger Feb6KrowProject on Opportunity (after insert, after update) {
    if(Trigger.isUpdate && Trigger.isAfter) {
        Feb6KrowProjectHandler.afterUpdate(Trigger.new, Trigger.oldMap);
    }
}