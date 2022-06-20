# GeoServer Docker

A [GeoServer](http://geoserver.org/) Docker Image with predefined extensions and CORS support.

GeoServer is an open source server for sharing geospatial data. Designed for interoperability, it publishes data from any major spatial data source using open standards.

## Run as container

By running

```shell
docker run -p 18080:8080 meggsimum/geoserver:2.19.3
```

you'll get a cleaned standard GeoServer (Version 2.19.3), which can be accessed by http://localhost:18080/geoserver

### Supported ENV VARs

  - `USE_CORS=1` (0/1)
  - `USE_WPS=1` (0/1)
  - `USE_VECTOR_TILES=1` (0/1)
  - `USE_IMG_MOSAIC=1` (0/1)
  - `APP_PATH_PREFIX="my#deploy#path#"` (any string compliant to [Tomcat context path naming](https://tomcat.apache.org/tomcat-8.0-doc/config/context.html) )
  - `GEOSERVER_ADMIN_USER` (String - supported since 2.19.x)
  - `GEOSERVER_ADMIN_PASSWORD` (String - supported since 2.19.x)

For detailed information check the sections below.


## CORS Support

This Docker Image allows to run GeoServer with CORS
([Cross-Origin Resource Sharing](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing)) support.

In order to enable CORS for your GeoServer container the environment variable
`USE_CORS` can be used.

By running

```shell
docker run -e USE_CORS=1 -p 18080:8080 meggsimum/geoserver:2.19.3
```

you'll get a GeoServer with CORS enabled.

## Shipped Extensions

This Docker Image comes with several extensions which are bundled in:

  - WPS
  - Vector Tiles
  - Imagemosaic JDBC

These extensions can be activated by the following environment variables:

  - `USE_WPS=1`
  - `USE_VECTOR_TILES=1`
  - `USE_IMG_MOSAIC=1`

By running

```shell
docker run -e USE_WPS=1 -e USE_VECTOR_TILES=1 -p 18080:8080 meggsimum/geoserver:2.19.3
```

you'll get a GeoServer with installed and activated WPS and Vector Tiles extension.

## Change Deployment Path

This Docker Image allows to deploy GeoServer under a given path instead of always being hosted under /geoserver.

The path is defined in the environment variable `APP_PATH_PREFIX` in
the form `foo#bar#`, which leads the application being
hosted under `/foo/bar/geoserver/`. If the env var is not set the
GeoServer will be hosted under `/geoserver` as usual.

By running

```shell
docker run -e APP_PATH_PREFIX="foo#bar#" -p 18080:8080 meggsimum/geoserver:2.19.3
```

you'll get the GeoServer deployed at http://localhost:18080/foo/bar/geoserver/.

## Change Admin Credentials

In order to have individual admin credentials in your running container the environment variables `GEOSERVER_ADMIN_USER` and `GEOSERVER_ADMIN_PASSWORD` can be set:

```shell
docker run -e GEOSERVER_ADMIN_USER=peter -e GEOSERVER_ADMIN_PASSWORD=abcd -p 18080:8080 meggsimum/geoserver:2.19.3
```

## Set Log Level and Standard Out Logging

These logging profiles(log levels) are available out of the box: `DEFAULT`, `PRODUCTION`, `QUIET`, `VERBOSE`

The environment variable `GEOSERVER_LOG_LEVEL` defines the log level of GeoServer.

```shell
docker run -e GEOSERVER_LOG_LEVEL=PRODUCTION -p 18080:8080 meggsimum/geoserver:2.19.3
```

It is possible to use custom logging profiles by adding them to the `logs` directory within the GeoServer data directory. The filename must match the pattern `PETER_LOGGING.properties`. This profile would then be activated by setting the environment variable `GEOSERVER_LOG_LEVEL=PETER`.

The environment variable `USE_STD_OUT_LOGGING` defines if logging should be done to standard out.

```shell
# example how to deactivate logging to standard out
docker run -e USE_STD_OUT_LOGGING=0 -p 18080:8080 meggsimum/geoserver:2.19.3
```

## Build this Image

```shell
cd /path/to/this/repository/
docker build -t {YOUR_TAG} .
```

## Credits
This GeoServer Docker Image was heavily inspired by the one here: https://github.com/terrestris/docker-geoserver/ of the [terrestris](https://github.com/terrestris) organization. Thank you!

Also a big thank you to the fabulous [GeoServer project](http://geoserver.org) and its maintainers / contributors. GeoServer is excellent, you rock!
