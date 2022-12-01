#!/bin/bash

######################################################
# Ensure GeoServer REST API returns status code 200  #
# otherwise exit with error code                     #
######################################################

STATUS_CODE=$(curl --user admin:geoserver -L -s -o /dev/null -w "%{http_code}"  http://localhost:8080/geoserver/rest)

echo "Requesting GeoServer REST API"
echo "Status code is: ${STATUS_CODE}"

if [ "${STATUS_CODE}" -eq 200 ]
then
  echo "GeoServer REST API exists";
else
  echo "GeoServer RESZ API cannot be found"
  exit 1
fi
