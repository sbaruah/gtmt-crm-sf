/**
 * @author Samarjit Baruah
 * @date   09/01/2021
 * @description AccountTriggerHandlerHelper Class is used as helper class for AccountTriggerHandler.
 * Used it as qualifier and entry methods for service classes. Keep the methods very light.
 */
@SuppressWarnings('PMD.ApexCRUDViolation')
public with sharing class AccountTriggerHandlerHelper { 
  /**
     * This method will create merchant cluster for Ultimate Parent accounts if it doesn't exist.
     * @author  Samarjit Baruah
     * @param Map of account Ids and Account records
     * @date 09/01/2021
     * @throws Built-in DmlException, ListException, SObjectException
     * @return void
     */
    public static void createMerchantCluster(Map<Id, Account> newAccountMap) {
        Map<Id, Account> accountWOMCMap = new Map<Id, Account>();
        for (Account newAcc : newAccountMap.values()) {
            if (
                newAcc.SBS_Account_Type__c == 'Ultimate Parent' &&
                newAcc.Merchant_Cluster__c == null &&
                accountWOMCMap.get(newAcc.Id) == null
            ) {
                accountWOMCMap.put(newAcc.Id, newAcc);
            }
        }

        List<Merchant_Cluster__c> merchantClusterList = new List<Merchant_Cluster__c>();
        if (!accountWOMCMap.isEmpty()) {
            for (account acc : accountWOMCMap.values()) {
                Merchant_Cluster__c merchantCluster = new Merchant_Cluster__c();
                merchantCluster.Ultimate_Parent__c = acc.Id;
                merchantCluster.status__c = 'Inactive';
                merchantCluster.Business_Name__c = acc.Name;
                merchantClusterList.add(merchantCluster);
            }

            if (!merchantClusterList.isEmpty()) {
                insert merchantClusterList;
            }
        }
    }

    /**
     * This method will update merchant cluster and SBS_Book_of_Business_ID__c on Ultimate Parent accounts .
     * @author  Samarjit Baruah
     * @param Map of account Ids and Account records
     * @date 09/01/2021
     * @throws Built-in ListException, SObjectException, QueryException
     * @return void
     */
    public static void updateMerchantCluster(Map<Id, Account> newAccountMap) {
        Map<Id, Account> accountWOMCMap = new Map<Id, Account>();
        //get account map without Merchant Cluster
        for (Account newAcc : newAccountMap.values()) {
            if (
                newAcc.SBS_Account_Type__c == 'Ultimate Parent' &&
                newAcc.Merchant_Cluster__c == null
            ) {
                if (accountWOMCMap.get(newAcc.Id) == null) {
                    accountWOMCMap.put(newAcc.Id, newAcc);
                }
            }
        }

        if (!accountWOMCMap.isEmpty()) {
            Map<Id, Merchant_Cluster__c> accountMCMap = new Map<Id, Merchant_Cluster__c>();
            //check lagacy merchant cluster records if alreday created
            for (Merchant_Cluster__c mc : [
                SELECT Id, Ultimate_Parent__c, BoB_Id__c
                FROM Merchant_Cluster__c
                WHERE Ultimate_Parent__c IN :accountWOMCMap.keySet()
            ]) {
                if (!accountMCMap.containsKey(mc.Ultimate_Parent__c)) {
                    accountMCMap.put(mc.Ultimate_Parent__c, mc);
                }
            }

            //populate the account with lagecy merchant cluster
            for (Account newAcc : accountWOMCMap.values()) {
                if (accountMCMap.get(newAcc.Id) != null) {
                    Merchant_Cluster__c mc = accountMCMap.get(newAcc.Id);
                    newAcc.Merchant_Cluster__c = mc.Id;
                    newAcc.SBS_Book_of_Business_ID__c = mc.BoB_Id__c;
                }
            }
        }
    }
}