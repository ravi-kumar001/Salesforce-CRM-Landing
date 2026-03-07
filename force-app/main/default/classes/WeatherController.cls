public with sharing class WeatherController {

    @AuraEnabled(cacheable=true)
    public static String getWeather(String city) {

        String apiKey = '';
        String endpoint = '?q='+ city + '&appid=' + apiKey + '&units=metric';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        if(response.getStatusCode() == 200){
            return response.getBody();
        }

        return null;
    }
}