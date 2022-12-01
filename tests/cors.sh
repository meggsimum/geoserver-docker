#!/bin/bash

###############################################
# Ensure GeoServer responds with CORS header, #
# otherwise exit with error code              #
###############################################

echo "Checking if GeoServer supports CORS"

LINES=$(curl --head -s 'http://localhost:8080/geoserver/ows?service=wfs&version=1.1.0&request=GetCapabilities' | grep -F -c "Access-Control-Allow-Origin: *")

if [ "${LINES}" -eq 1 ]
then
  echo "CORS Header exists";
  echo ""
else
  echo "CORS Header is missing"
  exit 1
fi
