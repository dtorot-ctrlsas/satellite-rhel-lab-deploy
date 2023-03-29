#!/bin/bash
#https://codeshare.io --> el lab permite hacer paste online aqui


PASSWD="redhat"
USER="admin"
ORG="Satellite Corp"
LOCATIONS="ElCabo Guajira Brasilia Canarias"
ENVIRONMENTS="Development QA Production Stage"

echo "Create the $ORG organization..."
hammer organization create --name "${ORG}" --description "Satellite Lab Test Organization"
hammer organization list
MAIN_ORG_ID=$(hammer --output=json organization list | grep "Id" | grep -v '"Id": 1,' | awk '{print $2}' | tr -d ,)

echo "Create the $LOCATIONS locations"
for LOC in ${LOCATIONS}
do
        hammer location create --name "${LOC}"
        hammer location add-organization --name "${LOC}" --organization "${ORG}"
done
hammer location list

echo "Download manifest"
rm -rf manifest_finance.zip
wget http://materials.example.com/manifest_finance.zip

echo "Import manifest"
hammer -u $USER -p $PASSWD subscription upload --file manifest_finance.zip --organization-id $MAIN_ORG_ID

echo "Create life-cycle environment..."
ENV_PRIOR="Library"
for ENV in ${ENVIRONMENTS}
do
        hammer lifecycle-environment create --organization "$ORG" --name $ENV --prior $ENV_PRIOR
        ENV_PRIOR=$ENV
done
hammer lifecycle-environment list --organization "$ORG"


echo "Healthcheck..."
satellite-maintain service list
satellite-maintain health check
firewall-cmd --list-all
systemctl status chronyd
ping -c1 satellite.lab.example.com


