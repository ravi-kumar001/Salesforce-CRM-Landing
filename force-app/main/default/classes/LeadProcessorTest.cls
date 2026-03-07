@isTest
private class LeadProcessorTest {
    @isTest
    static void testLeadBatchUpdate() {
        List<Lead> leads = new List<Lead>();
        for (Integer i = 0; i < 200; i++) {
            leads.add(new Lead(LastName = 'Test ' + i, Company = 'Test Company'));
        }
        insert leads;

        System.Test.startTest();
        LeadProcessor lp = new LeadProcessor();
        Id batchId = Database.executeBatch(lp);
        System.Test.stopTest();

        List<Lead> updatedLeads = [SELECT Id FROM Lead WHERE LeadSource = 'Dreamforce'];
        System.assertEquals(200, updatedLeads.size(), 'All 200 leads should have LeadSource set to Dreamforce');
    }
}