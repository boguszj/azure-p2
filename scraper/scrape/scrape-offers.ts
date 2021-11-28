import axios, {AxiosResponse} from 'axios';
import {Offer, RawEmployment, RawExperienceLevel, RawOffer, RawSkill, Salary, Skills} from "./types";
import {MAX_SALARY_SUFFIX, MIN_SALARY_SUFFIX, OFFERS_URL} from "./constants";

export const scrapeOffers = async () => {

    const response = await axios.get<RawOffer[]>(OFFERS_URL);
    if (response.status === 200) {
        return getOffers(response);
    } else {
        throw new OffersSourceNotAvailableException(response);
    }

}

const getOffers = async (response: AxiosResponse<RawOffer[]>) => {
    return response.data
        .filter(isOfferInPln)
        .map(mapRawOffer);
}

const isOfferInPln = (rawOffer: RawOffer): boolean => !!rawOffer.employment_types.map(type => type.salary).find(salary => salary?.currency === 'pln');

const mapRawOffer = (rawOffer: RawOffer): Offer => ({
    id: rawOffer.id,
    experienceLevel: getExperienceLevel(rawOffer.experience_level),
    ...mapSkill(rawOffer.skills),
    ...mapEmploymentTypes(rawOffer.employment_types)
});

const mapSkill = (rawSkills: RawSkill[]): Record<string, number> => {
    const skills: Skills = {};
    rawSkills.forEach(rawSkill => skills[rawSkill.name] = rawSkill.level)
    return skills;
}

const mapEmploymentTypes = (employmentTypes: RawEmployment[]): Record<string, number> => {
    const salary: Salary = {};
    employmentTypes.forEach(employmentType => {
        const minName = employmentType.type + MIN_SALARY_SUFFIX;
        const maxName = employmentType.type + MAX_SALARY_SUFFIX;
        salary[minName] = employmentType.salary.from;
        salary[maxName] = employmentType.salary.to;
    })
    return salary;
}

const getExperienceLevel = (experienceLevel: RawExperienceLevel) => {
    switch (experienceLevel) {
        case "junior": return 1;
        case "mid": return 2;
        case "senior": return 3;
    }
}

class OffersSourceNotAvailableException extends Error {

    constructor(response: AxiosResponse) {
        super(JSON.stringify(response));
    }

}
