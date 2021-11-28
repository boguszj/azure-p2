export interface RawOffer {
    id: string;
    experience_level: RawExperienceLevel;
    skills: RawSkill[];
    employment_types: RawEmployment[];
}

export interface RawSkill {
    name: string;
    level: number;
}

export interface RawEmployment {
    type: string;
    salary: RawSalary;
}

export interface RawSalary {
    from: number;
    to: number;
    currency: Currency;
}

export type RawExperienceLevel = 'junior' | 'mid' | 'senior';

export type Currency = 'pln' | 'usd';

export interface Offer {
    id: string;
    experienceLevel: number;
    [skillName: string]: number | string;
}

export type Skills = Record<string, number>;

export type Salary = Record<string, number>;