import {Offer} from "./types";
import {Parser} from 'json2csv';
import {BlobServiceClient} from '@azure/storage-blob';
import {BLOB_NAME, CONTAINER_NAME} from "./constants";

export const saveOffers = async (offers: Offer[]) => {
    const fields = Array.from(new Set(offers.flatMap(offer => Object.keys(offer))));
    const parser = new Parser({ fields });
    const csv = parser.parse(offers);
    const buffer = Buffer.from(csv, 'utf-8');
    const blobClient = getBlobClient();
    await blobClient.upload(buffer, buffer.length);
}

const getBlobClient = () => {
    const blobServiceClient = BlobServiceClient.fromConnectionString(process.env.AzureWebJobsStorage)
    const containerClient = blobServiceClient.getContainerClient(CONTAINER_NAME);
    return containerClient.getBlockBlobClient(BLOB_NAME);
}
