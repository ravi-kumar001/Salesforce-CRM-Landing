public class Feb5Assign2Handler {
    public static void afterInsert(List<Student__c> studentLst) {
        Set<Id> schoolIds = new Set<Id>();
        Set<Id> feePlanIds = new Set<Id>();
        for(Student__c s : studentLst) {
            if(s.School__c != null && s.Fee_Plan__c != null) {
                schoolIds.add(s.School__c);
                feePlanIds.add(s.Fee_Plan__c);
            }
        }
        
        if(!schoolIds.isEmpty() || !feePlanIds.isEmpty()) {
            Map<Id, School__c> schoolMap = new Map<Id, School__c> ([SELECT Id, Suspense_Amount__c, Active_Student_Outstanding_Amount__c  FROM School__c WHERE Id IN :schoolIds]);
            Map<Id,Fee_Plan__c> feePlanMap = new Map<Id,Fee_Plan__c>( [ SELECT Id, Decided_Fee__c FROM Fee_Plan__c WHERE Id IN :feePlanIds ] );
            
            if(!feePlanMap.isEmpty()) {
                List<School__c> schLst = new List<School__c>();
                
                for(Student__c s : studentLst) {
                    if(feePlanMap.get(s.Fee_Plan__c).Decided_Fee__c != null) {
                        Decimal decidedFee = feePlanMap.get(s.Fee_Plan__c).Decided_Fee__c;
                        System.debug(decidedFee);
                        s.Total_Due__c = decidedFee;
                    }
                    
                    Decimal suspenseAmount = 0;
                    School__c tempSchool = new School__c();
                    tempSchool.Id = s.School__c;
                    if(s.Status__c == 'Inactive') {
                        if(schoolMap.get(s.School__c).Suspense_Amount__c != null) {
                            suspenseAmount += schoolMap.get(s.School__c).Suspense_Amount__c + s.Total_Due__c;
                        } else {
                            suspenseAmount += s.Total_Due__c;
                        }
                        tempSchool.Suspense_Amount__c = suspenseAmount;
                    }
                    
                    Decimal activeStudentTotalAmountDue = 0;
                    if(s.Status__c == 'active') {
                        if(schoolMap.containsKey(s.School__c) && schoolMap.get(s.School__c).Active_Student_Outstanding_Amount__c != null) {
                            activeStudentTotalAmountDue += schoolMap.get(s.School__c).Active_Student_Outstanding_Amount__c + s.Total_Due__c;
                        } else {
                            activeStudentTotalAmountDue += s.Total_Due__c;
                        }
                        tempSchool.Active_Student_Outstanding_Amount__c = activeStudentTotalAmountDue;
                    }
                    
                    schLst.add(tempSchool);
                }
                
                if(!schLst.isEmpty()) update schLst;
            }
        }
    }
    
    public static void afterUpdate(List<Student__c> studentLst, Map<Id, Student__c> stuOldMap) {
        Set<Id> schoolIds = new Set<Id>();
        
        for(Student__c s : studentLst) {
            if(s.School__c != null && s.Status__c != stuOldMap.get(s.Id).Status__c ) {
                schoolIds.add(s.School__c);
            }
        }
        
        if(!schoolIds.isEmpty()) {
            Map<Id, School__c> schoolMap = new Map<Id, School__c>([ SELECT Id, Suspense_Amount__c, Active_Student_Outstanding_Amount__c FROM School__c WHERE Id IN :schoolIds ]);
            
            if(!schoolMap.isEmpty()) {
                List<School__c> updatedSchoolLst = new List<School__c>();
                
                for(Student__c s : studentLst) {
                    if(s.School__c == null || s.Total_Due__c == null || !schoolMap.containsKey(s.School__c)) {
                        continue;
                    }
                    
                    School__c schoolRecord = schoolMap.get(s.School__c);
                    
                    Decimal suspenseAmount = schoolRecord.Suspense_Amount__c != null ? schoolRecord.Suspense_Amount__c : 0;
                    Decimal activeStudentTotalAmountDue = schoolRecord.Active_Student_Outstanding_Amount__c != null ? schoolRecord.Active_Student_Outstanding_Amount__c: 0;
                    
                    School__c tempSchool = new School__c();
                    tempSchool.Id = s.School__c;
                    
                    if(stuOldMap.get(s.Id).Status__c == 'Inactive' && s.Status__c == 'active') {
                        suspenseAmount -= s.Total_Due__c;
                        activeStudentTotalAmountDue += s.Total_Due__c;
                    } else if(stuOldMap.get(s.Id).Status__c == 'active' && s.Status__c == 'Inactive') {
                        suspenseAmount += s.Total_Due__c;
                        activeStudentTotalAmountDue -= s.Total_Due__c;
                    } else {
                        continue;
                    }
                    
                    System.debug(suspenseAmount);
                    System.debug(activeStudentTotalAmountDue);
                    
                    tempSchool.Suspense_Amount__c = suspenseAmount;
                    tempSchool.Active_Student_Outstanding_Amount__c = activeStudentTotalAmountDue;
                    
                    updatedSchoolLst.add(tempSchool);
                }
                
                if(!updatedSchoolLst.isEmpty()) {
                    update updatedSchoolLst;
                }
            }
        }
    }
}