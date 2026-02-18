({
    doInit: function(component, event, helper) {
        var objectName = component.get("v.objectName");
        var actionFields = component.get("c.getFieldSetFields");
        actionFields.setParams({ 
            fieldSetName: objectName + "_Field_Set", 
            objectName : objectName 
        });
        actionFields.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.fields", response.getReturnValue());
            }
        });
        $A.enqueueAction(actionFields);

        var actionData = component.get("c.getRecords");
        actionData.setParams({ 
            fieldSetName: objectName + "_Field_Set",
            objectName : objectName
        });
        actionData.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                component.set("v.records", response.getReturnValue());
            }
        });
        $A.enqueueAction(actionData);
    }
})