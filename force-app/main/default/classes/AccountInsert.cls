@IsTest
public class AccountInsert {
    public static testmethod void testinsert() {
        Account a = new Account(Name = 'Ravi Kumar', Industry = 'Banking');
        a.Name = 'Mr.' + a.Name;
        insert a;
    }
}