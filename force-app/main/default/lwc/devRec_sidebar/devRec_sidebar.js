import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import communityId from '@salesforce/community/Id';
import getMenuItems from '@salesforce/apex/DevRec_sidebarCTRL.getMenuItems';

export default class DevRec_sidebar extends NavigationMixin(LightningElement) {

    @api menuName;
    @track menuItems = [];
    @track errorMessage = '';

    currentPath = window.location.pathname;

    @wire(getMenuItems, { menuName: '$menuName', communityId: communityId })
    wiredMenu({ data, error }) {
        if (data) {
            try {                
                const savedTarget = sessionStorage.getItem('selectedMenuTarget');                

                this.menuItems = data.map(item => {
                    const iconUrl = item.iconName ? `/resource/${item.iconName}` : '';
                    const targetPath = this.extractPath(item.target);
                    const isActive = this.normalizePath(this.currentPath) === this.normalizePath(targetPath) || savedTarget === item.target;

                    return { ...item, iconUrl, isActive, cssClass: isActive ? 'menu-item active' : 'menu-item' };
                });
                this.errorMessage = '';                
            } catch (e) {
                this.handleError('Failed to process menu items.', e);
            }

        } else if (error) {
            console.log('Error @@ ', error);
            this.handleError('Failed to process menu items.', error);
        }
    }

    navigate(event) {

        try {
            const target = event.currentTarget.dataset.target;
            this.currentPath = target;
            sessionStorage.setItem('selectedMenuTarget', target);            
            this.menuItems = this.menuItems.map(item => {
                const active = item.target === target;

                return { ...item, isActive: active, cssClass: active ? 'menu-item active' : 'menu-item' };
            });

            this[NavigationMixin.Navigate]({
                type: 'standard__webPage',
                attributes: {
                    url: target
                }
            });

        } catch (e) {
            this.handleError("Navigation Failed ", e);
        }
    }

    extractPath(url) {
        try {
            return new URL(url, window.location.origin).pathname;
        } catch (e) {
            return url;
        }
    }

    handleError(message, error) {
        console.error(message, error);
        this.errorMessage = message;
    }

    normalizePath(path) {
        if (!path) return '/';

        let cleanPath = path.split('?')[0].split('#')[0];

        if (cleanPath.length > 1 && cleanPath.endsWith('/')) {
            cleanPath = cleanPath.slice(0, -1);
        }

        return cleanPath;
    }

}