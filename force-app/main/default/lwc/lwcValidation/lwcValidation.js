import { LightningElement } from 'lwc';

export default class LwcValidation extends LightningElement {

    testTheData() {
        let searchNameCmp = this.template.querySelector(".nameCmp");
        let searchDatecmp = this.template.querySelector(".dateCmp");

        let nameValue = searchNameCmp.value;
        let dateValue = searchDatecmp.value;
        if(nameValue == null || nameValue == '') {
            searchNameCmp.setCustomValidity("Please enter a valid name");
        } else {
            searchNameCmp.setCustomValidity("");
        }

        if(dateValue == null || dateValue == '') {
            searchDatecmp.setCustomValidity("Please enter a valid date");
        } else {
            searchDatecmp.setCustomValidity("");
        }

        searchNameCmp.reportValidity();
        searchDatecmp.reportValidity();
    }
}