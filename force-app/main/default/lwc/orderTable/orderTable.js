import { LightningElement, track, wire } from 'lwc';
import getOrderRecord from '@salesforce/apex/GetOrderRecord.getOrderRecord';

export default class OrdersTable extends LightningElement {

    @track hoveredColumn = null;

    showIcon(event) {
        this.hoveredColumn = event.currentTarget.dataset.col;
    }

    hideIcon() {
        this.hoveredColumn = null;
    }

    get isOrderNumberHover() {
        return this.hoveredColumn === 'orderNumber';
    }

    get isAccountNameHover() {
        return this.hoveredColumn === 'accountName';
    }

    get isOrderAmountHover() {
        return this.hoveredColumn === 'orderAmount';
    }

    get isStartDateHover() {
        return this.hoveredColumn === 'startDate';
    }

    get isStatusHover() {
        return this.hoveredColumn === 'status';
    }

    get isContractHover() {
        return this.hoveredColumn === 'contractNumber';
    }

    orders = [];
    error;

    @wire(getOrderRecord)
    wiredOrders(result) {
        const { error, data } = result;
        console.log("Record", data);
        if (data) {
            this.orders = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.orders = [];
        }
    }

    get computedOrders() {
        return this.orders.map((order, index) => {
            return {
                ...order,
                rowNumber: index + 1
            };
        });
    }
}