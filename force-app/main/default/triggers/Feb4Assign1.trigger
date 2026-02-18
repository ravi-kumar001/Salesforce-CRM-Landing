trigger Feb4Assign1 on OpportunityLineItem (before insert) {
    if(Trigger.isBefore && Trigger.isInsert) {
        Feb4Assign1Handler.beforeInsert(Trigger.new);
    }
}