trigger MerchantClusterTrigger on Merchant_Cluster__c(after insert, after update) {
    new MerchantClusterTriggerHandler().run();
}