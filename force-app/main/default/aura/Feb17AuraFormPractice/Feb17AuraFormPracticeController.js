({
	handleCancel: function(cmp, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    handleSubmit: function(cmp, event, helper) {
        event.preventDefault();
        var fields = event.getParam('fields');
        fields.AccountId = cmp.get("v.recordId");
        cmp.find('myform').submit(fields);
    },
    handleSuccess: function(cmp, event, helper) {
        var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams({
            "title": "Contact Saved",
            "message": "The new contact was created."
        });
        
        $A.get("e.force:closeQuickAction").fire();
        resultsToast.fire();
        
        $A.get("e.force:refreshView").fire();    
    }
})