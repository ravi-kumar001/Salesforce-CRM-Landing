public class Feb18Child1AuraComponenHandler {
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
    
    @AuraEnabled
    public static List<SObject> getRecords(String fieldSetName, String objectName, Integer limitSize, Integer offsetSize) {
        
        Schema.SObjectType objType = Schema.getGlobalDescribe().get(objectName);
        Schema.FieldSet fieldSet = objType.getDescribe().fieldSets.getMap().get(fieldSetName);
        
        String query = 'SELECT Id';
        
        for(Schema.FieldSetMember f : fieldSet.getFields()) {
            query += ', ' + f.getFieldPath();
        }
        query += ' FROM ' + objectName;
        query += ' ORDER BY Id DESC';
        query += ' LIMIT ' + limitSize;
        query += ' OFFSET ' + offsetSize;
        
        return Database.query(query);
    }
}