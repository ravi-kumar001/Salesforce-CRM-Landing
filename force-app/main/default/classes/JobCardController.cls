public with sharing class JobCardController {

    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> searchProduct(String chassisNo){

        return [SELECT Id, Quantity, Opportunity.Name, Chasis_Number__c, PricebookEntry.Product2.Name, PricebookEntry.Product2.ProductCode FROM OpportunityLineItem WHERE Chasis_Number__c LIKE :('%' + chassisNo + '%')];
    }

    @AuraEnabled
    public static Id createJobCard(String chassisNo,String tractorModel,String runningHours,String hourMeter, String additionalRepair,Decimal estimatedAmount,Datetime deliveryDateTime){
        Job_Card__c job = new Job_Card__c();

        job.Chassis_Number__c = chassisNo;
        job.Tractor_Model__c = tractorModel;

        String[] strTimeSplit = runningHours.split(':');

        Time changeRunningHours = Time.newInstance(
            Integer.valueOf(strTimeSplit[0]),
            Integer.valueOf(strTimeSplit[1]),
            0,
            0 
        );
        job.Tractor_Running_Hours__c = changeRunningHours;

        String[] hourTimeSplit = hourMeter.split(':');

        Time hourMeterWorkingHours = Time.newInstance(
            Integer.valueOf(hourTimeSplit[0]),
            Integer.valueOf(hourTimeSplit[1]),
            0,
            0 
        );
        job.Hour_Meter_Working__c = hourMeterWorkingHours;

        job.Additional_Repair__c = additionalRepair;
        job.Service_Estimate_Amount__c = estimatedAmount;
        job.Estimated_Delivery_Date__c = deliveryDateTime;

        insert job;

        return job.Id;
    }
}