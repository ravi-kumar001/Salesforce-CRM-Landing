import { LightningElement, track } from 'lwc';
import searchProduct from '@salesforce/apex/JobCardController.searchProduct';
import createJobCard from '@salesforce/apex/JobCardController.createJobCard';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class JobCard extends LightningElement {

    step = "1";

    chassisNo = 'RFBW00525';
    tractorModel = '';
    runningHours = 44;
    hourMeter = 'YES';

    products = [];

    buttonLabel = 'Next';

    fuelOptions = [
        { label: 'Select', value: '' },
        { label: 'Low', value: 'low' },
        { label: 'Medium', value: 'medium' },
        { label: 'Full', value: 'full' }
    ];

    serviceCheckpoints = [
        {
            id: 1,
            serial: 1,
            checkpoint: "Company Sealings",
            category: "Hydraulics",
            recommendation: "Not Good",
            status: "OK"
        }
    ];

    columns = [
        { label: 'S.No.', fieldName: 'serial' },
        { label: 'Checkpoint', fieldName: 'checkpoint' },
        { label: 'Category', fieldName: 'category' },
        { label: 'Recommendation', fieldName: 'recommendation' },
        { label: 'Status', fieldName: 'status' }
    ];

    get isStepOne() {
        return this.step === "1";
    }

    get isStepTwo() {
        return this.step === "2";
    }

    get isStepThree() {
        return this.step === "3";
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

        } else if (this.step === "2") {
            this.step = "3";
            this.buttonLabelHandler();

        } else if (this.step === "3") {
            this.saveJobCard();
        }
    }

    handleBack() {
        if (this.step === "3") {
            this.step = "2";
            this.buttonLabelHandler();
        } else if (this.step === "2") {
            this.step = "1";
        }
    }

    buttonLabelHandler() {
        if (this.step === "2") {
            this.buttonLabel = 'Next';
        } else if (this.step === "3") {
            this.buttonLabel = 'Proceed Job Card';
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

    additionalRepair;
    estimatedAmount;
    deliveryDateTime;

    handleRepairChange(event) {
        this.additionalRepair = event.target.value;
    }

    handleEstimateAmount(event) {
        this.estimatedAmount = event.target.value;
    }

    handleDeliveryDate(event) {
        this.deliveryDateTime = event.target.value;
    }

    saveJobCard() {
        createJobCard({
            chassisNo: this.chassisNo,
            tractorModel: this.tractorModel,
            runningHours: this.runningHours,
            hourMeter: this.hourMeter,
            additionalRepair: this.additionalRepair,
            estimatedAmount: this.estimatedAmount,
            deliveryDateTime: this.deliveryDateTime
        })
            .then(result => {

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Job Card Created Successfully',
                        variant: 'success'
                    })
                );

                console.log('Created Job Card Id: ' + result);

            })
            .catch(error => {
                console.error(error);

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Error creating Job Card',
                        variant: 'error'
                    })
                );
            });
    }
}