import { LightningElement,api } from 'lwc';

export default class NumberInput extends LightningElement {
    @api label;
    @api value;

    handleInputChange(event) {
        this.value = event.target.value;
        const inputChange = new CustomEvent('inputchange', {
            detail: {
                value: this.value,
                label: this.label
            }
        });
        this.dispatchEvent(inputChange);
    }
}