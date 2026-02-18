trigger Jan28AssignSe4 on Student__c (after insert, after update) {
    List<Student__c> totalStudentList = new List<Student__c>();
    for(Student__c s : Trigger.new) {
        if(Trigger.isInsert && Trigger.isAfter && s.Fee_Status__c == 'Defaulter' ) {
            totalStudentList.add(s);
        } else if(Trigger.isUpdate && Trigger.isAfter && Trigger.oldMap.get(s.Id).Fee_Status__c != 'Defaulter' && s.Fee_Status__c == 'Defaulter') {
            totalStudentList.add(s);
        }
        
        Jan28AssignSe4Class jClass = new Jan28AssignSe4Class();
        jClass.caseHandler(totalStudentList);
    }
}