({
    doInit: function (component, event, helper) {
        debugger;
        component.set("v.isLoading", true);

        var action = component.get("c.getAccountInfo");
        action.setParams({ accId: component.get("v.recordId") });

        action.setCallback(this, function (response) {
            component.set("v.isLoading", false);

            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.accRecord", response.getReturnValue());
            } else {
                console.error("Server error:", response.getError());
            }
        });
        console.log("Account Data => " + component.get('v.accRecord'))
        $A.enqueueAction(action);

        helper.getOppData(component);
    },
    openModalHandler: function (component, event, helper) {
        component.set("v.isModalOpen", true);
    },
    openOppModalHandler: function (component, event, helper) {
        component.set("v.isOppModalOpen", true);
    },
    closeOppModalHandler: function (component, event, helper) {
        component.set("v.isOppModalOpen", false);
    },
    closeModalHandler: function (component, event, helper) {
        component.set("v.isModalOpen", false);
    },
    applyCSS: function (cmp, event) {
        var cmpTarget = cmp.find('changeIt');
        $A.util.addClass(cmpTarget, 'changeMe');
    },

    removeCSS: function (cmp, event) {
        var cmpTarget = cmp.find('changeIt');
        $A.util.removeClass(cmpTarget, 'changeMe');
    }
})