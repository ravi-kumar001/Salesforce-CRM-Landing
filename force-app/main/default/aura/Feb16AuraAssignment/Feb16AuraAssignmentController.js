({
    doInit: function(component, event, helper) {
        var action = component.get("c.getRelatedData");
        action.setParams({ recordId: component.get("v.recordId") });

        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.records", data.records);
                component.set("v.title", data.title);
                
                $A.createComponent(
                    "lightning:badge", { "label": "Active" },
                    function(newBadge, status, errorMessage) {
                        if (status === "SUCCESS") {
                            var container = component.find("badgeContainer");
                            if(container.length > 0) component.set("v.body", newBadge);
                        }
                    }
                );
            }
        });
        $A.enqueueAction(action);
    },

    toggleView: function(component) {
        var current = component.get("v.viewMode");
        component.set("v.viewMode", current === "table" ? "grid" : "table");
    }
})