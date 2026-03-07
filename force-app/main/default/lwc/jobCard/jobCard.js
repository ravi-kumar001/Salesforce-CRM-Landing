import { LightningElement, track } from 'lwc';
import searchProduct from '@salesforce/apex/JobCardController.searchProduct';

export default class JobCard extends LightningElement {

    step = "1";

    chassisNo = 'RFBW00525';
    runningHours = '44';
    hourMeter = 'YES';

    products = [];

    fuelOptions = [
        { label: 'Select', value: '' },
        { label: 'Low', value: 'low' },
        { label: 'Medium', value: 'medium' },
        { label: 'Full', value: 'full' }
    ];

    get isStepOne() {
        return this.step === "1";
    }

    get isStepTwo() {
        return this.step === "2";
    }

    get isYes() {
        return this.hourMeter === 'YES';
    }

    get isNo() {
        return this.hourMeter === 'NO';
    }

    handleNext() {
        if (this.step === "1") {
            this.step = "2";
        }
    }

    handleBack() {
        if (this.step === "2") {
            this.step = "1";
        }
    }

    get hasProducts() {
        return this.products && this.products.length > 0;
    }

    handleChassisChange(event) {
        this.chassisNo = event.target.value;

        if (this.chassisNo.length < 3) {
            this.products = [];
            return;
        }

        searchProduct({ chassisNo: this.chassisNo })
            .then(result => {
                this.products = result;
            })
            .catch(error => {
                console.log(error);
            });
    }

    handleRunningHourChange(event) {
        this.runningHours = event.target.value;
    }
    handleHourMeter(event) {
        this.hourMeter = event.target.value;
    }
    handleSelectProduct(event) {
        const productId = event.currentTarget.dataset.id;

        const selected = this.products.find(p => p.Id === productId);

        if (selected) {

            this.selectedProduct = selected;

            this.chassisNo = selected.Chasis_Number__c;
            this.tractorModel = selected.PricebookEntry.Product2.Name;

        }

        this.products = [];
    }

    @track isAccordionOpen = true;

    get accordionIcon() {
        return this.isAccordionOpen
            ? "utility:chevrondown"
            : "utility:chevronright";
    }

    toggleAccordion() {
        this.isAccordionOpen = !this.isAccordionOpen;
    }

}