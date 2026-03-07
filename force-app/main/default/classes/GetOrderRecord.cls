public with sharing class GetOrderRecord {
    @AuraEnabled(cacheable=true)
    public static List<Order> getOrderRecord() {
        return [SELECT Id, OrderNumber, Account.Name, TotalAmount, EffectiveDate, Status, Contract.ContractNumber FROM Order];
    }
}