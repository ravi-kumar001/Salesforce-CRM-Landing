public class Jan28AssignSe4Class {
    public void caseHandler(List<Student__c> studentList) {
        List<Case> caseList = new List<Case>();
        for(Student__c s : studentList) {
            Case c = new Case();
             c.Subject = 'Defaulter ' + s.Name;
             c.Status = s.Fee_Status__c;
             c.Description = 'Description Regarding Case';
             caseList.add(c);
        }
    
    	if(!caseList.isEmpty()) {
            insert caseList;
        }
        
        List<Student__c> stLst = new List<Student__c>();
        
        for(Integer i = 0; i < studentList.size(); i++ ) {
            Student__c newSt = new Student__c();
            newSt.Student_Case__c = caseList[i].Id;
            newSt.Id = studentList[i].Id;
            stLst.add(newSt);
        }
        
        if(!stLst.isEmpty()) {
            update stLst;
        }
    }
}