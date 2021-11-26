public class AccountTriggerHandler extends TriggerHandler {
    public Map<ID, Account> accountNewMap = new Map<ID, Account>();
    public Map<ID, Account> accountOldMap = new Map<ID, Account>();
    public List<Account> accountNewList = new List<Account>();
    public List<Account> accountOldList = new List<Account>();
    public Boolean isOff = false;
    public static Boolean isRecursiveCheck = true;

    public AccountTriggerHandler() {
        accountNewMap = (Map<ID, Account>) Trigger.newMap; //Account New Map values
        accountOldMap = (Map<ID, Account>) Trigger.oldMap; //Account Old Map values
        accountNewList = (List<Account>) Trigger.new; //Account New List values
        accountOldList = (List<Account>) Trigger.old; //Account Old List values
    }

    //This method will call before Insert
    protected override void beforeInsert() {
        set<Id> parentIdSet = new Set<Id>();
        List<Account> listAcnt = new List<Account>();
        for (Account acnt : accountNewList) {
            if (acnt.ParentId != null) {
                parentIdSet.add(acnt.parentid);
            }
            // To set Sales Team info. Using before insert because of Auto Converted field is populated on update but on new account creation during lead conversion.
            if (acnt.Auto_Converted_Acct_Indicator__c) {
                System.debug('*********Am in loop******');
                listAcnt.add(acnt);
            }
        }
        // To set Sales Team info
        if (listAcnt.size() > 0) {
            AccountTriggerHandlerUtility.stampSalesTeamInfoAccount(listAcnt);
        }
        if (parentIdSet.size() > 0) {
            AccountTriggerHandlerUtility.setMerchantAccountDetails(parentIdSet, accountNewList);
        }
    }

    //This method will call before Update
    protected override void beforeUpdate() {
        set<Id> parentIdSet = new Set<Id>();
        List<Account> bobIdList = new List<Account>(); // ryanc bob field deletion pb
        List<Account> accountOwnerChnglst = new List<Account>();
        for (Account acnt : accountNewList) {
            Account oldAcc = accountOldMap.get(acnt.Id);
            if (acnt.ParentId != null && (acnt.ParentId != oldAcc.ParentId || oldAcc.ParentId == null)) {
                parentIdSet.add(acnt.parentid);
            }
            if (
                (acnt.SBS_Book_of_Business__c != oldAcc.SBS_Book_of_Business__c ||
                acnt.SBS_Book_of_Business_Id__c != oldAcc.SBS_Book_of_Business_Id__c) &&
                (acnt.SBS_Book_of_Business__c == '#N/A' ||
                acnt.SBS_Book_of_Business_ID__c == '#N/A')
            ) {
                bobIdList.add(acnt);
            }
            if (acnt.OwnerId != oldAcc.OwnerId) {
                accountOwnerChnglst.add(acnt);
            }
        }
        if (parentIdSet.size() > 0) {
            AccountTriggerHandlerUtility.setMerchantAccountDetails(parentIdSet, accountNewList);
        }
        if (bobIdList.size() > 0) {
            AccountTriggerHandlerUtility.BoBFieldDeletion(bobIdList);
        }
        if (accountOwnerChnglst.size() > 0) {
            AccountTriggerHandlerUtility.updateLastOwner(accountOwnerChnglst, accountOldMap);
        }

        AccountTriggerHandlerHelper.updateMerchantCluster(this.accountNewMap);
    }

    //This method will call before Delete
    /*protected override void beforeDelete(){
        
    }*/

    //This method will call after Insert
    protected override void afterInsert() {
        AccountTriggerHandlerHelper.createMerchantCluster(accountNewMap);
    }

    //This method will call after Update
    protected override void afterUpdate() {
        Map<String, Trigger_Activation__c> support = Trigger_Activation__c.getAll();
        if (support == null) {
            return;
        }
        Boolean isActive = false;
        if (support.get('AccountTriggerafterUpdate') != null) {
            isActive = support.get('AccountTriggerafterUpdate').Active__c;
        }
        if (isActive) {
            if (AccountTriggerHandler.isRecursiveCheck) {
                Map<Id, Account> mapofparentsourceacnt = new Map<Id, Account>();
                Account oldestacnt = new Account();
                Set<id> acntsrcidset = new Set<Id>();
                Set<id> acntnosrcidset = new Set<Id>();
                Set<id> owneridset = new Set<Id>();

                for (Account acnt : accountNewList) {
                    if (acnt.ownerId <> accountOldMap.get(acnt.id).ownerid) {
                        if (acnt.Lead_Source__c == null) {
                            acntnosrcidset.add(acnt.id);
                            //System.debug('added to acntnosrcidset 35 acnt = ' + acnt.Name + ' id=' + acnt.Id);
                        }
                        mapofparentsourceacnt.put(acnt.id, acnt);
                        acntsrcidset.add(acnt.id);
                        owneridset.add(acnt.ownerid);
                    }
                }
                if (acntsrcidset.size() > 0) {
                    AccountTriggerHandler.isRecursiveCheck = false;
                    System.debug('Am in not empty method');
                    AccountTriggerHandlerUtility.Update_Account_Hierarchy_Owner_Nosource(
                        owneridset,
                        acntsrcidset,
                        null,
                        mapofparentsourceacnt,
                        accountOldMap
                    );
                }
            }

            AccountTriggerHandlerUtility.Update_Related_Contact_Owner(accountNewList, accountNewMap, accountOldMap);
            AccountTriggerHandlerUtility.AccountEntBDRPoints(accountNewList, accountOldMap);
            AccountTriggerHandlerHelper.createMerchantCluster(accountNewMap);
        }
    }

    //This method will call after Delete
    /*protected override void afterDelete(){
        
    }*/

    //This method will call after Undelete
    /*protected override void afterUndelete(){
        
    }*/
}