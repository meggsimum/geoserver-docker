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
# IMAGE MOSAIC JDBC
if [ "$USE_IMG_MOSAIC" == 1 ]; then
  echo "Copy Imagemosaic JDBC extension to our GeoServer lib directory";
  ls -la $IMG_MOSAIC_PLUGIN_PATH
  cp $IMG_MOSAIC_PLUGIN_PATH/*.jar $CATALINA_HOME/webapps/$APP_PATH_PREFIX"geoserver/WEB-INF/lib/"
fi

# copy additional geoserver libs before starting the tomcat
if [ -d "$ADDITIONAL_LIBS_DIR" ]; then
    cp $ADDITIONAL_LIBS_DIR/*.jar $CATALINA_HOME/webapps/$APP_PATH_PREFIX"geoserver/WEB-INF/lib/"
fi

# logging level
# inspired by Kartoza GeoServer Docker image
# https://github.com/kartoza/docker-geoserver/blob/f40770a5bbb4f29dc0d107a05aafb5f0da09164a/scripts/functions.sh#L269-L276

echo "Applying logging level and usage of standard out of logs"

STD_OUT_LOGGING_VALUE=false
if [ "${USE_STD_OUT_LOGGING}" == 1 ]; then
  STD_OUT_LOGGING_VALUE=true
fi

echo "<logging>
  <level>${GEOSERVER_LOG_LEVEL}_LOGGING.properties</level>
  <stdOutLogging>${STD_OUT_LOGGING_VALUE}</stdOutLogging>
</logging>" > "${GEOSERVER_DATA_DIR}"/logging.xml

echo "Set log level to ${GEOSERVER_LOG_LEVEL}"

# No RCE Log4J Jar (see http://geoserver.org/announcements/2021/12/13/logj4-rce-statement.html)
if [ "$USE_NORCE_LOG4J_JAR" == 1 ]; then
  echo "Using the patched norce log4j 1.2.17 jar";
  # remove malicious log4j-1.2.17.jar
  rm $CATALINA_HOME/webapps/$APP_PATH_PREFIX"geoserver/WEB-INF/lib/log4j-1.2.17.jar"
  # download and install patched log4j jar file into lib folder
  wget --no-check-certificate -P $CATALINA_HOME/webapps/$APP_PATH_PREFIX"geoserver/WEB-INF/lib/" https://repo.osgeo.org/repository/geotools-releases/log4j/log4j/1.2.17.norce/log4j-1.2.17.norce.jar
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
