#!/bin/bash

###############################################
# Ensure GeoServer UI returns status code 200 #
# otherwise exit with error code              #
###############################################

STATUS_CODE=$(curl -L -s -o /dev/null -w "%{http_code}"  http://localhost:8080/geoserver)

echo "Requesting GeoServer UI"
echo "Status code is: ${STATUS_CODE}"

if [ "${STATUS_CODE}" -eq 200 ]
then
  echo "GeoServer UI exists"
else
  echo "GeoServer UI cannot be found"
  exit 1
fi
