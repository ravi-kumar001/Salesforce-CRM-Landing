import { LightningElement, track } from 'lwc';
import searchProduct from '@salesforce/apex/JobCardController.searchProduct';
import createJobCard from '@salesforce/apex/JobCardController.createJobCard';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class JobCard extends LightningElement {

    step = "1";

    chassisNo = '';
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

    failureOptions = [
        { label: 'Select', value: '' },
        { label: 'Yes', value: 'yes' },
        { label: 'No', value: 'no' },
    ];

    jobCardType = [
        { label: 'Select', value: '' },
        { label: 'Product Quality', value: 'productQuality' },
        { label: 'Product Repair', value: 'productRepair' },
        { label: 'Product Replacement', value: 'productReplacement' },
        { label: 'Product Service', value: 'productService' },
        { label: 'Product Warranty', value: 'productWarranty' }
    ];

    jobCardLocation = [
        { label: 'Select', value: '' },
        { label: 'Workshop', value: 'workshop' },
        { label: 'Field', value: 'field' }
    ];

    isMobileView() {
        const mobileFields = this.template.querySelector('.mobile-upload');
        return mobileFields !== null;
    }

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

            if (!this.chassisNo || !this.runningHours) {
                this.showError('Please fill all mandatory fields');
                return;
            }

            const isMobile = window.innerWidth <= 768;

            if (isMobile && (!this.hourMeterFileData || !this.chassisFileData)) {
                this.showError('Please upload Hour Meter and Chassis Image');
                return;
            }

            this.step = "2";
        }

        else if (this.step === "2") {

            this.step = "3";
            this.buttonLabelHandler();

        }

        else if (this.step === "3") {

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

    hourMeterPreview;
    chassisPreview;
    hourMeterFileData;
    chassisFileData;

    openHourMeterUpload() {
        this.template.querySelector('[data-id="hourMeter"]').click();
    }

    openChassisUpload() {
        this.template.querySelector('[data-id="chassis"]').click();
    }

    handleHourMeterFile(event) {
        const file = event.target.files[0];

        if (file) {

            const reader = new FileReader();

            reader.onload = () => {

                let base64 = reader.result.split(',')[1];

                this.hourMeterPreview = reader.result;
                this.hourMeterFileData = base64;
            };

            reader.readAsDataURL(file);
        }
    }

    handleChassisFile(event) {

        const file = event.target.files[0];

        if (file) {

            const reader = new FileReader();

            reader.onload = () => {

                let base64 = reader.result.split(',')[1];

                this.chassisPreview = reader.result;
                this.chassisFileData = base64;
            };

            reader.readAsDataURL(file);
        }
    }

    showError(message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: message,
                variant: 'error'
            })
        );
    }

    saveJobCard() {
        createJobCard({

            chassisNo: this.chassisNo,
            tractorModel: this.tractorModel,
            runningHours: this.runningHours,
            hourMeter: this.hourMeter,

            hourMeterImage: this.hourMeterFileData,
            chassisImage: this.chassisFileData,

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