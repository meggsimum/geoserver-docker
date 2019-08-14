#!/bin/sh

ADDITIONAL_LIBS_DIR=/opt/additional_libs/

# path to default extensions stored in image
EXTENSIONS_PATH=/opt/extensions/
VT_PLUGIN_PATH=$EXTENSIONS_PATH"vectortiles"
WPS_PLUGIN_PATH=$EXTENSIONS_PATH"wps"
IMG_MOSAIC_PLUGIN_PATH=$EXTENSIONS_PATH"imagemosaic-jdbc"

# VECTOR TILES
if [ "$USE_VECTOR_TILES" == 1 ]; then
  echo "Copy Vector Tiles extension to our GeoServer lib directory";
  ls -la $VT_PLUGIN_PATH
  cp $VT_PLUGIN_PATH/*.jar $CATALINA_HOME/webapps/geoserver/WEB-INF/lib/
fi
# WPS
if [ "$USE_WPS" == 1 ]; then
  echo "Copy WPS extension to our GeoServer lib directory";
  ls -la $WPS_PLUGIN_PATH
  cp $WPS_PLUGIN_PATH/*.jar $CATALINA_HOME/webapps/geoserver/WEB-INF/lib/
fi
# IMAGE MOSAIC JDBC
if [ "$USE_IMG_MOSAIC" == 1 ]; then
  echo "Copy Imagemosaic JDBC extension to our GeoServer lib directory";
  ls -la $IMG_MOSAIC_PLUGIN_PATH
  cp $IMG_MOSAIC_PLUGIN_PATH/*.jar $CATALINA_HOME/webapps/geoserver/WEB-INF/lib/
fi

# copy additional geoserver libs before starting the tomcat
if [ -d "$ADDITIONAL_LIBS_DIR" ]; then
    cp $ADDITIONAL_LIBS_DIR/*.jar $CATALINA_HOME/webapps/geoserver/WEB-INF/lib/
fi

# start the tomcat
$CATALINA_HOME/bin/catalina.sh run
