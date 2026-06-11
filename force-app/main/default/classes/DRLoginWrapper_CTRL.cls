/**
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 * Class Name      : DRLoginWrapper_CTRL
 * Author          : Aritroo
 * Created Date    : May 11, 2026
 * Last Modified By: Aritroo
 * Last Modified On: May 11, 2026
 * Description     : This class implements controller functions for the Aura cmp DRLoginWrapper
 *  
 * Change History  :
 *  Date          │   Author     │   Change
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 *  May 11, 2026  │ Aritroo   │ Initial version
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 */

public without sharing class DRLoginWrapper_CTRL {

	public DRLoginWrapper_CTRL(){
		
	}
     
    @TestVisible
    static Boolean bypassLogin = false;
    
    @AuraEnabled
    public static String loginWithEmail(String email, String password, String startUrl) {
      
      	// Removed Test.isRunningTest() to allow test coverage of the try/catch block
        if(bypassLogin){
            return '/mockHome';
        }
        
        try{
            User user = [SELECT Id, Username, IsPortalEnabled FROM User WHERE Email =:email AND IsActive = true 
                         AND IsPortalEnabled = true LIMIT 1];
            
            
            ApexPages.PageReference lgn = Site.login(user.Username, password, startUrl);            
            
            if(lgn != null) {
                return lgn.getUrl();
            }
            
            return 'Login failed';
        }
        catch (Exception ex) {
            return ex.getMessage();            
        }
    }
    
}