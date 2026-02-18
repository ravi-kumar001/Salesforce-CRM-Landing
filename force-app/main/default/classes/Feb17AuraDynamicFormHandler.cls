public class Feb17AuraDynamicFormHandler {
    @AuraEnabled
    public static List<Map<String, Object>> getFieldSetFields(String fieldSetName, String objectName) {
        List<Map<String, Object>> fields = new List<Map<String, Object>>();
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        Schema.FieldSet fieldSet = objType.getDescribe().fieldSets.getMap().get(fieldSetName);
        
        for(Schema.FieldSetMember f : fieldSet.getFields()) {
            Map<String, Object> fieldMap = new Map<String, Object>();
            fieldMap.put('label', f.getLabel());
            fieldMap.put('fieldName', f.getFieldPath());
            fields.add(fieldMap);
        }
        
        System.debug('returned Fields' + fields);
        return fields;
    }
}