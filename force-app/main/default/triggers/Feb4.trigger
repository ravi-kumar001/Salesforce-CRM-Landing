trigger Feb4 on My_Custom_Task__c (before insert) {
	
    Set<Id> projectIds = new Set<Id>();
    Set<Id> customTaskIds = new Set<Id>();
    for(My_Custom_Task__c t : Trigger.new) {
        if(t.Project__c != null && !projectIds.contains(t.Project__c)) {
            projectIds.add(t.Project__c);
            customTaskIds.add(t.Id);
        }
    }
    
    if(projectIds.isEmpty()) return;
    
    List<Project__c> projectLst = [ SELECT Id, Total_Planned_Hour__c FROM Project__c WHERE Id IN :projectIds ];
    if(projectLst.size() == 0) return;
    
    Map<Id, Project__c> projectMap = new Map<Id, Project__c>();
    
    for(Project__c p : projectLst) {
        if(p != null && p.Id != null && p.Total_Planned_Hour__c != null && !projectMap.containsKey(p.Id)) {
            projectMap.put(p.Id, p);
        }
    }
    
    if(projectmap.isEmpty()) return;
    
    List<Time_Sheet__c> timeSheetLst = [ SELECT Id, Worked_Hour__c FROM Time_Sheet__c WHERE My_Custom_Task__c IN :customTaskIds ];
    
    Map<Id, Id> taskIdToTimeSheetId = new Map<Id, Id>();
    for(Time_Sheet__c tSheet : timeSheetLst) {
        if(tSheet.Id != null && tSheet.My_Custom_Task__c != null && !taskIdToTimeSheetId.containsKey(tSheet.Id)) {
            taskIdToTimeSheetId.put(tSheet.My_Custom_Task__c, tSheet.Id);
        }
    }
    
    if(timeSheetLst.size() == 0) return;
    
    Map<Id,Time_Sheet__c> timeSheetMap = new Map<Id, Time_Sheet__c>();
    
    for(Time_Sheet__c ts : timeSheetLst ) {
        if(ts != null && ts.Id != null && ts.Worked_Hour__c != null && !timeSheetMap.containsKey(ts.Id)) {
            timeSheetMap.put(ts.Id, ts);
        }
    }
    
    if(timeSheetMap.isEmpty()) return;
    
    for(My_Custom_Task__c t : Trigger.new) {
        if(t.Hour__c != null) {
            Decimal hour = t.Hour__c;
            Id projectId = t.Project__c;
            Id timeSheetId = taskIdToTimeSheetId.get(t.Id);
            
            if(t.Hour__c > projectMap.get(projectId).Total_Planned_Hour__c || t.Hour__c < timeSheetMap.get(timeSheetId).Worked_Hour__c ) {
                t.addError('Hour Exceed');
            }
        }
    }
    
}