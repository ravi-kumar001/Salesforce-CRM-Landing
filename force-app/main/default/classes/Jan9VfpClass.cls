public class Jan9VfpClass {
    public Opportunity oppObj{get; set;}
    public String oppId{get; set;}
    public Integer subTotal { get; set; }
    public Integer discountAmount { get; set; }
    public Integer netAmount { get; set; }
    public Integer taxAmount { get; set; }
    public Integer finalTotal { get; set; }
    
    public Jan9VfpClass() {
        oppId = ApexPages.currentPage().getParameters().get('id');
        oppObj = [SELECT Id,Name,CloseDate,Amount,CreatedDate,OrderNumber__c,
                           Account.Name,Account.Phone,Account.Website,Account.Email__c,Account.BillingStreet,Account.BillingCity,Account.BillingState,Account.BillingPostalCode,Account.BillingCountry,
                           Owner.Name,Owner.Email,Owner.Phone,Owner.CompanyName, (SELECT Quantity,UnitPrice,TotalPrice, PricebookEntry.Product2.Name FROM OpportunityLineItems) FROM Opportunity WHERE Id = :oppId
        		 ];
        calculateTotalData();
    }
    
    private void calculateTotalData() {
        subTotal = (Integer)oppObj.Amount;
        Integer discountPercent = 5;
        Integer shipping = 200;
        Integer taxRate = 12;
        discountAmount = subTotal * (discountPercent / 100);
        netAmount = subTotal - discountAmount + shipping;
        taxAmount = netAmount * ( taxRate / 100);
        finalTotal = netAmount + taxAmount;
    }

}