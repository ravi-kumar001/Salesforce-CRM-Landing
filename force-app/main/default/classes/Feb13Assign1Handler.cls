public class Feb13Assign1Handler {
    public static void afterInsert(List<Opportunity> oppLst, Map<Id, Opportunity> oppMap) {
        
        Set<Id> activeOppIdsSet = new Set<Id>();
        
        for(Opportunity o : oppLst) {
            if((oppMap == null || o.Active__c != oppMap.get(o.Id).Active__c) && o.Active__c == true) {
                activeOppIdsSet.add(o.Id);
            }
        }
        
        if(!activeOppIdsSet.isEmpty()) {
            List<Opportunity> oppList = [SELECT Id, Name, How_Many_Months__c, StageName, CloseDate, Pricebook2Id, (SELECT Id, Product2.MCQ_Type__c, Product2.MCQ_Parent_Code__c, Quantity, UnitPrice FROM OpportunityLineItems) FROM Opportunity WHERE Id IN :activeOppIdsSet ];
            Map<Id, Opportunity> filterOppMap = new Map<Id, Opportunity>();
            
            for(Opportunity o : oppList) {
                if(o.OpportunityLineItems.size() > 0) {
                    filterOppMap.put(o.Id, o);
                }
            }
            
            if(!filterOppMap.isEmpty()) {
                List<MCQ_Contract__c> mcqContractsList = new List<MCQ_Contract__c>();
                for(Opportunity filterOpp : filterOppMap.values()) {
                    Set<String> mcqTypeSet = new Set<String>();
                    for(OpportunityLineItem oli : filterOpp.OpportunityLineItems) {
                        mcqTypeSet.add(oli.Product2.MCQ_Type__c);
                    }
                    if(!mcqTypeSet.isEmpty()) {
                        for(String t : mcqTypeSet) {
                            MCQ_Contract__c tempContract = new MCQ_Contract__c();
                            tempContract.Name = 'Contract - ' + t;
                            tempContract.Opportunity__c = filterOpp.Id;
                            tempContract.Total_Opportunities__c = 0;
                            
                            mcqContractsList.add(tempContract);
                        }
                    }
                }
                
                if(!mcqContractsList.isEmpty()) insert mcqContractsList;
                
                List<Opportunity> finalOppList = new List<Opportunity>();
                
                for(MCQ_Contract__c c : mcqContractsList){
                    Opportunity p = filterOppMap.get(c.Opportunity__c);
                    
                    if(p != null && c.Name != null ) {
                        if(c.Name == 'Contract - OneTime'){
                            Opportunity o = new Opportunity();
                            o.Name = p.Name+' - OneTime';
                            o.MCQ_Start_Date__c = Date.today();
                            o.MCQ_End_Date__c = Date.today() + 30;
                            o.MCQ_Contract__c = c.Id;
                            o.StageName = p.StageName;
                            o.CloseDate = p.CloseDate;
                            finalOppList.add(o);
                        } else if(c.Name == 'Contract - Montly'){
                            Integer total = Integer.valueOf(p.How_Many_Months__c);
                            for(Integer i=1; i<=total; i++){
                                Opportunity o = new Opportunity();
                                o.Name = p.Name+' - Month ' + i;
                                o.MCQ_Start_Date__c = Date.today();
                                o.MCQ_End_Date__c = Date.today().addMonths(i);
                                o.MCQ_Contract__c = c.Id;
                                o.StageName = p.StageName;
                                o.CloseDate = p.CloseDate;
                                finalOppList.add(o);
                            }
                        } else if(c.Name == 'Contract - Quaterly'){
                            Integer total = Integer.valueOf(p.How_Many_Months__c) / 3;
                            for(Integer i=1; i<=total; i++){
                                Opportunity o = new Opportunity();
                                o.Name = p.Name+' - Quarter '+ i;
                                o.MCQ_Start_Date__c = Date.today();
                                o.MCQ_End_Date__c = Date.today().addMonths(i*3);
                                o.MCQ_Contract__c = c.Id;
                                o.StageName = p.StageName;
                                o.CloseDate = p.CloseDate;
                                finalOppList.add(o);
                            }
                        }
                    }
                }
                
                if(!finalOppList.isEmpty()) insert finalOppList;
                
                Map<Id, Opportunity> newOppMap = new Map<Id, Opportunity>(finalOppList);
                
                List<OpportunityLineItem> oliToInsert = new List<OpportunityLineItem>();
                for(Opportunity p : filterOppMap.values()){
                    
                    Map<String, Id> pbeMap = new Map<String, Id>();
                    for(PricebookEntry pbe : [SELECT Id, Product2Id FROM PricebookEntry WHERE Pricebook2Id = :p.Pricebook2Id]){
                        pbeMap.put(pbe.Product2Id, pbe.Id);
                    }
                    
                    Set<String> parentCodes = new Set<String>();
                    
                    for(OpportunityLineItem oli : p.OpportunityLineItems){
                        if(oli.Product2.MCQ_Parent_Code__c != null){
                            parentCodes.add(oli.Product2.MCQ_Parent_Code__c);
                        }
                    }
                    
                    List<Product2> mappedProducts = new List<Product2>();
                    
                    if(!parentCodes.isEmpty()){
                        mappedProducts = [SELECT Id FROM Product2 WHERE MCQ_Parent_Code__c IN :parentCodes ];
                    }
                    
                    for(MCQ_Contract__c c : mcqContractsList){
                        if(c.Opportunity__c != p.Id) continue;
                        
                        for(Opportunity newOpp : finalOppList){
                            if(newOpp.MCQ_Contract__c != c.Id) continue;
                            
                            for(OpportunityLineItem oldOli : p.OpportunityLineItems){
                                OpportunityLineItem n = new OpportunityLineItem();
                                n.OpportunityId = newOpp.Id;
                                n.PricebookEntryId = pbeMap.get(oldOli.Product2Id);
                                n.Quantity = oldOli.Quantity;
                                n.UnitPrice = oldOli.UnitPrice;
                                oliToInsert.add(n);
                            }
                            
                            for(Product2 cp : mappedProducts){
                                OpportunityLineItem cOLI = new OpportunityLineItem();
                                cOLI.OpportunityId = newOpp.Id;
                                cOLI.PricebookEntryId = pbeMap.get(cp.Id);
                                cOLI.Quantity = 1;
                                cOLI.UnitPrice = 0;
                                oliToInsert.add(cOLI);
                            }
                        }
                    }
                }
                
                if(!oliToInsert.isEmpty()) insert oliToInsert;
            }
        }
    }
}