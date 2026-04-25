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

        // Fetch real network
        Network nw = [
            SELECT Id, Name
            FROM Network
            LIMIT 1
        ];

        // Fetch real Navigation Link Set
        NavigationLinkSet nav = [
            SELECT Id, DeveloperName, NetworkId
            FROM NavigationLinkSet
            WHERE NetworkId = :nw.Id
            LIMIT 1
        ];

        Test.startTest();

        List<DevRec_sidebarCTRL.MenuWrapper> results =
            DevRec_sidebarCTRL.getMenuItems(nav.DeveloperName, nw.Id);

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
            DevRec_sidebarCTRL.getMenuItems('WrongMenu', 'WrongId');
            System.assert(true);

        } catch(Exception e){
            System.assert(
                e.getMessage().contains('Unable to load navigation menu')
            );
        }

        Test.stopTest();
    }
}