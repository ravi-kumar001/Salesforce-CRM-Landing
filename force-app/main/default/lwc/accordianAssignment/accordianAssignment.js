import { LightningElement, wire, track } from 'lwc';
import getAccountWithContact from '@salesforce/apex/Feb28AccordianClass.getAccountWithContact';
import deleteContact from '@salesforce/apex/Feb28AccordianClass.deleteContact';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AccordianForAccount extends LightningElement {
    accountToConMap = [];
    error;
    selectedContactId;
    showEditForm = false;

    actions = [
        { label: 'Edit', name: 'edit' },
        { label: 'Delete', name: 'delete' }
    ];

    get columns() {
        return [
            { label: 'FirstName', fieldName: 'FirstName', type: 'text' },
            { label: 'LastName', fieldName: 'LastName', type: 'text' },
            { label: 'Email', fieldName: 'Email', type: 'email' },
            { label: 'Phone', fieldName: 'Phone', type: 'phone' },
            {
                label: 'Actions',
                type: 'action',
                typeAttributes: { rowActions: this.actions }
            }
        ];
    }

    wiredResult;

    @wire(getAccountWithContact)
    wiredAccounts(result) {
        this.wiredResult = result;

        const { error, data } = result;

        if (data) {
            this.accountToConMap = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.accountToConMap = [];
        }
    }

    handleDelete(contactId) {
        deleteContact({ contactId: contactId })
            .then(result => {
                console.log('Contact deleted successfully');
                refreshApex(this.wiredResult);
            })
            .catch(error => {
                console.error('Error deleting contact', error);
            });
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;

        if (actionName === 'edit') {
            this.selectedContactId = row.Id;
            this.showEditForm = true;
        }

        if (actionName === 'delete') {
            console.log("called")
            this.handleDelete(row.Id);
        }
    }

    closeModal() {
        this.showEditForm = false;
        this.selectedContactId = null;
    }

    handleSuccess() {
        this.closeModal();
        refreshApex(this.wiredResult);
    }

    @track openAddContactModal = false;

    openAddContactModalHandler() {
        this.openAddContactModal = true;
    }

    handleNewContactCancel() {
        this.openAddContactModal = false;
    }

    handleNewContactSuccess(event) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Contact created successfully',
                variant: 'success'
            })
        );
        this.openAddContactModal = false;
        refreshApex(this.wiredResult);
    }
}