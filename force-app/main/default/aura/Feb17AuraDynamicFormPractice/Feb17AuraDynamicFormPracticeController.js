({
    doInit: function(component, event, helper) {
        var objectName = component.get("v.objectName");
        var actionFields = component.get("c.getFieldSetFields");
        actionFields.setParams({ 
            fieldSetName: objectName + "_Form_Field_Set", 
            objectName : objectName 
        });
        actionFields.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.fields", response.getReturnValue());
                console.log("Fields => " , component.get("v.fields"));
            }
        });
        $A.enqueueAction(actionFields);
    },
    handleCancel: function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
})