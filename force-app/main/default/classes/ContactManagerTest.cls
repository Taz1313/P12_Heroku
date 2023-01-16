@isTest
private class ContactManagerTest {
    
    @testSetup
    static void createTestContact() {
        ContactManager.createContact('Legarant', 'Contact', 'test@test.com');
    }

    @isTest
    static void createContactWithExistingEmailTest() {
        Contact testContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Email = 'test@test.com'];

        System.assertEquals(testContact.FirstName, 'Legarant');
        System.assertEquals(testContact.LastName, 'Contact');

        testContact.FirstName = 'Nouveau Test';
        testContact.LastName = 'OC';

        Id resultId = ContactManager.createContact(testContact.FirstName, testContact.LastName, testContact.Email);

        Contact updatedContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Email =:testContact.Email];

        System.assertEquals(updatedContact.FirstName, 'Nouveau Test');
        System.assertEquals(updatedContact.LastName, 'OC');
        System.assertEquals(updatedContact.Email, 'test@test.com');
    }

    @isTest
    static void updateContactTest(){
        Contact testContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Email = 'test@test.com'];

        testContact.FirstName = 'Test';
        testContact.LastName = 'OC2023';
        testContact.Email = 'OC@OC.COM';

        Id resultId = ContactManager.updateContact(testContact);

        Contact updatedContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Email =:testContact.Email];

        System.assertEquals(updatedContact.FirstName, 'Test');
        System.assertEquals(updatedContact.LastName, 'OC2023');
        System.assertEquals(updatedContact.Email.toupperCase(), 'OC@OC.COM');
    }

    @isTest
    static void desactivateContactTest() {
        Contact testContact = [SELECT Id FROM Contact WHERE Email = 'test@test.com'];
        RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/services/apexrest/Contacts/' + testContact.Id;
        RestContext.request.httpMethod = 'DELETE';
        RestContext.response = new RestResponse();

        ContactManager.desactivateContact();

        testContact = [SELECT Id, IsActive__c FROM Contact WHERE Id = :testContact.Id];
        System.assertEquals(false, testContact.IsActive__c);
    }   
}
