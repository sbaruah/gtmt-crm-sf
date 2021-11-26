@isTest
public class AccountTrigger_Test {

    static testMethod void AccountTrigger() { 
		Trigger_Activation__c taAU = new Trigger_Activation__c();
		taAU.Name = 'AccountTriggerafterUpdate';
		taAU.Active__c = True;
		insert taAU;
            
		Trigger_Activation__c tabi = new Trigger_Activation__c();
		tabi.Name = 'AccountTriggerbeforeInsert';
		tabi.Active__c = True;
		insert tabi;                    
        
        Trigger_Activation__c tao = new Trigger_Activation__c();
		tao.Name = 'AccountTrigger';
		tao.Active__c = True;
		insert tao;
        
		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
		User u1 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
			LocaleSidKey='en_US', ProfileId = p.Id, Sales_Team__c = 'Sales - UK',
			TimeZoneSidKey='America/Los_Angeles', UserName='standarduser_parentAccountowner@testorg.com');
		insert u1;
		system.debug(u1.Id);
		
        User u2 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
			LocaleSidKey='en_US', ProfileId = p.Id, Sales_Team__c = 'Sales - SMB',
			TimeZoneSidKey='America/Los_Angeles', UserName='standarduser_childAccountowner@testorg.com');
		insert u2;
		system.debug(u2.Id);
            
		Sales_Team__c st = new Sales_Team__c();
		st.Name = 'Sales - International';
		st.Country_Code__c = 'GB';
		st.Account_Propagation_Baseline__c = True;
		st.Account_Propagation_Owner__c = True;
		insert st;
             
		Sales_Team__c st1 = new Sales_Team__c();
		st1.Name = 'Sales - SMB';
		st1.Country_Code__c = 'US';
		st1.Account_Propagation_Baseline__c = True;
		st1.Account_Propagation_Owner__c = True;
		insert st1;         
            
		Account acc = new Account(name='Test Account-Parent',Revenue_Range__c = '$10k - $50k',Industry = 'Professional Services', Seller_Method__c = 'Phone',Source_Detail__c = 'Website Analyzer', Campaign_Detail__c = 'Test',Lead_Source__c = 'Sales Sourced',Marketing_Channel__c = 'Local');
		insert acc;
		system.debug(acc.OwnerId);  
        
		system.debug('acc owner on insert^^^'+acc.ownerid);
		Account acc1 = new Account(name='Test Child-Parent',Parentid = acc.id,Revenue_Range__c = '$10k - $50k',Industry = 'Professional Services',Seller_Method__c = 'Phone',Source_Detail__c = 'Website Analyzer', Campaign_Detail__c = 'Test',Lead_Source__c = 'Sales Sourced',Marketing_Channel__c = 'Local');
		insert acc1;
                
		system.debug('1-acc owner on insert^^^'+acc);
		system.debug('1-acc1 owner on insert^^^'+acc1);                                              
               
		system.debug('1-acc ST^^^'+acc.Source_Type__c);
		system.debug('1-acc1 ST^^^'+acc1.Source_Type__c);               
                
		System.runAs(u1){
			Test.StartTest();
			Account tempAcc = [select Id,Seller_Method__c,OwnerId, Source_Type__c from Account where Name = 'Test Account-Parent'];
			System.debug('tempAcc^^^'+tempAcc.ownerId);
			tempAcc.Seller_Method__c = 'Phone';
			tempAcc.ownerid = u1.id;
			update tempAcc;    
			system.debug('1-tempAcc After Update^^^'+tempAcc);
			system.debug('1-tempAcc after update^^^'+tempAcc.Source_Type__c);
			Test.StopTest();
		}
	}
    
	static testMethod void AccountTrigger1() { 
		Trigger_Activation__c taAU = new Trigger_Activation__c();
		taAU.Name = 'AccountTriggerafterUpdate';
		taAU.Active__c = True;
		insert taAU;
            
        Trigger_Activation__c tabi = new Trigger_Activation__c();
        tabi.Name = 'AccountTriggerbeforeInsert';
        tabi.Active__c = True;
        insert tabi; 
        
        Trigger_Activation__c tao = new Trigger_Activation__c();
        tao.Name = 'AccountTrigger';
        tao.Active__c = True;
        insert tao;
        
		Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
		User u1 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
			LocaleSidKey='en_US', ProfileId = p.Id, Sales_Team__c = 'Sales - SMB',
			TimeZoneSidKey='America/Los_Angeles', UserName='standarduser_parentAccountowner@testorg.com');
		insert u1;
		system.debug(u1.Id);
        
		User u2 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
			LocaleSidKey='en_US', ProfileId = p.Id, Sales_Team__c = 'Sales - SMB',
			TimeZoneSidKey='America/Los_Angeles', UserName='standarduser_childAccountowner@testorg.com');
		insert u2;
		system.debug(u2.Id);
        
		User u3 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
			EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
			LocaleSidKey='en_US', ProfileId = p.Id, Sales_Team__c = 'Sales - SMB',
			TimeZoneSidKey='America/Los_Angeles', UserName='standarduser_childAccountowner1@testorg.com');
		insert u3;
        system.debug(u3.Id);

		Sales_Team__c st = new Sales_Team__c();
		st.Name = 'Sales - SMB';
		st.Country_Code__c = 'US';
		st.Account_Propagation_Baseline__c = True;
		st.Account_Propagation_Owner__c = True;
		insert st;   
            
		Account acc = new Account(name='Test Account-Parent',Revenue_Range__c = '$10k - $50k',Industry = 'Professional Services',Seller_Method__c = 'Phone',Source_Detail__c = 'Website Analyzer', Campaign_Detail__c = 'Test',Marketing_Channel__c = 'Local',OwnerId=u2.Id);
		insert acc;
		system.debug(acc.OwnerId);
        
		system.debug('acc owner on insert^^^'+acc.ownerid);
		Account acc2 = new Account(name='Test Child-Parent',Parentid = acc.id,Revenue_Range__c = '$10k - $50k',Industry = 'Professional Services',Seller_Method__c = 'Phone',Source_Detail__c = 'Other', Campaign_Detail__c = 'Test',Lead_Source__c = 'Sales Sourced',Marketing_Channel__c = 'Local',OwnerId=u3.Id);
		insert acc2;
        
		Account acc1 = new Account(name='Test Child-Child-Parent',Parentid = acc.id,Revenue_Range__c = '$10k - $50k',Industry = 'Professional Services',Seller_Method__c = 'Phone',Source_Detail__c = 'Website Analyzer', Campaign_Detail__c = 'Test',Lead_Source__c = 'Sales Sourced',Marketing_Channel__c = 'Local',OwnerId=u2.Id);
		insert acc1;
		system.debug('2-acc owner on insert^^^'+acc);
		system.debug('2-acc1 owner on insert^^^'+acc1);
		system.debug('2-acc2 owner on insert^^^'+acc2);                                                
                
		system.debug('2-acc ST^^^'+acc.Source_Type__c);
		system.debug('2-acc1 ST^^^'+acc1.Source_Type__c);
		system.debug('2-acc2 ST^^^'+acc2.Source_Type__c);
                
        System.runAs(u1){
            Test.StartTest();
            Account tempAcc = [select Id,Seller_Method__c,OwnerId, Source_Type__c from Account where Name = 'Test Account-Parent'];
            System.debug('tempAcc^^^'+tempAcc.ownerId);
            tempAcc.Seller_Method__c = 'Phone';
            tempAcc.ownerid = u1.id;
            update tempAcc;    
			system.debug('2-tempAcc After Update^^^'+tempAcc);
			system.debug('2-tempAcc after update^^^'+tempAcc.Source_Type__c);
            System.debug('tempAcc^^^'+tempAcc.ownerId);
			System.debug('U1 id is ^^^'+u1.Id);
            Test.StopTest();
        }
	}
    
    static testmethod void AccountTrigger2(){
        Trigger_Activation__c taAU = new Trigger_Activation__c();
        taAU.Name = 'AccountTriggerafterUpdate';
        taAU.Active__c = True;
        insert taAU;
        
        Trigger_Activation__c tabi = new Trigger_Activation__c();
        tabi.Name = 'AccountTriggerbeforeInsert';
        tabi.Active__c = True;
        insert tabi; 
        
        Trigger_Activation__c tao = new Trigger_Activation__c();
        tao.Name = 'AccountTrigger';
        tao.Active__c = True;
        insert tao;  
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User u1 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, Sales_Team__c = 'Sales - ENT',job__c = 'BDR',mkt_segment__c = 'BDR',
                           Office_Location__c = 'US - San Francisco',
                           TimeZoneSidKey='America/Los_Angeles', UserName='standarduser_parentAccountowner@testorg.com');
        insert u1;
        system.debug(u1.Id);
        
        Sales_Team__c st = new Sales_Team__c();
        st.Name = 'Sales - ENT';
        st.Country_Code__c = 'US';
        st.job__c = 'BDR';
        st.Account_Propagation_Baseline__c = True;
        st.Account_Propagation_Owner__c = True;
        insert st; 
        
        Id USSalesRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('US Sales').getRecordTypeId();
        
        Account acc = new Account(name='Test Account-Parent1',RecordTypeId = USSalesRecordTypeId, Revenue_Range__c = '$10k - $50k',Industry = 'Professional Services',Seller_Method__c = 'Phone',Source_Detail__c = 'Website Analyzer', Campaign_Detail__c = 'Test',Marketing_Channel__c = 'Local',OwnerId=u1.Id,sdr_rep__c = u1.Id,Enterprise_Meeting_Complete__c = False );
        insert acc;
        system.debug(acc.OwnerId);
        
        System.runAs(u1){
            Test.StartTest();
            Account tempAcc = [select Id,Seller_Method__c,OwnerId,Enterprise_Meeting_Complete__c from Account where ID =: acc.id];
            System.debug('tempAcc^^^'+tempAcc.ownerId);
            tempAcc.Enterprise_Meeting_Complete__c = True;
            update tempAcc;    
            Account acccheck =  [select Id,BDR_Meeting_Completed_Date__c from Account where ID =: acc.id];
            system.assertEquals(acccheck.BDR_Meeting_Completed_Date__c, system.today());
            Test.StopTest();
        }
    }
    
static testmethod void BoBTest(){
        Trigger_Activation__c taAU = new Trigger_Activation__c();
        taAU.Name = 'AccountTriggerafterUpdate';
        taAU.Active__c = True;
        insert taAU;
        
        Trigger_Activation__c tabi = new Trigger_Activation__c();
        tabi.Name = 'AccountTriggerbeforeInsert';
        tabi.Active__c = True;
        insert tabi; 
        
        Trigger_Activation__c tao = new Trigger_Activation__c();
        tao.Name = 'AccountTrigger';
        tao.Active__c = True;
        insert tao;
        
        Account acc = new Account(name = 'Test BoB Account');
        acc.SBS_BOB_Num_Employees__c = '3';
        acc.SBS_Book_of_Business_Id__c = '1234TestId';
        insert acc;        
        
        Test.startTest();
        system.debug('Num Employees initially' + acc.SBS_BOB_Num_Employees__c);
        Account acc1 = [SELECT SBS_Book_of_Business__c FROM Account WHERE Id =: acc.Id];
        acc1.SBS_Book_of_Business__c = '#N/A';
        update acc1;
        system.debug('Num Employees changed to' + acc.SBS_BOB_Num_Employees__c);
        Test.StopTest();
    }
}