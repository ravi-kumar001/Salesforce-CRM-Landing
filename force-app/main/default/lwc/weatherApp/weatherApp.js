import { LightningElement, track } from 'lwc';
import getWeather from '@salesforce/apex/WeatherController.getWeather';

export default class WeatherApp extends LightningElement {

    city = '';
    @track weather;

    handleCityChange(event) {
        this.city = event.target.value;
    }

    getWeatherData() {
        getWeather({ city: this.city })
            .then(result => {
                this.weather = JSON.parse(result);
            })
            .catch(error => {
                console.error(error);
            });
    }

    get weatherDescription() {
        if (this.weather && this.weather.weather) {
            return this.weather.weather[0].description;
        }
        return '';
    }
}