({
    doInit: function(component, event, helper) {
        var action = component.get("c.getLoginBgResourceName");

        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var resourceUrl = response.getReturnValue();				
				component.set("v.bgUrl", resourceUrl);            
            } else {
                console.error("Response ERROR @@ ", response.getError());
            }
        });

        $A.enqueueAction(action);
    }
})