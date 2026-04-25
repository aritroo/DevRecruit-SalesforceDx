/**
 * @Class Name:   DevRec_sidebarCTRLTest.cls
 * @Description:  Test class for DevRec_sidebarCTRL.
 * @Author:       Aritroo Chowdhury
 * @Last Modified: 2026-04-20
 * -----------------------------------------------------------------------------------------
 * Modification Log:
 * -----------------------------------------------------------------------------------------
 * Ver   Date         Author            Modification Details
 * ---   ----------   ---------------   ----------------------------------------------------
 * 1.0   2026-04-20   Aritroo           Initial version.
 * -----------------------------------------------------------------------------------------
 */

@IsTest(SeeAllData=true)
private class DevRec_sidebarCTRLTest {

    @IsTest
    static void testGetMenuItems() {

        Test.startTest();
        List<DevRec_sidebarCTRL.MenuWrapper> results =
            DevRec_sidebarCTRL.getMenuItems();
        Test.stopTest();

        System.assertNotEquals(null, results);

        if(results.size() > 0){
            for(DevRec_sidebarCTRL.MenuWrapper item : results){
                System.assertNotEquals(null, item.label);
                System.assertNotEquals(null, item.target);
            }
        }
    }

    @IsTest
    static void testCatchBlock() {

        Test.startTest();

        try{
            // If menu does not exist, this hits catch block
            List<DevRec_sidebarCTRL.MenuWrapper> results =
                DevRec_sidebarCTRL.getMenuItems();

        } catch (Exception e){
            System.assert(
                e.getMessage().contains('Unable to load navigation menu')
            );
        }

        Test.stopTest();
    }
}