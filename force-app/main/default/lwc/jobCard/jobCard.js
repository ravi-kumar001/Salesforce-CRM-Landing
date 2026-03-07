import { LightningElement, track } from 'lwc';

export default class JobCard extends LightningElement {

    step = "1";

    chassisNo = 'RFBW00525';
    runningHours = '44';
    hourMeter = 'YES';

    fuelOptions = [
        {label:'Select', value:''},
        {label:'Low', value:'low'},
        {label:'Medium', value:'medium'},
        {label:'Full', value:'full'}
    ];

    get isStepOne(){
        return this.step === "1";
    }

    get isStepTwo(){
        return this.step === "2";
    }

    get isYes(){
        return this.hourMeter === 'YES';
    }

    get isNo(){
        return this.hourMeter === 'NO';
    }

    handleNext(){
        if(this.step === "1"){
            this.step = "2";
        }
    }

    handleBack(){
        if(this.step === "2"){
            this.step = "1";
        }
    }

    handleChassisChange(event){
        this.chassisNo = event.target.value;
    }

    handleRunningHourChange(event){
        this.runningHours = event.target.value;
    }

    handleHourMeter(event){
        this.hourMeter = event.target.value;
    }

}