@RestResource(urlMapping='/Contracts/*')
global with sharing class ContractManager {

    @HttpPost
    global static ID createContract(Id accountId, String name, Date startDate, Integer contractTerm, String status) {
        Contract newContract = new Contract(
            AccountId = accountId,
            Name = name,
            StartDate = startDate,
            ContractTerm = contractTerm,
            Status = status
        );
        insert newContract;
        return newContract.Id;
    }

    @HttpPatch
    global static void updateContract(Id accountId, String name, Date startDate, Integer contractTerm, String status) {
        Contract contract = [SELECT Id FROM Contract WHERE Id = :accountId];
        if (contract == null) {
            RestContext.response.statusCode = 404;
            RestContext.response.responseBody = Blob.valueOf('Contract not found with ID: ' + accountId);
            return;
        }
        contract.Name = name;
        contract.StartDate = startDate;
        contract.ContractTerm = contractTerm;
        contract.Status = status;
        update contract;
    }
}