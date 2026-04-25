import { LightningElement } from 'lwc';
import logo from '@salesforce/label/c.DR_NavLogoUrl';
import avatar from '@salesforce/label/c.UHeader_Avatar_URL';
import help from '@salesforce/label/c.UHeader_Help_URL';
import notification from '@salesforce/label/c.UHeader_Notification_URL';
import setup from '@salesforce/label/c.UHeader_Setup_URL';


export default class DevRec_UniversalHeader extends LightningElement {

    logoUrl;
    avatarUrl;
    helpUrl;
    notificationUrl;
    setupUrl;

    connectedCallback() {

        this.logoUrl = logo;
        this.avatarUrl = avatar;
        this.helpUrl = help;
        this.notificationUrl = notification;
        this.setupUrl = setup;
         
    }

}