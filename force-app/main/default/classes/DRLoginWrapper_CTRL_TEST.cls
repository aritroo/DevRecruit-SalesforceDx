/**
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 * Class Name      : DRLoginWrapper_CTRL_TEST
 * Author          : Aritroo
 * Created Date    : June 09, 2026
 * Last Modified By: Aritroo
 * Last Modified On: June 09, 2026
 * Description     : This class is a test class for DRLoginWrapper_CTRL 
 *  
 * Change History  :
 *  Date          │   Author     │   Change
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 *  June 09, 2026  │ Aritroo   │ Initial version
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 */

@IsTest
private class DRLoginWrapper_CTRL_TEST {

    @TestSetup
    static void setupTestData() {
        // 1. Create a Role (Account Owners MUST have a role to create Portal Users)
        UserRole adminRole = new UserRole(DeveloperName = 'PortalAdminRole', Name = 'Portal Admin Role');
        insert adminRole;

        // 2. Create a dedicated Admin User to avoid Mixed DML operations
        Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        User adminUser = new User(
            Alias = 'admr',
            Email = 'adminwithrole@testorg.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'AdminWithRole',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = adminProfile.Id,
            UserRoleId = adminRole.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'adminwithrole@testorg.com.drdev' + System.currentTimeMillis()
        );
        insert adminUser;

        // 3. Run as the new Admin to create the Portal Data
        System.runAs(adminUser) {
            Account acc = new Account(Name = 'Test Portal Account');
            insert acc;

            Contact con = new Contact(
                LastName = 'Test Contact',
                AccountId = acc.Id,
                Email = 'testuser123@portaltest.com'
            );
            insert con;

            // Fetch ANY valid Experience Cloud/Portal Profile
            // Fetch the custom profile we just created
            Profile portalProfile = [SELECT Id FROM Profile WHERE Name = 'DevRec CandidateUser' LIMIT 1];

            // Create Portal User
            User u = new User(
                Alias = 'tport',
                Email = 'testuser123@portaltest.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'PortalTester',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ProfileId = portalProfile.Id,
                ContactId = con.Id,
                TimeZoneSidKey = 'America/Los_Angeles',
                UserName = 'testuser123@portaltest.com.drdev' + System.currentTimeMillis(),
                IsActive = true
            );
            insert u;
        }
    }

    @IsTest
    static void testConstructor() {
        Test.startTest();
        DRLoginWrapper_CTRL controllerObj = new DRLoginWrapper_CTRL();
        Test.stopTest();

        System.assertNotEquals(null, controllerObj, 'Controller should be instantiated');
    }

    @IsTest
    static void testLoginWithEmail_Bypass() {
        DRLoginWrapper_CTRL.bypassLogin = true;

        Test.startTest();
        String result = DRLoginWrapper_CTRL.loginWithEmail('test@test.com', 'Password123', '/home');
        Test.stopTest();

        System.assertEquals('/mockHome', result, 'Should return mock home URL when bypassed');
    }

    @IsTest
    static void testLoginWithEmail_ValidUser() {
        DRLoginWrapper_CTRL.bypassLogin = false;

        Test.startTest();
        // This email MUST match the one inserted in the setupTestData block
        String result = DRLoginWrapper_CTRL.loginWithEmail('testuser123@portaltest.com', 'Password123', '/home');
        Test.stopTest();

        // Site.login() always returns null in tests, so it will fall through to the 'Login failed' return statement
        System.assertEquals('Login failed', result, 'Site.login returns null in tests, should return Login failed string');
    }

    @IsTest
    static void testLoginWithEmail_ExceptionPath() {
        DRLoginWrapper_CTRL.bypassLogin = false;

        Test.startTest();
        // Passing an unregistered email to explicitly force the SOQL exception and hit the catch block
        String result = DRLoginWrapper_CTRL.loginWithEmail('invalid_email@test.com', 'Password123', '/home');
        Test.stopTest();

        System.assert(result.contains('List has no rows'), 'Should catch the SOQL exception for missing user');
    }
}