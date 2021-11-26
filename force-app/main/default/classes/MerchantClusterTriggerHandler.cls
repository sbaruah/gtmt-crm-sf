/**
 * @author Samarjit Baruah
 * @date   09/01/2021
 * @description This Class is used as extension of TriggerHandler for Object Merchant_Cluster__c object.
 *              This class is used for entry for all service methods for Merchant Cluster.
 */
public class MerchantClusterTriggerHandler extends TriggerHandler {
    private Map<Id, Merchant_Cluster__c> newMerchantClusterMap;
    private Map<Id, Merchant_Cluster__c> oldMerchantClusterMap;

    public MerchantClusterTriggerHandler() {
        this.newMerchantClusterMap = (Map<Id, Merchant_Cluster__c>) Trigger.newMap;
        this.oldMerchantClusterMap = (Map<Id, Merchant_Cluster__c>) Trigger.oldMap;
    }

    //protected override void beforeInsert() {}
    //protected override void beforeUpdate() {}
    //protected override void beforeDelete(){}
    protected override void afterInsert() {
        MerchantClusterTriggerHandlerHelper.updateAccount(this.newMerchantClusterMap, null);
    }
    protected override void afterUpdate() {
        MerchantClusterTriggerHandlerHelper.updateAccount(this.newMerchantClusterMap, this.oldMerchantClusterMap);
    }
    //protected override void afterDelete(){}
    //protected override void afterUndelete(){}
}