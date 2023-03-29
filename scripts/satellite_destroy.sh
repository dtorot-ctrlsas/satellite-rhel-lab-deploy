#!/bin/bash


ORG="Satellite Corp"
echo "Delete lifecycle environtment..."
ENVIRONMENTS="Development QA Production Stage"
MAIN_ORG_ID=$(hammer --output=json organization list | grep "Id" | grep -v '"Id": 1,' | awk '{print $2}' | tr -d ,)

for ENV in ${ENVIRONMENTS}
do
        hammer lifecycle-environment delete --organization "$ORG" --name $ENV
done

echo "Delete locations..."
LOCATIONS=$(hammer --output=json location list | grep "Id" | grep -v '"Id": 2,' | awk '{print $2}' | tr -d ,)

hammer location list
for LOC_ID in ${LOCATIONS}
do
        hammer location delete --id $LOC_ID
done

echo "Delete manifest..."
hammer subscription delete-manifest --organization-id $MAIN_ORG_ID

echo "Delete organization..."
hammer organization list
hammer organization delete --id $MAIN_ORG_ID

rm -rf manifest_finance.zip


