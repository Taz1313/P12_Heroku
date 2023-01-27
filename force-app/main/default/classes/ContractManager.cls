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
    global static ID updateContract() {
        RestRequest request = RestContext.request;
        String contractId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Contract thisContract = [SELECT Id FROM Contract WHERE Id = :contractId];
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        for(String fieldName : params.keySet()) {
            if(fieldName == 'startDate') {
                thisContract.put(fieldName, Date.valueOf((String)params.get(fieldName)));
            } else if(fieldName == 'contractTerm') {
                thisContract.put(fieldName, Integer.valueOf((String)params.get(fieldName)));
            } else {
                thisContract.put(fieldName, params.get(fieldName));
            }            
        }
        update thisContract;
        return thisContract.Id;
    }    
}