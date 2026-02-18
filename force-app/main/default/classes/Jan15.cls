public class Jan15 {

    public String name {get; set;}
    public List<Account> wrapAccountList {get;set;}
    public Id selectedId {get; set;}

    public List<ContactWrap> contactWrap {get; set;}

    public Boolean showEmailFrame {get;set;}
    public String selectedContactIds {get;set;}

   
    public Jan15() {
        wrapAccountList = new List<Account>();
        contactWrap = new List<ContactWrap>();
        showEmailFrame = false;
    }
    
    public void closeEmailFrame () {
        showEmailFrame = false;
        Jan15 j = new Jan15();
    }

    public void searchAccountList() {
        wrapAccountList = [ SELECT Id, Name, Phone FROM Account WHERE Name LIKE :('%' + name + '%') ];
    }

    public void loadContacts() {

        contactWrap.clear();
        System.debug('Selected Id' + selectedId);

        List<Contact> cons = [ SELECT Id, FirstName, LastName, Phone, Email FROM Contact WHERE AccountId = :selectedId ];

        for(Contact c : cons){
            contactWrap.add(new ContactWrap(c));
        }
    }

    public void openEmail(){

        List<String> ids = new List<String>();

        for(ContactWrap c : contactWrap){
            if(c.isSelected){
                ids.add(c.con.Id);
            }
        }

        selectedContactIds = String.join(ids, ',');
        showEmailFrame = true;
    }

    public class ContactWrap{
        public Contact con {get;set;}
        public Boolean isSelected {get;set;}

        public ContactWrap(Contact c){
            con = c;
            isSelected = false;
        }
    }
}