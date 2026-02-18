public class AccountWrapperController {
    public List<AccountWrapper> wrapAccountList {get;set;}
    
    
    public AccountWrapperController () {
        loadAllList();
    }
    
    public void loadAllList() {
        wrapAccountList = new List<AccountWrapper> ();
        for(Account a : [SELECT Name, Phone, Industry FROM Account]) {
            wrapAccountList.add(new AccountWrapper(a));
        }
    }
    
    public class AccountWrapper {
        public Account acc {get; set;}
        public Boolean isSelected {get; set;}
        
        public AccountWrapper (Account a) {
            acc = a;
            isSelected = false;
        }
    }
}