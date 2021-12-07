import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getSkills from '@salesforce/apex/SallaryPredictorController.getSkills';
import getPrediction from '@salesforce/apex/SallaryPredictorController.getPrediction';

export default class SallaryPredictor extends LightningElement {

    earnings;
    skills = [];

    get advancementsLevel() {
        return [
            { label: 'Junior', value: 'Junior' },
            { label: 'Mid', value: 'Mid' },
            { label: 'Senior', value: 'Senior' }
        ];
    }

    @track firstStep = true;
    @track secondStep = false;
    @track thirdStep = false;
    @track skillList = [{name: 'Skill:', type: '', rate: '', index: this.index}]
    @track overLimit = false;
    @track isOneSkill = true;
    @track advancementLevel;

    index = 0;

    connectedCallback () {
        getSkills().then(result =>{this.skills = result})
    }

    handleAdd () {
        const skill = {name: 'Skill:', type: '', rate: '', index: this.index}
        this.skillList.push(skill)
        this.isOneSkill = false;
        this.index++
        if (this.skillList.length == 10){
            this.overLimit = true;
        }
    }

    handleRemove (event) {
        this.overLimit = false;
        this.skillList = this.skillList.filter(skill => skill.index !== event.target.value);
        if(this.skillList.length == 1) {
            this.isOneSkill = true
        }
    }

    choseSkill (event) {
        this.skillList[event.target.dataset.item].type = event.target.value;
    }

    choseAdvancement (event) {
        this.skillList[event.target.dataset.item].rate = event.target.value;
    }

    choseAdvancementLevel (event) {
        this.choseAdvancementLevel = event.target.value;
    }


    handleSearch () {
        this.firstStep = false
        this.secondStep = true;

        getPrediction({skills : this.skillList, advancementLevel : this.advancementLevel})
        .then(result => {
            this.secondStep = false
            this.thirdStep = true
            this.earnings = result
        })
    }

    handleRedirect() {
        window.location.replace('https://justjoin.it/')
    }

}