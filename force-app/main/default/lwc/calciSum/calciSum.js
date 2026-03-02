import { LightningElement } from 'lwc';

export default class CalciSum extends LightningElement {
    num1 = 0;
    num2 = 0;
    sum = 0;

    handleInputChange(event) {
        if (event.target.label === 'Enter First Number') {
            this.num1 = event.detail.value;
        } else if (event.target.label === 'Enter Second Number') {
            this.num2 = event.detail.value;
        }
    }

    calculateSum() {
        this.sum = parseInt(this.num1) + parseInt(this.num2);
    }
    calculateSub() {
        this.sum = parseInt(this.num1) - parseInt(this.num2);
    }
    calculateMul() {
        this.sum = parseInt(this.num1) * parseInt(this.num2);
    }
    calculateDiv() {
        this.sum = parseInt(this.num1) / parseInt(this.num2);
    }
}