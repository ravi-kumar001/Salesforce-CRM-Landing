trigger Feb7AssignTestClass on Account (before insert) {
    if(Trigger.isInsert && Trigger.isBefore) {
        for(Account a : Trigger.new) {
            a.Name = 'Mr.' + a.Name;
        }
    }
}