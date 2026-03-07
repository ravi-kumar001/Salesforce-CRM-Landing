import { LightningElement, api } from 'lwc';
import getRecordImageAsBase64 from '@salesforce/apex/ImageController.getRecordImageAsBase64';

export default class FileUpload extends LightningElement {

    @api recordId;
    myImageUrl;
    card = false;

    get acceptedFormats() {
        return ['.png', '.jpg', '.jpeg'];
    }

    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        this.recordId = uploadedFiles[0].recordId;
        console.log('Files uploaded: ', uploadedFiles);

        setTimeout(() => {
            this.loadImage();
            console.log('image url: ', this.myImageUrl);
        }, 1000);
    }

    loadImage() {
        getRecordImageAsBase64({ recordId: this.recordId })
            .then(result => {
                this.myImageUrl = result;
                this.card = true;
            })
            .catch(error => {
                console.error(error);
            });
    }
}