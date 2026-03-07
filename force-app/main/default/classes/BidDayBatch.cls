public class BidDayBatch implements Database.Batchable<SObject> {
    
    public Date td;
    public BidDayBatch(Date td) {
        this.td = td;
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id FROM User WHERE IsActive = true]);
    }
    
    public void execute(Database.BatchableContext bc, List<User> userList) {
        
        Date todayDate = Date.today();
        
        Datetime startTime = Datetime.newInstance(
            todayDate.year(),
            todayDate.month(),
            todayDate.day(),
            1, 0, 0
        );
        
        Datetime endTime = Datetime.newInstance(
            todayDate.year(),
            todayDate.month(),
            todayDate.day(),
            23, 59, 59
        );
        
        List<Bid_Day__c> bidDayList = new List<Bid_Day__c>();
        
        Set<Id> userIdSet = new Set<Id>();
        for(User u : userList) {
            if(!userIdSet.contains(u.Id)) {
                userIdSet.add(u.Id);
            }
        }
        
        Map<Id,Bid_Day__c> userIdToBidDay = new Map<Id, Bid_Day__c>();
        List<Bid_Day__c> bidDayLst = [SELECT Id, OwnerId FROM Bid_Day__c WHERE OwnerId IN :userIdSet AND Start_Date__c = :td];
        for(Bid_Day__c bd : bidDayLst) {
            if(!userIdToBidDay.containsKey(bd.OwnerId)) {
                userIdToBidDay.put(bd.OwnerId, bd);
            }
        }
        
        for(User u : userList) {
            if(!userIdToBidDay.containsKey(u.Id)) {
                bidDayList.add(
                    new Bid_Day__c(
                        Bid_Date__c = todayDate,
                        CheckIn__c = startTime,
                        CheckOut__c = endTime,
                        Start_Date__c = todayDate,
                        End_Date__c = todayDate,
                        Status__c = 'Not Started',
                        OwnerId = u.Id
                    )
                );
            }
        }
        
        if(!bidDayList.isEmpty()) insert bidDayList;
    }
    
    public void finish(Database.BatchableContext bc) {
        System.debug('OK');
    }
}