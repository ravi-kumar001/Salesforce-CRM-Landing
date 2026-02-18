trigger Jan28AssignSe3 on Student__c (before insert, before update) {
    if(Trigger.isInsert && Trigger.isBefore) {
        Set<Id> classIdSets = new Set<Id>();
        for(Student__c s : Trigger.new) {
            if(s != null) {
                classIdSets.add(s.ClassRelation__c);
            }
        }
        
        if(classIdSets.isEmpty()) return;
        
        List<Student__c> studentLst = [SELECT ClassRelation__c FROM Student__c WHERE ClassRelation__c IN :classIdSets ];
                   
        Map<Id, List<Student__c>> classToStudent = new Map<Id, List<Student__c>>();
        for(Student__c s : studentLst) {
            if(s != null && s.ClassRelation__c != null && !classToStudent.containsKey(s.ClassRelation__c)) {
                classToStudent.put(s.ClassRelation__c, new List<Student__c>());
            }
            classToStudent.get(s.ClassRelation__c).add(s);
        }
        
        if(classToStudent.isEmpty()) return;
        
        System.debug(classToStudent);
        
        for(Student__c s : Trigger.new) {
            if(s.ClassRelation__c != null && classToStudent.containsKey(s.ClassRelation__c) && classToStudent.get(s.ClassRelation__c).size() >= 10) {
                s.addError('10 student exist already');
            }
        }
    }
    
    if(Trigger.isUpdate && Trigger.isBefore) {
        Set<Id> classIdSets = new Set<Id>();
        for(Student__c s : Trigger.new) {
            if(s != null && Trigger.oldMap.get(s.Id).ClassRelation__c != s.ClassRelation__c) {
                classIdSets.add(s.ClassRelation__c);
            }
        }
        
        if(classIdSets.isEmpty()) return;
        
        List<Student__c> studentLst = [SELECT ClassRelation__c FROM Student__c WHERE ClassRelation__c IN :classIdSets ];
                   
        Map<Id, List<Student__c>> classToStudent = new Map<Id, List<Student__c>>();
        for(Student__c s : studentLst) {
            if(s != null && s.ClassRelation__c != null && !classToStudent.containsKey(s.ClassRelation__c)) {
                classToStudent.put(s.ClassRelation__c, new List<Student__c>());
            }
            classToStudent.get(s.ClassRelation__c).add(s);
        }
        
        if(classToStudent.isEmpty()) return;
        
        for(Student__c s : Trigger.new) {
            if(s != null && s.ClassRelation__c != null  && classToStudent.containsKey(s.ClassRelation__c) && classToStudent.get(s.ClassRelation__c).size() >= 10) {
                s.addError('10 student exist already');
            }
        }
    }
}