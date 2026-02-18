trigger Opportunity_Mapping on Opportunity (after insert) {
    if(Trigger.isInsert) {
        Opportunity_Mapping_Class.proudctAdd1(Trigger.new);
    }
}