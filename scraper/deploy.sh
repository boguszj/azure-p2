#!/bin/bash

# COLOR DEFINITIONS

RED="\033[0;31m"
GREEN="\e[32m"
NC="\033[0m"

# FUNCTION DEFINITIONS

function printErrorMessage() {
  echo -e "${RED}${1}${NC}"
  exit 1
}

function printSuccessMessage() {
  echo -e "${GREEN}${1}${NC}"
}

# DEPENDENCY INSTALLATION CHECK

ZIP_INSTALLED=$(command -v jq)
if [ -z "${ZIP_INSTALLED}" ]; then
    printErrorMessage "Please install zip"
fi

JQ_INSTALLED=$(command -v jq)
if [ -z "${JQ_INSTALLED}" ]; then
    printErrorMessage "Please install jq"
fi

# VARIABLE DECLARATION

if [ -z "$2" ]; then
  echo "deploy.sh [resource group to create] [location]"
  exit 1
fi

RG_NAME=$(echo "${1}" | tr '[:upper:]' '[:lower:]')
LOCATION=$2
FUNCTION_APP_NAME="${RG_NAME}app"
STORAGE_ACCOUNT_NAME="${RG_NAME}storageaccount"
CONTAINER_NAME="offers"

# INPUT VALIDATION

if [[ ! "$RG_NAME" =~ ^[A-Za-z0-9]{0,8}$nl ]]; then
    printErrorMessage "Expected resource group name should match regex ^[A-Za-z0-9]{0,8}\$nl"
fi

# ALREADY INITIALIZED DETECTION

RG_ALREADY_EXISTS=$(
  az group exists \
    --name "${RG_NAME}"
)
if [ "${RG_ALREADY_EXISTS}" = "true" ]; then
  read -p "Resource group already exists, do you want to recreate it? " -n 1 -r
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
      az group delete \
        --name "${RG_NAME}" \
        --yes \
        --only-show-errors \
        2>&1 \
        1>/dev/null
      az group wait \
        --name "${RG_NAME}" \
        --deleted \
        --only-show-errors \
        2>&1 \
        1>/dev/null
      echo "Resource group deleted"
  else
    echo "Exiting..."
    exit 0
  fi
fi

# RG CREATION

echo "[1 / 5] Resource group creation: ${RG_NAME}"

ERROR_MESSAGE=$(
  az group create --location "${LOCATION}" \
                  --name "${RG_NAME}" \
                  --only-show-errors \
                  2>&1 \
                  1>/dev/null
)

if [ -z "${ERROR_MESSAGE}" ]; then
  printSuccessMessage "Resource group created"
else
  printErrorMessage "${ERROR_MESSAGE}"
fi

# STORAGE ACCOUNT CREATION

echo "[2 / 5] Creating storage account: ${STORAGE_ACCOUNT_NAME}"

ERROR_MESSAGE=$(
  az storage account create \
    --name "${STORAGE_ACCOUNT_NAME}" \
    --resource-group "${RG_NAME}" \
    --location "${LOCATION}" \
    --only-show-errors \
    2>&1 \
    1>/dev/null
)

if [ -z "${ERROR_MESSAGE}" ]; then
  printSuccessMessage "Storage account created"
else
  printErrorMessage "${ERROR_MESSAGE}"
fi

# STORAGE CONTAINER CREATION

echo "[3 / 5] Creating storage container: ${CONTAINER_NAME}"

ERROR_MESSAGE=$(
  az storage container create \
    --name "${CONTAINER_NAME}" \
    --account-name "${STORAGE_ACCOUNT_NAME}" \
    --resource-group "${RG_NAME}" \
    --only-show-errors \
    2>&1 \
    1>/dev/null
)

if [ -z "${ERROR_MESSAGE}" ]; then
  printSuccessMessage "Storage container created"
else
  printErrorMessage "${ERROR_MESSAGE}"
fi


# FUNCTION APP CREATION

echo "[4 / 5] Creating function app: ${FUNCTION_APP_NAME}"

ERROR_MESSAGE=$(
  az functionapp create \
    --name "${FUNCTION_APP_NAME}" \
    --resource-group "${RG_NAME}" \
    --storage-account "${STORAGE_ACCOUNT_NAME}" \
    --consumption-plan-location "${LOCATION}" \
    --functions-version 3 \
    --runtime node \
    --only-show-errors \
    2>&1 \
    1>/dev/null
)

if [ -z "${ERROR_MESSAGE}" ]; then
  printSuccessMessage "Function app created"
else
  printErrorMessage "${ERROR_MESSAGE}"
fi

# FUNCTION APP DEPLOYMENT

echo "[5 / 5] Deploying function app: ${FUNCTION_APP_NAME}"

ERROR_MESSAGE=$(
  npm i --silent && \
  npm run build --silent && \
  zip -qr scraper.zip . && \
  az functionapp deployment source config-zip \
    --resource-group "${RG_NAME}" \
    --name "${FUNCTION_APP_NAME}" \
    --src "scraper.zip" \
    --only-show-errors \
    2>&1 \
    1>/dev/null
)

if [ -z "${ERROR_MESSAGE}" ]; then
  printSuccessMessage "Function app deployed"
else
  printErrorMessage "${ERROR_MESSAGE}"
fi
