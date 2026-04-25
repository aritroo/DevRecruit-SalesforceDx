/**
 * @Class Name:   DevRec_sidebarCTRL.cls
 * @Description:  Controller class to fetch data from Site Navigation Menu.
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

public class DevRec_sidebarCTRL {
    
    public class MenuWrapper {
        @AuraEnabled public String rawLabel;
        @AuraEnabled public String label;
        @AuraEnabled public String iconName;
        @AuraEnabled public String target;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<MenuWrapper> getMenuItems(String menuName, String communityId){
        List<MenuWrapper> results = new List<MenuWrapper>();
        
        try{
            
            /* NavigationLinkSet navSet = [SELECT Id, MasterLabel FROM NavigationLinkSet 
                                        WHERE MasterLabel = 'DevRec_CustomNavigation' WITH SECURITY_ENFORCED LIMIT 1]; */
            /* 
            SELECT Id, Label, Target, Position, NavigationLinkSet.NetworkId, NavigationLinkSet.DeveloperName,  
                Status FROM NavigationMenuItem
                                              WHERE NavigationLinkSetId = '0LmdL000001iomvSAA' ORDER BY Position ASC */
            
            List<NavigationMenuItem> items = [SELECT Id, Label, Target, Position FROM NavigationMenuItem
                                              WHERE NavigationLinkSet.NetworkId =:communityId 
                                              AND NavigationLinkSet.DeveloperName =:menuName AND Status ='Live' 
                                              WITH SECURITY_ENFORCED ORDER BY Position ASC];
            
            for (NavigationMenuItem item : items) {
                results.add(buildMenuItem(item));
            }
            
            return results;
            
        } catch (Exception e) {
            System.debug('Navigation Menu Error: ' + e.getMessage());
            
            throw new AuraHandledException('Unable to load navigation menu. Please contact your administrator.');
        }
        
    }
    
    private static MenuWrapper buildMenuItem(NavigationMenuItem item) {
        MenuWrapper row = new MenuWrapper();
        String rawLabel = String.isBlank(item.Label) ? 'Untitled' : item.Label;
        row.rawLabel = rawLabel;
        row.target = String.isBlank(item.Target) ? '#' : item.Target;
        parseLabelAndIcon(rawLabel, row);
        
        return row;
    }
    
    private static void parseLabelAndIcon(String rawLabel, MenuWrapper row) {
        row.label = rawLabel;
        row.iconName = '';
        Integer startIndex = rawLabel.indexOf('[');
        Integer endIndex = rawLabel.indexOf(']');
        
        if (startIndex > -1 && endIndex > startIndex) {
            row.iconName = rawLabel.substring(startIndex + 1, endIndex).trim();
            row.label = rawLabel.substring(0, startIndex).trim();
        }
    }
    
}