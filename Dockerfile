# Use a tomcat image of terrestris as parent
FROM terrestris/tomcat:8.5.37

# The GS_VERSION argument could be used like this to overwrite the default:
# docker build --build-arg GS_VERSION=2.17.3 -t meggsimum/geoserver:2.17.3 .
ARG GS_VERSION=2.20.5
ARG GS_DATA_PATH=./geoserver_data/
ARG ADDITIONAL_LIBS_PATH=./additional_libs/

# Environment variables
ENV GEOSERVER_VERSION=$GS_VERSION
ENV MARLIN_TAG=0_9_3
ENV MARLIN_VERSION=0.9.3
ENV GEOSERVER_DATA_DIR=/opt/geoserver_data/
ENV GEOSERVER_LIB_DIR=$CATALINA_HOME/webapps/geoserver/WEB-INF/lib/
ENV EXTRA_JAVA_OPTS="-Xms256m -Xmx1g"
ENV USE_VECTOR_TILES=0
ENV USE_WPS=0
ENV USE_CORS=0
ENV UPDATE_CREDENTIALS=1

# see http://docs.geoserver.org/stable/en/user/production/container.html
ENV CATALINA_OPTS="\$EXTRA_JAVA_OPTS -Dfile.encoding=UTF-8 -D-XX:SoftRefLRUPolicyMSPerMB=36000 -Xbootclasspath/a:$CATALINA_HOME/lib/marlin.jar -Xbootclasspath/p:$CATALINA_HOME/lib/marlin-sun-java2d.jar -Dsun.java2d.renderer=org.marlin.pisces.PiscesRenderingEngine -Dorg.geotools.coverage.jaiext.enabled=true"

WORKDIR /tmp

# init
RUN apk -U upgrade --update && \
    apk add curl && \
    apk add openssl && \
    apk add libressl2.7-libcrypto && \
    apk add nss && \
    apk add zip && \
    apk add \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --allow-untrusted \
    gdal

# clenaup webapps
RUN rm -rf $CATALINA_HOME/webapps/*

# install geoserver
RUN curl -jkSL -o /tmp/geoserver.zip http://downloads.sourceforge.net/project/geoserver/GeoServer/$GEOSERVER_VERSION/geoserver-$GEOSERVER_VERSION-war.zip && \
    unzip geoserver.zip geoserver.war -d $CATALINA_HOME/webapps && \
    mkdir -p $CATALINA_HOME/webapps/geoserver && \
    unzip -q $CATALINA_HOME/webapps/geoserver.war -d $CATALINA_HOME/webapps/geoserver && \
    rm $CATALINA_HOME/webapps/geoserver.war && \
    mkdir -p $GEOSERVER_DATA_DIR

WORKDIR /tmp

COPY $GS_DATA_PATH $GEOSERVER_DATA_DIR
COPY $ADDITIONAL_LIBS_PATH $GEOSERVER_LIB_DIR

# install java advanced imaging
RUN wget https://download.java.net/media/jai/builds/release/1_1_3/jai-1_1_3-lib-linux-amd64.tar.gz && \
    wget https://download.java.net/media/jai-imageio/builds/release/1.1/jai_imageio-1_1-lib-linux-amd64.tar.gz && \
    gunzip -c jai-1_1_3-lib-linux-amd64.tar.gz | tar xf - && \
    gunzip -c jai_imageio-1_1-lib-linux-amd64.tar.gz | tar xf - && \
    mv /tmp/jai-1_1_3/lib/*.jar $JAVA_HOME/jre/lib/ext/ && \
    mv /tmp/jai-1_1_3/lib/*.so $JAVA_HOME/jre/lib/amd64/ && \
    mv /tmp/jai_imageio-1_1/lib/*.jar $JAVA_HOME/jre/lib/ext/ && \
    mv /tmp/jai_imageio-1_1/lib/*.so $JAVA_HOME/jre/lib/amd64/

# uninstall JAI default installation from geoserver to avoid classpath conflicts
# see http://docs.geoserver.org/latest/en/user/production/java.html#install-native-jai-and-imageio-extensions
WORKDIR $GEOSERVER_LIB_DIR
RUN rm jai_core-*jar jai_imageio-*.jar jai_codec-*.jar

# install marlin renderer
RUN curl -jkSL -o $CATALINA_HOME/lib/marlin.jar https://github.com/bourgesl/marlin-renderer/releases/download/v$MARLIN_TAG/marlin-$MARLIN_VERSION-Unsafe.jar && \
    curl -jkSL -o $CATALINA_HOME/lib/marlin-sun-java2d.jar https://github.com/bourgesl/marlin-renderer/releases/download/v$MARLIN_TAG/marlin-$MARLIN_VERSION-Unsafe-sun-java2d.jar

###
# download the predefined GS plugins for this image
###
ARG EXTENSIONS_PATH=/opt/extensions/

# VECTOR TILES
ARG VT_NAME=vectortiles
ARG VT_ZIP_NAME=geoserver-$GEOSERVER_VERSION-$VT_NAME-plugin.zip
ARG VT_EXTENSION_PATH=$EXTENSIONS_PATH$VT_NAME

RUN wget --no-check-certificate https://sourceforge.net/projects/geoserver/files/GeoServer/$GEOSERVER_VERSION/extensions/$VT_ZIP_NAME && \
    mkdir -p $VT_EXTENSION_PATH && \
    unzip ./geoserver-$GEOSERVER_VERSION-vectortiles-plugin.zip -d ./$VT_NAME && \
    mv ./$VT_NAME/*.jar $VT_EXTENSION_PATH

# WPS
ARG WPS_NAME=wps
ARG WPS_ZIP_NAME=geoserver-$GEOSERVER_VERSION-$WPS_NAME-plugin.zip
ARG WPS_EXTENSION_PATH=$EXTENSIONS_PATH$WPS_NAME

RUN wget --no-check-certificate https://sourceforge.net/projects/geoserver/files/GeoServer/$GEOSERVER_VERSION/extensions/$WPS_ZIP_NAME && \
    mkdir -p $WPS_EXTENSION_PATH && \
    unzip ./$WPS_ZIP_NAME -d ./$WPS_NAME && \
    mv ./$WPS_NAME/*.jar $WPS_EXTENSION_PATH

# cleanup
RUN apk del curl && \
    rm -rf /tmp/* /var/cache/apk/*

# add web.xml with CORS enabled
COPY web-cors-enabled.xml /opt/web-cors-enabled.xml

COPY startup.sh /opt/startup.sh
RUN chmod +x /opt/startup.sh

COPY update_credentials.sh /opt/update_credentials.sh
RUN chmod +x /opt/update_credentials.sh

ENTRYPOINT /opt/startup.sh

WORKDIR /opt
