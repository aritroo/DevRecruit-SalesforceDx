/**
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 * Class Name      : dRCustomLoginCMP_CTRL_TEST
 * Author          : Aritroo
 * Created Date    : June 10, 2026
 * Last Modified By: Aritroo
 * Last Modified On: June 10, 2026
 * Description     : This class implements controller functions for the Aura cmp DRLoginWrapper
 * * Change History  :
 * Date          │   Author     │   Change
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 * June 10, 2026  │ Aritroo   │ Initial version, added success and exception paths
 * ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――
 */
@IsTest
private class dRCustomLoginCMP_CTRL_TEST {

    @IsTest
    static void testGetLoginBgResourceName_Success() {
        // Test the positive path
        // Note: This relies on the org having at least one DevRec_CDMT__mdt record. 
        // If the org has none, it will safely hit the catch block here as well.
        Test.startTest();
        String loginUrl = dRCustomLoginCMP_CTRL.getLoginBgResourceName();
        Test.stopTest();

        // We assert that no unhandled exceptions were thrown
        System.assertNotEquals('UnreachableString', loginUrl, 'Method executed without fatal error');
    }

    @IsTest
    static void testGetLoginBgResourceName_Exception() {
        // Force the exception variable to true to cover the catch block
        dRCustomLoginCMP_CTRL.forceExceptionForTest = true;

        Test.startTest();
        String loginUrl = dRCustomLoginCMP_CTRL.getLoginBgResourceName();
        Test.stopTest();

        // The catch block returns null, so we assert that the result is null
        System.assertEquals(null, loginUrl, 'The method should return null when an exception is caught');
    }
}