public class SchoolPaymentMethod {
   
    public static void paymentUpdate(List<Fee_Payment__c> newlist, Map<Id, Fee_Payment__c> oldMap){
       
        Set<Id> studentId = new Set<Id>();
       
        for(Fee_Payment__c fp : newlist){
            if(fp.Student__c != null){
               
                studentId.add(fp.Student__c);
            }
        }
       
        if(studentId.isEmpty()){
            return;
        }

        Map<Id, Student__c> studentMap = new Map<Id, Student__c>(
            [SELECT Id, School__c, Fee_Plan__c, Total_Due__c, Status__c, Last_Payment_Date__c
             FROM Student__c
             WHERE Id IN :studentId]
        );
         
        List<Student__c> studentUpdate = new List<Student__c>();
       
        for(Fee_Payment__c fp : newlist){
            Student__c stu = studentMap.get(fp.Student__c);
           
            if(stu != null){
               
                if(stu.Total_Due__c == null){
                    stu.Total_Due__c = 0;
                }
               
                Decimal newAmount = fp.Amount_Paid__c != null ? fp.Amount_Paid__c : 0;
                Decimal oldAmount = 0;

               
                if(oldMap != null && oldMap.containsKey(fp.Id)){
                    Fee_Payment__c oldFp = oldMap.get(fp.Id);
                    oldAmount = oldfp.Amount_Paid__c != null ? oldFp.Amount_Paid__c :0;
                }
                Decimal netPay = newAmount - oldAmount;
                stu.Total_Due__c = stu.Total_Due__c - netPay;
               
               
                if(fp.Payment_Date__c != null){
                    if(fp.Payment_Date__c > stu.Last_Payment_Date__c ){
                              stu.Last_Payment_Date__c = fp.Payment_Date__c;
               
                    }
                }
               
               
                studentUpdate.add(stu);
            }
        }
       
        if(!studentUpdate.isEmpty()){
            update studentUpdate;
        }      
       
        Set<Id> schoolId = new Set<Id>();
        for(Student__c stu : studentUpdate){
           
            if(stu.School__c != null){
                schoolId.add(stu.School__c);
            }
        }
       
        if(schoolId.isEmpty()){
            return;
        }
       
       
        Map<Id, School__c> schoolMap = new Map<Id, School__c>(
            [SELECT Id, Total_Fee_Collected__c, Active_Student_Outstanding_Amount__c, Suspense_Amount__c
             FROM School__c
             WHERE Id IN :schoolId]
        );
       
       
        Map<Id, Decimal> OutstandingMap = new Map<Id, Decimal>();
       
        for(AggregateResult ar : [SELECT School__c, SUM(Total_Due__c) totalOutstanding FROM Student__c WHERE School__c IN :schoolId AND Status__c = 'Active'  GROUP BY School__c]){
            Id schId = (Id)ar.get('School__c');
           
            Decimal outstanding = (Decimal)ar.get('totalOutstanding');
           
            OutstandingMap.put(schId, outstanding != null ? outstanding : 0);
        }
       
        Map<Id,Decimal> amountSuspense =new Map<Id,Decimal>();
        for(AggregateResult ar : [SELECT School__c, SUM(Total_Due__c) suspenseAmonut FROM Student__c WHERE School__c IN :schoolId AND Status__c = 'InActive'  GROUP BY School__c]){

            amountSuspense.put((Id)ar.get('School__c') , (Decimal)ar.get('suspenseAmount'));
           
        }
       
        Map<Id, Decimal> schoolPaymentMap = new Map<Id, Decimal>();
        for(Fee_Payment__c fp : newlist){
           
            Student__c stu = studentMap.get(fp.Student__c);
            if(stu != null && stu.School__c != null){
               
                if(!schoolPaymentMap.containsKey(stu.School__c)){
                    schoolPaymentMap.put(stu.School__c, 0);
                }
               
                Decimal netPayment = 0;
               
                if(oldMap != null && oldMap.containsKey(fp.Id)){
                    Fee_Payment__c oldFp = oldMap.get(fp.Id);
                   
                   
                    Decimal oldAmount = oldFp.Amount_Paid__c != null ? oldFp.Amount_Paid__c : 0;
                    Decimal newAmount = fp.Amount_Paid__c != null ? fp.Amount_Paid__c : 0;
                   
                   
                    netPayment = newAmount - oldAmount;
                } else {
                   
                    netPayment = fp.Amount_Paid__c != null ? fp.Amount_Paid__c : 0;
                }
               
                schoolPaymentMap.put(stu.School__c, schoolPaymentMap.get(stu.School__c) + netPayment);
            }
        }
       
        List<School__c> schoolUpdateList = new List<School__c>();
       

        for(Id schId : schoolId){
           
            School__c schl = schoolMap.get(schId);
            if(schl != null){
               
                if(schl.Total_Fee_Collected__c == null){
                    schl.Total_Fee_Collected__c = 0;
                }
               
               
                if(schoolPaymentMap.containsKey(schId)){
                    schl.Total_Fee_Collected__c = schl.Total_Fee_Collected__c + schoolPaymentMap.get(schId);
                }
               
               
                schl.Active_Student_Outstanding_Amount__c = OutstandingMap.get(schId) != null
                    ? OutstandingMap.get(schId) : 0;
               
                schoolUpdateList.add(schl);
            }
        }
       
        if(!schoolUpdateList.isEmpty()){
            update schoolUpdateList;
        }
    }
}