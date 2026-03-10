public with sharing class JobCardController {

    @AuraEnabled(cacheable=true)
    public static List<OpportunityLineItem> searchProduct(String chassisNo){

        return [SELECT Id, Quantity, Opportunity.Name, Chasis_Number__c, PricebookEntry.Product2.Name, PricebookEntry.Product2.ProductCode FROM OpportunityLineItem WHERE Chasis_Number__c LIKE :('%' + chassisNo + '%')];
    }

    @AuraEnabled
    public static Id createJobCard(
        String chassisNo,
        String tractorModel,
        Integer runningHours,
        String hourMeter,
        String hourMeterImage,
        String chassisImage,
        String additionalRepair,
        Decimal estimatedAmount,
        Datetime deliveryDateTime
    ){

        Job_Card__c job = new Job_Card__c();

        job.Chassis_Number__c = chassisNo;
        job.Tractor_Model__c = tractorModel;
        job.Tractor_Running_Hours__c = runningHours;
        job.Hour_Meter_Working__c = (hourMeter != null && hourMeter.toUpperCase() == 'YES');

        job.Additional_Repair__c = additionalRepair;
        job.Service_Estimate_Amount__c = estimatedAmount;
        job.Estimated_Delivery_Date__c = deliveryDateTime;

        insert job;

        List<ContentVersion> files = new List<ContentVersion>();

        if(hourMeterImage != null){
            files.add(new ContentVersion(
                Title = 'Hour Meter Image',
                PathOnClient = 'HourMeter.jpg',
                VersionData = EncodingUtil.base64Decode(hourMeterImage),
                FirstPublishLocationId = job.Id
            ));
        }

        if(chassisImage != null){
            files.add(new ContentVersion(
                Title = 'Chassis Image',
                PathOnClient = 'Chassis.jpg',
                VersionData = EncodingUtil.base64Decode(chassisImage),
                FirstPublishLocationId = job.Id
            ));
        }

        if(!files.isEmpty()){
            insert files;
        }

        return job.Id;
    }
}