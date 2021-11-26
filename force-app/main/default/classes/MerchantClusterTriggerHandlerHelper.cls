/**
 * @author Samarjit Baruah
 * @date   09/01/2021
 * @description This Class is used as helper class for MerchantClusterTriggerHandler.
 *              Used it as qualifier and entry methods for service classes. Keep the methods very light.
 */
@SuppressWarnings('PMD.ApexCRUDViolation')
public with sharing class MerchantClusterTriggerHandlerHelper {
    public static void populateName(Map<Id, Merchant_Cluster__c> newMerchantClusterMap) {
        for (Merchant_Cluster__c mc : newMerchantClusterMap.values()) {
            mc.Name = mc.BoB_Id__c;
        }
    }

    public static void updateAccount(
        Map<Id, Merchant_Cluster__c> newMerchantClusterMap,
        Map<Id, Merchant_Cluster__c> oldMerchantClusterMap
    ) {
        Set<Id> accountIds;
        Map<Id, Account> accMap = new Map<Id, Account>();
        List<Merchant_Cluster__c> mcList = new List<Merchant_Cluster__c>();
        for (Merchant_Cluster__c mc : newMerchantClusterMap.values()) {
            if (
                mc.Ultimate_Parent__c != null &&
                (oldMerchantClusterMap == null ||
                newMerchantClusterMap.get(mc.Id).Ultimate_Parent__c !=
                oldMerchantClusterMap.get(mc.Id).Ultimate_Parent__c)
            ) {
                if (!accMap.containsKey(mc.Ultimate_Parent__c)) {
                    Account acc = new Account();
                    acc.Id = mc.Ultimate_Parent__c;
                    acc.Merchant_Cluster__c = mc.Id;
                    acc.SBS_Book_of_Business_ID__c = mc.BoB_Id__c;
                    accMap.put(acc.Id, acc);
                }
            }
            if (mc.Name != mc.BoB_Id__c) {
                Merchant_Cluster__c mc1 = new Merchant_Cluster__c(Id = mc.Id);
                mc1.Name = mc.BoB_Id__c;
                mcList.add(mc1);
            }
        }

        if (!accMap.isEmpty()) {
            List<account> accountList = accMap.values();
            update accountList;
        }

        if (!mcList.isEmpty()) {
            update mcList;
        }
    }
}