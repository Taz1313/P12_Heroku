@RestResource(urlMapping='/Contracts/*')
global with sharing class ContractManager {
    
    // Méthode pour créer un contrat
    @HttpPost
    global static ID createContract(Id accountId, Date startDate, Integer contractTerm, String status) {
        Contract newContract = new Contract(
            AccountId = accountId,
            StartDate = startDate,
            ContractTerm = contractTerm,
            Status = status
        );
        insert newContract;
        return newContract.Id;
    }

    // Méthode pour mettre à jour un contrat
    @HttpPatch
    global static ID updateContract(Id contractId, Date startDate, Integer contractTerm, String status) {
        Contract contract = [SELECT Id FROM Contract WHERE Id = :contractId];
        contract.StartDate = startDate;
        contract.ContractTerm = contractTerm;
        contract.Status = status;
        update contract;
        return contract.Id;
    }
}
