public class Jan17 {

    public Id oppId { get; set; }
    public List<OLIWrapper> oliList { get; set; }
    public OpportunityLineItem oppLineItem {get;set;}
    public Opportunity oppObj {get; set;}
    public Id rowId {get; set;}

    public Jan17(ApexPages.StandardController stdCtrl) {
        oppLineItem = new OpportunityLineItem();
        oppId = stdCtrl.getId();
        oliList = new List<OLIWrapper>();
        
        oppObj = [ SELECT Id, Amount, TotalOpportunityQuantity, Pricebook2Id FROM Opportunity WHERE Id = :oppId  ];

        for (OpportunityLineItem oli : [ SELECT Id, Quantity, UnitPrice, TotalPrice, Product2Id, PricebookEntry.Product2.Name, 
                                        PricebookEntryId FROM OpportunityLineItem WHERE OpportunityId = :oppId ]) {
            oliList.add(new OLIWrapper(oli));
        }
    }

    
    public void addRow() {
        PricebookEntry pbe = [ SELECT Id, UnitPrice, Product2Id, Pricebook2Id FROM PricebookEntry
                              WHERE Product2Id = :oppLineItem.Product2Id AND Pricebook2Id = :oppObj.Pricebook2Id ];
        
        OpportunityLineItem o = new OpportunityLineItem();
        o.OpportunityId = oppId;
        o.Product2Id = pbe.product2Id;
        o.PricebookEntryId = pbe.Id;
        o.Quantity = oppLineItem.quantity;
        o.UnitPrice = oppLineItem.UnitPrice;
        
        insert o;
        
        OpportunityLineItem t = [ SELECT Id, Quantity, UnitPrice, TotalPrice, Product2Id, PricebookEntry.Product2.Name, 
                                        PricebookEntryId FROM OpportunityLineItem WHERE Id = :o.Id ];
        oliList.add(new OLIWrapper(t));
        
        oppObj = [ SELECT Id, Amount, TotalOpportunityQuantity, Pricebook2Id FROM Opportunity WHERE Id = :oppId  ];
        
        oppLineItem = new OpportunityLineItem();
        
    }

    public void editRow() {
        System.debug('id' + rowId);
        for (OLIWrapper w : oliList) {
            if (w.oli.Id == rowId) {
                w.isEdit = true;
            }
        }
    }
    
    public void deleteRow() {
        System.debug('Your Id is ' + rowId);
        for(Integer i = 0; i < oliList.size(); i++) {
            if(oliList[i].oli.Id == rowId) {
               delete oliList[i].oli;
               oliList.remove(i);
               rowId = null;
               break;
            }
        }        
    }
    
    
    public void cancelRow() {
        for(OLIWrapper w : oliList) {
            if(w.oli.Id == rowId) {
                w.isEdit = false;
                break;
            }
        }
    }

    public void save() {
            List<OpportunityLineItem> updateList = new List<OpportunityLineItem>();
            for (OLIWrapper w : oliList) {
                if(w.isEdit == true) {
                    updateList.add(w.oli);
                    w.isEdit = false;
                }
            }
           if(!updateList.isEmpty()) {
            update updateList;
        }
        
        oppLineItem = new OpportunityLineItem();
  		oppObj = [Select Id, Name, Amount, TotalOpportunityQuantity From Opportunity where Id = :oppId LIMIT 1];
        }


    public class OLIWrapper {
        public OpportunityLineItem oli { get; set; }
        public Boolean isEdit { get; set; }

        public OLIWrapper(OpportunityLineItem o) {
            oli = o;
            isEdit = false;
        }
    }
}