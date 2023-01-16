@isTest
private class ContractManagerTest {

    @isTest
    static void createContractTest() {
        Account acc = new Account();
        acc.Name ='Test';
        insert acc;

        Id resultId = ContractManager.createContract(acc.Id, 'Test1', Date.today(), 12, 'Draft');

        Contract newContract = [SELECT Name, StartDate, ContractTerm, Status FROM Contract WHERE ID =:resultId];

        System.assertEquals(newContract.Name, 'Test1');
        System.assertEquals(newContract.StartDate, Date.today());
        System.assertEquals(newContract.ContractTerm, 12);
        System.assertEquals(newContract.Status, 'Draft');
    }

    @isTest
    static void updateContractTest() {
        Account acc = new Account();
        acc.Name ='Test';
        insert acc;

        Id resultId = ContractManager.createContract(acc.Id, 'Test1', Date.today(), 12, 'Draft');

        ContractManager.updateContract(resultId, 'Test 2', Date.today(), 6, 'Activated');

        Contract updatedContract = [SELECT Name, StartDate, ContractTerm, Status FROM Contract WHERE ID =:resultId];

        System.assertEquals(updatedContract.Name, 'Test 2');
        System.assertEquals(updatedContract.StartDate,  Date.today());
        System.assertEquals(updatedContract.ContractTerm, 6);
        System.assertEquals(updatedContract.Status, 'Activated');
    }
}