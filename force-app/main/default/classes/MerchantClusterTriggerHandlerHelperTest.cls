@isTest
public class MerchantClusterTriggerHandlerHelperTest {
    @isTest
    static void populateNameTest() {
        List<Trigger_Activation__c> triggerActivationList = new List<Trigger_Activation__c>();

        Trigger_Activation__c accountTrigger = new Trigger_Activation__c();
        accountTrigger.Name = 'AccountTrigger';
        accountTrigger.active__c = true;
        triggerActivationList.add(accountTrigger);
        Trigger_Activation__c accountTriggerafterUpdate = new Trigger_Activation__c();
        accountTriggerafterUpdate.Name = 'AccountTriggerafterUpdate';
        accountTriggerafterUpdate.active__c = true;
        triggerActivationList.add(accountTriggerafterUpdate);
        Trigger_Activation__c accountTriggerbeforeInsert = new Trigger_Activation__c();
        accountTriggerbeforeInsert.Name = 'AccountTriggerbeforeInsert';
        accountTriggerbeforeInsert.active__c = true;
        triggerActivationList.add(accountTriggerbeforeInsert);
        insert triggerActivationList;
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.SBS_Account_Type__c = 'Ultimate Parent';
        
        Test.starttest();
        insert acc;
        List<Account> accList = [
            SELECT Id, Merchant_Cluster__c, Merchant_Cluster__r.name, Merchant_Cluster__r.BoB_Id__c
            FROM Account
            WHERE Id = :acc.Id
        ];
        
        System.assertEquals(
            accList[0].Merchant_Cluster__r.BoB_Id__c,
            accList[0].Merchant_Cluster__r.name,
            'Merchant Cluster name did not populate with ' + accList[0].Merchant_Cluster__r.BoB_Id__c
        );
        Test.stoptest();
    }
    
    @isTest
    static void updateLagacyMerchantClusterTest() {

        List<Trigger_Activation__c> triggerActivationList = new List<Trigger_Activation__c>();

        Trigger_Activation__c accountTrigger = new Trigger_Activation__c();
        accountTrigger.Name = 'AccountTrigger';
        accountTrigger.active__c = true;
        triggerActivationList.add(accountTrigger);
        Trigger_Activation__c accountTriggerafterUpdate = new Trigger_Activation__c();
        accountTriggerafterUpdate.Name = 'AccountTriggerafterUpdate';
        accountTriggerafterUpdate.active__c = true;
        triggerActivationList.add(accountTriggerafterUpdate);
        Trigger_Activation__c accountTriggerbeforeInsert = new Trigger_Activation__c();
        accountTriggerbeforeInsert.Name = 'AccountTriggerbeforeInsert';
        accountTriggerbeforeInsert.active__c = true;
        triggerActivationList.add(accountTriggerbeforeInsert);
        insert triggerActivationList;

        Account acc1 = new Account();
        acc1.Name = 'Test Account 1';
        //acc.SBS_Account_Type__c = 'Ultimate Parent';
        insert acc1;
        Merchant_Cluster__c mc = new Merchant_Cluster__c();
        mc.Ultimate_Parent__c = acc1.Id;
        insert mc;
        Test.starttest();
        AccountTriggerHandler.isRecursiveCheck = true;
        acc1.SBS_Account_Type__c = 'Ultimate Parent';
        acc1.Merchant_Cluster__c = null;
        update acc1;
        
        List<Account> accList = [Select Id, Merchant_Cluster__c from Account where Id = :acc1.Id];
        System.assertEquals(
            accList[0].Merchant_Cluster__c,
            mc.Id,
            'Merchant Cluster Didn\'t get updated correctly: ' + mc.Id
        );
        Test.stoptest();
    }
}