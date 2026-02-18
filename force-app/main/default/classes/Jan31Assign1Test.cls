@IsTest
private class Jan31Assign1Test {
    
    @IsTest
    static void testInsertValidDomain() {
        
        Contact validContact = new Contact(
            FirstName = 'Test',
            LastName  = 'User',
            Email     = 'testuser@gmail.com'
        );
        
        System.Test.startTest();
        insert validContact;
        System.Test.stopTest();
        
        System.assertNotEquals(null, validContact.Id);
    }
    
    @IsTest
    static void testInsertInvalidDomain() {
        
        Boolean exceptionThrown = false;
        
        try {
            Contact invalidContact = new Contact(
                FirstName = 'Invalid',
                LastName  = 'User',
                Email     = 'test@gm.com'
            );
            
            System.Test.startTest();
            insert invalidContact;
            System.Test.stopTest();
            
            System.assert(false, 'DML Exception should have been thrown');
            
        } catch (DmlException e) {
            exceptionThrown = true;
            System.assert(e.getDmlMessage(0).contains('Domain should'),'Incorrect error message');
        }
        
        System.assert(exceptionThrown, 'Exception was not thrown');
    }
}