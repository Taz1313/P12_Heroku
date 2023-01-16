@RestResource(urlMapping='/Contacts/*')
global with sharing class ContactManager {
    
    @HttpPost
    global static ID createContact(String firstName, String lastName, String email) {
        List<Contact> existingContacts = [SELECT Id FROM Contact WHERE Email =:email];
        if (!existingContacts.isEmpty()) {
            Contact existingContact = existingContacts[0];
            existingContact.FirstName = firstName;
            existingContact.LastName = lastName;
            update existingContact;
            return existingContact.Id;
        } else {
            Contact newContact = new Contact(
                FirstName=firstName,
                LastName=lastName,
                Email=email);
            insert newContact;
            return newContact.Id;
        }
    }

    @HttpDelete
    global static void desactivateContact() {
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contactId];
        if (thisContact == null) {
            RestContext.response.responseBody = Blob.valueOf('Contact not found.');
            RestContext.response.statusCode = 404;
        } else {
            thisContact.IsActive__c = false;
            update thisContact;
        }
    }

    @HttpPatch
    global static ID updateContact(Contact updatedContact) {
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = :updatedContact.Id];
        if (thisContact == null) {
            RestContext.response.responseBody = Blob.valueOf('Contact not found.');
            RestContext.response.statusCode = 404;
            return null;
        } else {
            thisContact.FirstName = updatedContact.FirstName;
            thisContact.LastName = updatedContact.LastName;
            thisContact.Email = updatedContact.Email;
            // Ajout d'autres champs au besoin
            update thisContact;
            return thisContact.Id;
        }
    }
}