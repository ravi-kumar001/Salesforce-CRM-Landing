public with sharing class LwcIntegration {

    @AuraEnabled(cacheable=true)
    public static String getLwcIntegrationResponse() {
        try {
            HttpRequest request = new HttpRequest();
            request.setEndpoint('https://dummyjson.com/quotes');
            request.setMethod('GET');
            request.setHeader('Accept', 'application/json');
            request.setHeader('User-Agent', 'Mozilla/5.0');

            Http http = new Http();
            HttpResponse response = http.send(request);

            System.debug('Status Code: ' + response.getStatusCode());
            System.debug('Response Body: ' + response.getBody());

            if(response.getStatusCode() == 200){
                return response.getBody();
            } else {
                throw new AuraHandledException('API Error: ' + response.getStatusCode() + ' ' + response.getBody());
            }

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}