public class Feb4Assign1Handler {
    public static void beforeInsert(List<OpportunityLineItem> oliList) {
        Set<Id> oIds = new Set<Id>();
        Set<Id> productIds = new Set<Id>();
        
        for(OpportunityLineItem o : oliList) {
            if(o.OpportunityId != null && o.Product2Id != null) {
                oIds.add(o.OpportunityId);
                productIds.add(o.Product2Id);
            }
        }
        
        if(!oIds.isEmpty() || !productIds.isEmpty()) {
            
            Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([ SELECT Id, AccountId FROM Opportunity WHERE Id In :oIds ]);
            
            if(!oppMap.isEmpty()) {
                
                Set<Id>accIds = new Set<Id>();
                
                for(Opportunity o : oppMap.values()) {
                    if(o.AccountId != null) {
                        accIds.add(o.AccountId);
                    }
                }
                
                if(!accIds.isEmpty()) {
                    
                    Map<Id,Account> accountMap = new Map<Id,Account>([ SELECT Id, No_Of_Product_Allowed__c, Allowed_Family__c FROM Account WHERE Id In :accIds ]);        
                    if(!accountMap.isEmpty()) {
                        
                        Map<Id, Product2> productMap = new Map<Id, Product2>([ SELECT Id, Family, ProductCode FROM Product2 WHERE Id IN :productIds ]);
                        if(!productMap.isEmpty()) {
                            
                            Map<Id, Set<String>> accToCodesSet = new Map<Id, Set<String>>();
                            Map<Id, Integer> accToProductCountMap = new Map<Id, Integer>();
                            
                            for(OpportunityLineItem o : oliList) {
                                if(o.OpportunityId != null && o.Product2Id != null) {
                                    Id accId = oppMap.get(o.OpportunityId).AccountId;
                                    Id proId = o.Product2Id;
                                    
                                    Integer currentCount = accToProductCountMap.containsKey(accId) ? accToProductCountMap.get(accId) : 0;
                                    System.debug(currentCount);
                                    
                                    if(accountMap.get(accId).No_Of_Product_Allowed__c != null && currentCount + 1 > accountMap.get(accId).No_Of_Product_Allowed__c) {
                                        o.addError('not allowed');
                                        continue;
                                    }
                                    accToProductCountMap.put(accId, currentCount + 1);
                                    
                                    if( accountMap.get(accId).Allowed_Family__c != null && productMap.get(proId).Family != null) {
                                        String allowedStringFromAccount = accountMap.get(accId).Allowed_Family__c;
                                        String allowedStringFromProduct = productMap.get(proId).Family;
                                        System.debug(allowedStringFromAccount);
                                        System.debug(allowedStringFromProduct);
                                        if(!check(allowedStringFromAccount, allowedStringFromProduct)) {
                                            o.addError('product family not match');
                                            continue;
                                        }
                                    }
                                    
                                    if(productMap.get(proId).Family == null) {
                                        o.addError('product family not present');
                                        continue;
                                    }
                                    
                                    if (String.isBlank(productMap.get(proId).ProductCode)) continue;
                                    
                                    if (!accToCodesSet.containsKey(accId)) {
                                        accToCodesSet.put(accId, new Set<String>());
                                    }
                                    
                                    accToCodesSet.get(accId).add(productMap.get(proId).ProductCode);           
                                }
                            }
                            
                            List<Account> accToUpdateLst = new List<Account>();
                            
                            for (Id accId : accToCodesSet.keySet()){
                                Set<String> codeSet = accToCodesSet.get(accId);
                                String productCodeString = '';
                                
                                if (codeSet != null) {
                                    for (String code : codeSet) {
                                        if (productCodeString == '') {
                                            productCodeString = code;
                                        } else {
                                            productCodeString = productCodeString + ';' + code;
                                        }
                                    }
                                }
                                System.debug(productCodeString);
                                
                                Account acc = new Account();
                                acc.Id = accId;
                                acc.Added_Product_Code__c = productCodeString;
                                
                                accToUpdateLst.add(acc);
                            }
                            
                            if (!accToUpdateLst.isEmpty()) {
                                update accToUpdateLst;
                            }
                        }
                    }
                }
            }
        }
    }
    
    public static boolean check(String allowedStringFromAccount, String allowedStringFromProduct ) {
        if(allowedStringFromAccount.contains(allowedStringFromProduct)) {
            return true;
        }
        return false;
    }
}