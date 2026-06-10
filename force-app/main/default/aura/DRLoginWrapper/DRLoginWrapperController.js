({
	doInit: function (component, event, helper) {

		const queryString = window.location.search;

		const urlParams = new URLSearchParams(queryString);
		let startUrl = urlParams.get("startURL");

		// Decode URL
		if (startUrl) {
			startUrl = decodeURIComponent(startUrl);
		} else {
			startUrl = "/s/";
		}

		component.set("v.startUrl", startUrl);
	},

	handleLogin: function (component, event, helper) {

		const detail = event.getParams();
		const email = detail.email;
		const password = detail.password;

		const action = component.get("c.loginWithEmail");

		action.setParams({
			email: email,
			password: password,
			startUrl: component.get("v.startUrl")
		});

		action.setCallback(this, function (response) {
			const state = response.getState();
			const loginForm = component.find("loginForm");

			if (state === "SUCCESS") {

				const rtnValue = response.getReturnValue();

				if (rtnValue && !rtnValue.includes('failed')) {					
					window.location.href = rtnValue;
				} else {
					console.error("Error in return value @@ ", rtnValue);
					loginForm.stopLoading(rtnValue);
				}

			} else {
				console.error("Invalid email or password.");
				loginForm.stopLoading("Invalid email or password.");
			}

		});

		$A.enqueueAction(action);
	}
})