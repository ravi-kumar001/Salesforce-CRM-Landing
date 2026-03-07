import { LightningElement, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import MESSAGE_CHANNEL from '@salesforce/messageChannel/myMessageChannel__c';

export default class SenderComponent extends LightningElement {
    message = "";

    @wire(MessageContext)
    messageContext;

    handleChange(event) {
        this.message = event.target.value;
    }

    handleClick() {
        const payload = { message: this.message };
        publish(this.messageContext, MESSAGE_CHANNEL, payload)
    }
}
