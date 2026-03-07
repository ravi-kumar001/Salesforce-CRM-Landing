import { LightningElement, wire, track } from 'lwc';
import getQuotes from '@salesforce/apex/LwcIntegration.getLwcIntegrationResponse';

export default class LwcIntegration extends LightningElement {
    @track quotes = [];
    @wire(getQuotes)
    wiredQuotes({ error, data }) {
        if (data) {
            const parsedData = JSON.parse(data);
            console.log('parsedData' + parsedData);
            this.quotes = parsedData.quotes;
        } 
        else if (error) {
            console.error(error);
        }
    }
}