trigger Jan21Assign2 on Opportunity (before insert) {
    List<Task> taskList = new List<Task>();
    for(Opportunity o : Trigger.new) {
        if(o.Amount > 50000) {
            taskList.add(new Task(
            	Subject = 'Follow Up Task', 
                WhatId = o.Id,
                OwnerId = o.OwnerId,
                ActivityDate = Date.today().addDays(7)
            ));
        }
    }
    
    if(!taskList.isEmpty()) {
        insert taskList;
    }
}