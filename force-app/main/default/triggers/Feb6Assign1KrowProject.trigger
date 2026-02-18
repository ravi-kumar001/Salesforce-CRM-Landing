trigger Feb6Assign1KrowProject on Order (before insert, before update, after update) {
    if (Trigger.isBefore) {
        Feb6Assign1KrowProjectHandler.validateOrderStatus(Trigger.new, Trigger.isUpdate ? Trigger.oldMap : null);
    }
    if (Trigger.isAfter && Trigger.isUpdate) {
        Feb6Assign1KrowProjectHandler.afterUpdate(Trigger.new, Trigger.oldMap);
    }
}