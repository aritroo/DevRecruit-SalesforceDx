import { LightningElement, track, api } from 'lwc';
export default class DevRec_login extends LightningElement {

    @track email = "";
    @track password = "";
    @track errorMessage = "";
    @track isLoading = false;

    get buttonLabel() {
        return this.isLoading ? "Logging in..." : "Login";
    }

    handleEmailChange(event) {
        this.email = event.target.value;        
    }

    handlePasswordChange(event) {
        this.password = event.target.value;        
    }

    handleLogin() {

        this.errorMessage = '';

        // Validation
        if (!this.email || !this.password) {

            this.errorMessage = 'Please enter email and password';
            console.error("error in lgoin@@ ", this.errorMessage);
            return;
        }

        this.isLoading = true;

        // Send event to Aura wrapper
        const loginEvent = new CustomEvent('userlogin', {
            detail: {
                email: this.email,
                password: this.password
            }
        });

        console.log("Custom login event @@ ", loginEvent);

        this.dispatchEvent(loginEvent);
    }

    // Called from Aura after login response
    @api
    stopLoading(message) {

        this.isLoading = false;

        if (message) {
            this.errorMessage = message;
        }

        console.log("Is loading : ", this.isLoading);
        console.log("Error message @@ : ", this.errorMessage);
    }

}