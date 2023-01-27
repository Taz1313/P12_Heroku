@isTest
private class ContactManagerTest {

    // Crée un contact de test avec la méthode createContact()
    @testSetup
    static void createTestContact() {
        ContactManager.createContact('Legarant', 'Contact', 'test@test.com');
    }

    // Teste de la création d'un contact avec une adresse email existante
    @isTest
    static void createContactWithExistingEmailTest() {
        Contact testContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Email = 'test@test.com'];

        ContactManager.createContact('Nouveau Test', 'OC', testContact.Email);

        Contact updatedContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Email =:testContact.Email];

        System.assertEquals(updatedContact.FirstName, 'Nouveau Test');
        System.assertEquals(updatedContact.LastName, 'OC');
        System.assertEquals(updatedContact.Email, 'test@test.com');
    }

    // Teste de la désactivation d'un contact
    @isTest
    static void desactivateContactTest() {
        Contact testContact = [SELECT Id FROM Contact WHERE Email = 'test@test.com'];
        RestContext.request = new RestRequest();
        // Simule une requête DELETE pour la méthode de désactivation
        RestContext.request.requestURI = '/services/apexrest/Contacts/' + testContact.Id;
        RestContext.request.httpMethod = 'DELETE';
        RestContext.response = new RestResponse();

        ContactManager.desactivateContact();

        testContact = [SELECT Id, IsActive__c FROM Contact WHERE Id = :testContact.Id];
        System.assertEquals(false, testContact.IsActive__c);
    }

    // Teste de la mise à jour d'un contact
    @isTest
    static void updateContactTest() {
        Contact testContact = [SELECT Id FROM Contact WHERE Email = 'test@test.com'];
        RestContext.request = new RestRequest();
        // Simule une requête PATCH pour la méthode de mise à jour
        RestContext.request.requestURI = '/services/apexrest/Contacts/' + testContact.Id;
        RestContext.request.httpMethod = 'PATCH';
        RestContext.request.requestbody = Blob.valueOf('{"FirstName":"NewTest","LastName":"TestNew","Email":"newtest@newtest.com"}');
        RestContext.response = new RestResponse();

        ContactManager.updateContact();
        Contact updatedContact = [SELECT Id, FirstName, LastName, Email FROM Contact WHERE Id = :testContact.Id];
        System.assertEquals(updatedContact.FirstName, 'NewTest');
        System.assertEquals(updatedContact.LastName, 'TestNew');
        System.assertEquals(updatedContact.Email, 'newtest@newtest.com');
    }
}
