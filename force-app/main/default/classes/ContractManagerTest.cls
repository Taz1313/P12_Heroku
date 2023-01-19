@isTest
private class ContractManagerTest {
    
    // Teste de la création d'un contrat
    @isTest
    static void createContractTest() {
        Account acc = new Account();
        acc.Name ='Test';
        insert acc;

        Id resultId = ContractManager.createContract(acc.Id, Date.today(), 12, 'Draft');

        Contract newContract = [SELECT StartDate, ContractTerm, Status FROM Contract WHERE ID =:resultId];

        System.assertEquals(newContract.StartDate, Date.today());
        System.assertEquals(newContract.ContractTerm, 12);
        System.assertEquals(newContract.Status, 'Draft');
    }

    // Teste de la mise à jour d'un contrat
    @isTest
    static void updateContractTest() {
        Account acc = new Account();
        acc.Name ='Test';
        insert acc;

        Id resultId = ContractManager.createContract(acc.Id, Date.today(), 12, 'Draft');

        ContractManager.updateContract(resultId, Date.today(), 6, 'Activated');

        Contract updatedContract = [SELECT StartDate, ContractTerm, Status FROM Contract WHERE ID =:resultId];

        System.assertEquals(updatedContract.StartDate,  Date.today());
        System.assertEquals(updatedContract.ContractTerm, 6);
        System.assertEquals(updatedContract.Status, 'Activated');
    }
}
