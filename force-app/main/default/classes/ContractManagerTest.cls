@isTest
private class ContractManagerTest {
    
    // Teste de la création d'un contrat
    @isTest
    static void createContractTest() {
        Account acc = new Account();
        acc.Name ='Test';
        insert acc;  
        Id accountId = acc.Id;     
        Id contractId = ContractManager.createContract(accountId, Date.today(), 12, 'Draft');       

        Contract testContract = [SELECT StartDate, ContractTerm, Status FROM Contract WHERE Id =:contractId];

        System.assertEquals(testContract.StartDate, Date.today());
        System.assertEquals(testContract.ContractTerm, 12);
        System.assertEquals(testContract.Status, 'Draft');
    }

    // Teste de la mise à jour d'un contrat
    @isTest
    static void updateContractTest() {
        Account acc = new Account();
        acc.Name = 'Test';
        insert acc;  
        Id accountId = acc.Id;     
        
        Contract newContract = new Contract(
            AccountId = accountId,
            Status = 'Draft',
            StartDate = Date.today(),
            ContractTerm = 12);
        insert newContract;
        
        Id contractId = newContract.Id;
        
        Contract testContract = [SELECT Id FROM Contract WHERE Id =:contractId];

        RestContext.request = new RestRequest();
        // Simule une requête PATCH pour la méthode de mise à jour
        RestContext.request.requestURI = '/services/apexrest/Contracts/' + testContract.Id;
        RestContext.request.httpMethod = 'PATCH';
        RestContext.request.requestbody = Blob.valueOf('{"startDate": "2023-12-12","contractTerm": "16","status": "Activated"}');
        RestContext.response = new RestResponse();

        ContractManager.updateContract();

        Contract updatedContract = [SELECT StartDate, ContractTerm, Status FROM Contract WHERE ID =:testContract.Id];
        System.assertEquals(updatedContract.StartDate,  Date.valueOf('2023-12-12'));
        System.assertEquals(updatedContract.ContractTerm, 16);
        System.assertEquals(updatedContract.Status, 'Activated');
    }
}