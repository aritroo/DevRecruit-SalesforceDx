/**
* ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
* Class Name      : dRCustomLoginCMP_CTRL
* Author          : Aritroo Chowdhury
* Created Date    : May 1, 2026
* Last Modified By: Aritroo Chowdhury
* Last Modified On: May 1, 2026
* Description     : This class used to fetch login url
*  
* Change History  :
*  Date          │   Author     │   Change
* ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
*  May 1, 2026  │ Aritroo Chowdhury   │ Initial version
* ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
*/

public with sharing class dRCustomLoginCMP_CTRL {
    
    // Added for test coverage of the catch block
    @TestVisible private static Boolean forceExceptionForTest = false;
    
    @AuraEnabled(cacheable=true)
    public static String getLoginBgResourceName() {
        try{
            
            // Artificially throw an exception if triggered by the test class
            if (forceExceptionForTest) {
                throw new CalloutException('Forced Exception for Test Coverage');
            }
            
            DevRec_CDMT__mdt config = [SELECT Login_URL__c FROM DevRec_CDMT__mdt  LIMIT 1];
            
            return config.Login_URL__c;
        }catch (Exception e) {
            System.debug('ERROR @@ ' + e.getMessage());
            return null;
        }
    }    
}