import { AzureFunction, Context } from "@azure/functions"
import {scrapeOffers} from "./scrape-offers";
import {saveOffers} from "./save-offers";

const timerTrigger: AzureFunction = async function (context: Context): Promise<void> {
    context.log('Scraping offers...');
    const offers = await scrapeOffers();
    context.log('Saving offers...');
    await saveOffers(offers);
    context.log('Offers saved');
};

export default timerTrigger;
