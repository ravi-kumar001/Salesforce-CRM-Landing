public class Jan21 {
    public void Jan21Assign7(List<Case> cases) {
        for (Case c : cases) {
            if (c.Status == 'Close' && c.Status != null) {
                c.CustomCloseDate__c = Date.today();
            }
   		 }
    }
    
    public void Jan21Assign1(List<Account> account) {
        for(Account a : account) {
            if(String.isBlank(a.Industry)) {
           		 a.addError('Industry Filled Can Not be Empty');
        	}
        }
    }
}