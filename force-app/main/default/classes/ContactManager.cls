@RestResource(urlMapping='/Contacts/*')
global with sharing class ContactManager {

    // Méthode pour créer un contact
    @HttpPost
    global static ID createContact(String firstName, String lastName, String email) {
        // Vérifie si un contact existe déjà avec cette adresse email
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

    // Méthode pour désactiver un contact
    @HttpDelete
    global static ID desactivateContact() {
        RestRequest request = RestContext.request;
        // Récupère l'ID du contact à partir de l'URL
        String contactId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contactId];
        thisContact.IsActive__c = false;
        update thisContact;
        return thisContact.Id;        
    }

    // Méthode pour mettre à jour un contact
    @HttpPatch
    global static ID updateContact(Id accountId, String firstName, String lastName, String email) {
        Contact contact = [SELECT Id FROM Contact WHERE Id = :accountId];
        contact.firstName = firstName;
        contact.lastName = lastName;
        contact.email = email;
        update contact;
        return contact.Id;
    }    
}
