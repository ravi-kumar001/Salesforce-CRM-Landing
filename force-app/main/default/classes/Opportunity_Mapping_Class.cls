public class Opportunity_Mapping_Class {
    public static void proudctAdd(List<Opportunity> oppList) {
        List<Opportunity_Product_Mapping__mdt> metaData = [ SELECT Product_Name__c,Start_Date__c, End_Date__c, Type__c FROM Opportunity_Product_Mapping__mdt ];

        Map<Id, Set<String>> oppToProductNames = new Map<Id, Set<String>>();
        for (Opportunity o : oppList) {
            if(o.Id != null) {
                for (Opportunity_Product_Mapping__mdt meta : metaData) {
                    if ((meta.End_Date__c == o.CloseDate || meta.Start_Date__c == o.CloseDate || o.CloseDate > meta.Start_Date__c && o.CloseDate < meta.End_Date__c ) && meta.Type__c == o.Type && meta.Product_Name__c != null ) {
                        if (!oppToProductNames.containsKey(o.Id)) {
                            oppToProductNames.put(o.Id, new Set<String>());
                        }
                        oppToProductNames.get(o.Id).add(meta.Product_Name__c);
                    }
            	}
            }
        }
        if (oppToProductNames.isEmpty()) return;
        Set<String> allProductNames = new Set<String>();
        for (Set<String> names : oppToProductNames.values()) {
            for(String name : names) {
                allProductNames.add(name);
            }
        }
        Map<String, Id> productNameToId = new Map<String, Id>();
        for (Product2 p : [ SELECT Id, Name FROM Product2 WHERE Name IN :allProductNames ]) {
			   productNameToId.put(p.Name, p.Id);
        }
        Map<Id, PricebookEntry> productToPbe = new Map<Id, PricebookEntry>();
        for (PricebookEntry pbe : [ SELECT Id, Product2Id, UnitPrice FROM PricebookEntry WHERE Product2Id IN :productNameToId.values() ]) {
               productToPbe.put(pbe.Product2Id, pbe);
        }
        
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        for (Id oppId : oppToProductNames.keySet()) {
            for (String productName : oppToProductNames.get(oppId)) {
                Id productId = productNameToId.get(productName);
                if(productId == null) continue;
                PricebookEntry pbe = productToPbe.get(productId);
                if(pbe == null) continue;
                OpportunityLineItem oli = new OpportunityLineItem();
                oli.OpportunityId = oppId;
                oli.PricebookEntryId = pbe.Id;
                oli.Quantity = 1;
                oli.UnitPrice = pbe.UnitPrice;
                oliList.add(oli);
            }
        }
        if (!oliList.isEmpty()) {
            insert oliList;
        }
    }
    
    public static void proudctAdd1(List<Opportunity> oppList) {
        List<Opportunity_Product_Mapping__mdt> metaData = [ SELECT Product_Name__c,Start_Date__c, Active__c, End_Date__c, Type__c FROM Opportunity_Product_Mapping__mdt ];

        Map<Id, Set<String>> oppToProductNames = new Map<Id, Set<String>>();
        for (Opportunity o : oppList) {
            if(o.Id != null && o.AddLineItem__c == true) {
                for (Opportunity_Product_Mapping__mdt meta : metaData) {
                    if ((o.CloseDate >= meta.Start_Date__c && o.CloseDate <= meta.End_Date__c) && meta.Active__c == false && meta.Type__c == o.Type && meta.Product_Name__c != null) {
                        if (!oppToProductNames.containsKey(o.Id)) {
                            oppToProductNames.put(o.Id, new Set<String>());
                        }
                        oppToProductNames.get(o.Id).add(meta.Product_Name__c);
                    }
            	}
            }
        }
        if (oppToProductNames.isEmpty()) return;
        Set<String> allProductNames = new Set<String>();
        for (Set<String> names : oppToProductNames.values()) {
            for(String name : names) {
                allProductNames.add(name);
            }
        }
        Map<String, Id> productNameToId = new Map<String, Id>();
        for (Product2 p : [ SELECT Id, Name FROM Product2 WHERE Name IN :allProductNames ]) {
			   productNameToId.put(p.Name, p.Id);
        }
        Map<Id, PricebookEntry> productToPbe = new Map<Id, PricebookEntry>();
        for (PricebookEntry pbe : [ SELECT Id, Product2Id, UnitPrice FROM PricebookEntry  WHERE Product2Id IN :productNameToId.values() AND IsActive = true ]) {
            productToPbe.put(pbe.Product2Id, pbe);
        }
        
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        for (Id oppId : oppToProductNames.keySet()) {
            for (String productName : oppToProductNames.get(oppId)) {
                Id productId = productNameToId.get(productName);
                if(productId == null) continue;
                PricebookEntry pbe = productToPbe.get(productId);
                if(pbe == null) continue;
                OpportunityLineItem oli = new OpportunityLineItem();
                oli.OpportunityId = oppId;
                oli.PricebookEntryId = pbe.Id;
                oli.Quantity = 1;
                oli.UnitPrice = pbe.UnitPrice;
                oliList.add(oli);
            }
        }
        if (!oliList.isEmpty()) {
            insert oliList;
        }
    }
}