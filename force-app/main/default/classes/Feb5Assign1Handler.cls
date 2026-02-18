public class Feb5Assign1Handler {
    public static void afterInsert(List<Fee_Payment__c> feePaymentLst) {
        Set<Id> stundentIds = new Set<Id>();
        
        for(Fee_Payment__c fp : feePaymentLst) {
            if(fp.Student__c != null) {
                stundentIds.add(fp.Student__c);
            }
        }
        
        if(!stundentIds.isEmpty()) {
            Map<Id,Student__c> studentMap = new Map<Id, Student__c>([ SELECT Id, Total_Due__c, School__c, Status__c FROM Student__c WHERE Id IN :stundentIds ]);
            if(!studentMap.isEmpty()) {
                Set<Id> schoolIds = new Set<Id>();
                for(Student__c s : studentMap.values()) {
                    if(s.School__c != null) {
                        schoolIds.add(s.School__c);
                    }
                }
                
                Map<Id, School__c> schoolMap = new Map<Id, School__c>([SELECT Id, Total_Fee_Collected__c, Active_Student_Outstanding_Amount__c, Suspense_Amount__c FROM School__c  WHERE Id IN :schoolIds ]);
                Map<Id, School__c> studentIdToSchoolMap = new Map<Id, School__c>();
                
                if(!schoolMap.isEmpty()) {
                    for(Student__c s : studentMap.values()) {
                        if(s.School__c != null && !studentIdToSchoolMap.containsKey(s.Id)) {
                            studentIdToSchoolMap.put(s.Id, schoolMap.get(s.School__c));
                        }
                    }
                    
                    List<Student__c> updatedStudentLst = new List<Student__c>();
                    List<School__c> updatedSchoolLst = new List<School__c>();
                    
                    for(Fee_Payment__c feePayment : feePaymentLst) {
                        if(feePayment.Payment_Date__c != null && feePayment.Amount_Paid__c != null) {
                            
                            Id stuId = feePayment.Student__c;
                            Decimal currentDue = studentMap.get(stuId).Total_Due__c;
                            Decimal reducedDue = currentDue - feePayment.Amount_Paid__c;
                            
                            Student__c tempStudent = new Student__c();
                            tempStudent.Id = feePayment.Student__c;
                            tempStudent.Last_Payment_Date__c = feePayment.Payment_Date__c;
                            tempStudent.Total_Due__c = reducedDue;
                            
                            updatedStudentLst.add(tempStudent);
                            
                            Decimal currTotalcollected = 0;
                            if(studentIdToSchoolMap.get(stuId).Total_Fee_Collected__c != null) {
                                currTotalcollected += studentIdToSchoolMap.get(stuId).Total_Fee_Collected__c + feePayment.Amount_Paid__c;
                            } else if(studentIdToSchoolMap.get(stuId).Total_Fee_Collected__c == null) {
                                currTotalcollected += feePayment.Amount_Paid__c;
                            }
                            System.debug(currTotalcollected);
                            
                            School__c tempSchool = new School__c();
                            tempSchool.Id = studentIdToSchoolMap.get(stuId).Id;
                            tempSchool.Total_Fee_Collected__c = currTotalcollected;
                            
                            Decimal suspenseAmount = 0;
                            
                            if(studentMap.get(stuId).Status__c == 'Inactive') {
                                if(studentIdToSchoolMap.get(stuId).Suspense_Amount__c != null) {
                                    suspenseAmount += studentIdToSchoolMap.get(stuId).Suspense_Amount__c - feePayment.Amount_Paid__c;
                                }
                                System.debug(suspenseAmount);
                                tempSchool.Suspense_Amount__c = suspenseAmount;
                            }
                            
                            Decimal activeStudentTotalAmountDue = 0;
                            if(studentMap.get(stuId).Status__c == 'active') {
                                if(studentIdToSchoolMap.get(stuId).Active_Student_Outstanding_Amount__c != null) {
                                    activeStudentTotalAmountDue += studentIdToSchoolMap.get(stuId).Active_Student_Outstanding_Amount__c - feePayment.Amount_Paid__c;
                                }
                                System.debug(activeStudentTotalAmountDue);
                                tempSchool.Active_Student_Outstanding_Amount__c = activeStudentTotalAmountDue;
                            }
                            
                            updatedSchoolLst.add(tempSchool);
                            
                        }
                    }
                    
                    if(!updatedStudentLst.isEmpty()) update updatedStudentLst;
                    if(!updatedSchoolLst.isEmpty()) update updatedSchoolLst;
                }
            }
        } 
    }
}