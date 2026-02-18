@IsTest
public class Feb13Assign1HandlerTest {
    @IsTest
    static void testMonthlyAndQuarterlyAndBulk() {
        
        Id stdPriceBookId = System.Test.getStandardPricebookId();
        
        Product2 monthlyProd = new Product2(
            Name = 'Montly Product',
            IsActive = true,
            MCQ_Type__c = 'Montly',
            MCQ_Parent_Code__c = 'P002'
        );
        insert monthlyProd;
        
        Product2 quarterlyProd = new Product2(
            Name = 'Quaterly Product',
            IsActive = true,
            MCQ_Type__c = 'Quaterly',
            MCQ_Parent_Code__c = 'P003'
        );
        insert quarterlyProd;
        
        Product2 childMonthly = new Product2(
            Name = 'Child Montly',
            IsActive = true,
            MCQ_Parent_Code__c = 'P002'
        );
        insert childMonthly;
        
        Product2 childQuarterly = new Product2(
            Name = 'Child Quaterly',
            IsActive = true,
            MCQ_Parent_Code__c = 'P003'
        );
        insert childQuarterly;
        
        insert new List<PricebookEntry>{
            new PricebookEntry(
                Pricebook2Id = stdPriceBookId,
                Product2Id = monthlyProd.Id,
                UnitPrice = 200,
                IsActive = true
            ),
                new PricebookEntry(
                    Pricebook2Id = stdPriceBookId,
                    Product2Id = quarterlyProd.Id,
                    UnitPrice = 300,
                    IsActive = true
                ),
                new PricebookEntry(
                    Pricebook2Id = stdPriceBookId,
                    Product2Id = childMonthly.Id,
                    UnitPrice = 0,
                    IsActive = true
                ),
                new PricebookEntry(
                    Pricebook2Id = stdPriceBookId,
                    Product2Id = childQuarterly.Id,
                    UnitPrice = 0,
                    IsActive = true
                )
                };
                    
                    Opportunity opp1 = new Opportunity(
                        Name = 'Montly Opp',
                        StageName = 'Prospecting',
                        CloseDate = Date.today(),
                        Pricebook2Id = stdPriceBookId,
                        Active__c = false,
                        How_Many_Months__c = 6
                    );
        
        Opportunity opp2 = new Opportunity(
            Name = 'Quaterly Opp',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            Pricebook2Id = stdPriceBookId,
            Active__c = false,
            How_Many_Months__c = 6
        );
        
        insert new List<Opportunity>{opp1, opp2};
            
            Map<Id, Id> pbeMap = new Map<Id, Id>();
        for(PricebookEntry pbe : [
            SELECT Id, Product2Id FROM PricebookEntry
        ]){
            pbeMap.put(pbe.Product2Id, pbe.Id);
        }
        
        insert new List<OpportunityLineItem>{
            new OpportunityLineItem(
                OpportunityId = opp1.Id,
                PricebookEntryId = pbeMap.get(monthlyProd.Id),
                Quantity = 1,
                UnitPrice = 200
            ),
                new OpportunityLineItem(
                    OpportunityId = opp2.Id,
                    PricebookEntryId = pbeMap.get(quarterlyProd.Id),
                    Quantity = 1,
                    UnitPrice = 300
                )
                };
                    
                    List<Opportunity> toUpdate = [SELECT Id, Active__c FROM Opportunity  WHERE Id IN :new List<Id>{opp1.Id, opp2.Id}];
        
        System.Test.startTest();
        
        for(Opportunity o : toUpdate){
            o.Active__c = true;
        }
        update toUpdate;
        
        System.Test.stopTest();
        
        List<MCQ_Contract__c> contracts = [SELECT Id FROM MCQ_Contract__c WHERE Opportunity__c IN :toUpdate];
        System.assert(contracts.size() > 0);
        
        List<Opportunity> generatedOpps = [SELECT Id FROM Opportunity WHERE MCQ_Contract__c != null];
        System.assert(generatedOpps.size() > 0);
        
        List<OpportunityLineItem> generatedOLI = [
            SELECT Id FROM OpportunityLineItem 
            WHERE OpportunityId IN :generatedOpps
        ];
        System.assert(generatedOLI.size() > 0);
    }
    
    @IsTest
    static void testOneTimeBranchExplicit() {
        
        Id stdPriceBookId = System.Test.getStandardPricebookId();
        
        Product2 oneTimeProd = new Product2(
            Name = 'Explicit OneTime',
            IsActive = true,
            MCQ_Type__c = 'OneTime',
            MCQ_Parent_Code__c = 'OT001'
        );
        insert oneTimeProd;
        
        Product2 childProd = new Product2(
            Name = 'Explicit Child',
            IsActive = true,
            MCQ_Parent_Code__c = 'OT001'
        );
        insert childProd;
        
        insert new List<PricebookEntry>{
            new PricebookEntry(
                Pricebook2Id = stdPriceBookId,
                Product2Id = oneTimeProd.Id,
                UnitPrice = 100,
                IsActive = true
            ),
                new PricebookEntry(
                    Pricebook2Id = stdPriceBookId,
                    Product2Id = childProd.Id,
                    UnitPrice = 0,
                    IsActive = true
                )
                };
                    
                    Opportunity opp = new Opportunity(
                        Name = 'Explicit OneTime Opp',
                        StageName = 'Prospecting',
                        CloseDate = Date.today(),
                        Pricebook2Id = stdPriceBookId,
                        Active__c = false,
                        How_Many_Months__c = 3
                    );
        insert opp;
        
        Id pbeId = [SELECT Id FROM PricebookEntry WHERE Product2Id = :oneTimeProd.Id LIMIT 1].Id;
        
        insert new OpportunityLineItem(
            OpportunityId = opp.Id,
            PricebookEntryId = pbeId,
            Quantity = 1,
            UnitPrice = 100
        );
        
        System.Test.startTest();
        opp.Active__c = true;
        update opp;
        System.Test.stopTest();
        
        List<Opportunity> createdOpps = [SELECT Id, Name FROM Opportunity WHERE Name LIKE 'Explicit OneTime Opp - OneTime%'];
        
        System.assert(createdOpps.size() > 0, 'OneTime branch should execute');
    }
}