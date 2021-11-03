#!/bin/sh

ADDITIONAL_LIBS_DIR=/opt/additional_libs/

# path to default extensions stored in image
EXTENSIONS_PATH=/opt/extensions/
VT_PLUGIN_PATH=$EXTENSIONS_PATH"vectortiles"
WPS_PLUGIN_PATH=$EXTENSIONS_PATH"wps"
IMG_MOSAIC_PLUGIN_PATH=$EXTENSIONS_PATH"imagemosaic-jdbc"

# adapt deployment path
if [[ $APP_PATH_PREFIX ]]; then  # var is set and it is not empty
   echo "Using app path prefix " $APP_PATH_PREFIX
   # move GeoServer installation to get a different deployment path
   # e.g. foo#bar#geoserver.war leads to /foo/bar/geoserver/
   mv $CATALINA_HOME/webapps/geoserver/ $CATALINA_HOME/webapps/$APP_PATH_PREFIX"geoserver/"
fi

# VECTOR TILES
if [ "$USE_VECTOR_TILES" == 1 ]; then
  echo "Copy Vector Tiles extension to our GeoServer lib directory";
  ls -la $VT_PLUGIN_PATH
  cp $VT_PLUGIN_PATH/*.jar $CATALINA_HOME/webapps/$APP_PATH_PREFIX"geoserver/WEB-INF/lib/"
fi
# WPS
if [ "$USE_WPS" == 1 ]; then
  echo "Copy WPS extension to our GeoServer lib directory";
  ls -la $WPS_PLUGIN_PATH
  cp $WPS_PLUGIN_PATH/*.jar $CATALINA_HOME/webapps/$APP_PATH_PREFIX"geoserver/WEB-INF/lib/"
fi

# copy additional geoserver libs before starting the tomcat
if [ -d "$ADDITIONAL_LIBS_DIR" ]; then
    cp $ADDITIONAL_LIBS_DIR/*.jar $CATALINA_HOME/webapps/$APP_PATH_PREFIX"geoserver/WEB-INF/lib/"
fi

# ENABLE CORS
if [ "$USE_CORS" == 1 ]; then
  echo "Enabling CORS for GeoServer"
  echo "Copy a modified web.xml to $CATALINA_HOME/geoserver/WEB-INF/";
  cp /opt/web-cors-enabled.xml $CATALINA_HOME/webapps/$APP_PATH_PREFIX"geoserver/WEB-INF/web.xml"
fi

# set credentials
/bin/sh /opt/update_credentials.sh

# start the tomcat
$CATALINA_HOME/bin/catalina.sh run
