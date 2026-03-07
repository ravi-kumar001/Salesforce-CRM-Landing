import { LightningElement, wire, api, track } from "lwc";
import { generateUrl } from "lightning/fileDownload";
import getFileIds from "@salesforce/apex/FileController.getFileIds";

export default class LwrDownloadExample extends LightningElement {
    @api recordId = '001g500000BGGUBAA5';
    @track recordIds = [];
    error;

    connectedCallback() {
        console.log("recordId:", this.recordId);
    }

    @wire(getFileIds, { recordId: "$recordId" })
    wiredFieldIds({ data, error }) {
        if (data) {
            console.log("Files:", data);
            this.recordIds = data;
        } else if (error) {
            console.error("Wire error:", error);
            this.error = error;
        }
    }

    async handleDownload() {
        console.log("recordIds:", this.recordIds);
        if (!this.recordIds || this.recordIds.length === 0) {
            return;
        }
        for (let fileId of this.recordIds) {
            try {
                const url = await generateUrl(fileId);
                window.open(url, "_blank");
                await new Promise((resolve) => setTimeout(resolve, 500));
            } catch (err) {
                console.error("Download error:", err);
            }
        }
    }
}
