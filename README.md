# GeoServer Docker

A [GeoServer](http://geoserver.org/) Docker Image with predefined extensions and CORS support.

GeoServer is an open source server for sharing geospatial data. Designed for interoperability, it publishes data from any major spatial data source using open standards.

## Run as container

By running

```shell
docker run -p 8080:8080 meggsimum/geoserver:2.19.3
```

you'll get a cleaned standard GeoServer (Version 2.19.3), which can be accessed by http://localhost:8080/geoserver

### Supported ENV VARs

  - `USE_CORS=1` (0/1) Default is `0`
  - `USE_WPS=1` (0/1) Default is `0`
  - `USE_VECTOR_TILES=1` (0/1) Default is `0`
  - `APP_PATH_PREFIX="my#deploy#path#"` (any string compliant to [Tomcat context path naming](https://tomcat.apache.org/tomcat-8.0-doc/config/context.html) )
  - `GEOSERVER_ADMIN_USER` (String - supported since 2.19.x) Default is `admin`
  - `GEOSERVER_ADMIN_PASSWORD` (String - supported since 2.19.x) Default is `geoserver`
  - `UPDATE_CREDENTIALS` (0/1) If the credentials shall be updated on startup. Default is `0`

For detailed information check the sections below.

## Use a Volume

The `geoserver_data` directory can be mounted as volume on the host system.

```shell
docker run -p 8080:8080 -v $(pwd)/geoserver_data:/opt/geoserver_data meggsimum/geoserver
```

## CORS Support

This Docker Image allows to run GeoServer with CORS
([Cross-Origin Resource Sharing](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing)) support.

In order to enable CORS for your GeoServer container the environment variable
`USE_CORS` can be used.

By running

```shell
docker run -e USE_CORS=1 -p 8080:8080 meggsimum/geoserver
```

you'll get a GeoServer with CORS enabled.

## Shipped Extensions

This Docker Image comes with several extensions which are bundled in:

  - WPS
  - Vector Tiles

These extensions can be activated by the following environment variables:

  - `USE_WPS=1`
  - `USE_VECTOR_TILES=1`

By running

```shell
docker run -e USE_WPS=1 -e USE_VECTOR_TILES=1 -p 8080:8080 meggsimum/geoserver
```

you'll get a GeoServer with installed and activated WPS and Vector Tiles extension.

## Change Deployment Path

This Docker Image allows to deploy GeoServer under a given path instead of always being hosted under `/geoserver`.

The path is defined in the environment variable `APP_PATH_PREFIX` in
the form `foo#bar#`, which leads the application being
hosted under `/foo/bar/geoserver/`. If the env var is not set the
GeoServer will be hosted under `/geoserver` as usual.

By running

```shell
docker run -e APP_PATH_PREFIX="foo#bar#" -p 8080:8080 meggsimum/geoserver
```

you'll get the GeoServer deployed at http://localhost:8080/foo/bar/geoserver/.

## Change Admin Credentials

In order to have individual admin credentials in your running container the environment variables `GEOSERVER_ADMIN_USER` and `GEOSERVER_ADMIN_PASSWORD` can be set:

```shell
docker run -e GEOSERVER_ADMIN_USER=peter -e GEOSERVER_ADMIN_PASSWORD=abcd -p 8080:8080 meggsimum/geoserver
```

Setting `UPDATE_CREDENTIALS` to `0` does not update the credentials on startup. This is useful if an existing volume shall be mounted that already has credentials set up.

```shell
docker run -e UPDATE_CREDENTIALS=0 -v $(pwd)/geoserver_data:/opt/geoserver_data -p 8080:8080 meggsimum/geoserver:latest
```

## Set Log Level and Standard Out Logging

The environment variable `GEOSERVER_LOG_LEVEL` defines the log level of GeoServer. All predefined log levels of GeoServer are available. Default is `PRODUCTION`.

```shell
docker run -e GEOSERVER_LOG_LEVEL=PRODUCTION -p 18080:8080 meggsimum/geoserver:2.21.0
```

It is possible to use custom logging profiles by adding them to the `logs` directory within the GeoServer data directory. The filename must match the pattern `PETER_LOGGING.xml`. This profile would then be activated by setting the environment variable `GEOSERVER_LOG_LEVEL=PETER`.

The environment variable `USE_STD_OUT_LOGGING` defines if logging should be done to standard out.

```shell
# example how to deactivate logging to standard out
docker run -e USE_STD_OUT_LOGGING=0 -p 18080:8080 meggsimum/geoserver:2.21.0
```

Note that starting from GeoServer version 2.21 the logging has been written completely new. If you update from older GeoServer versions there might be adaptations necessary. More information are available in the changelog of GeoServer: https://geoserver.org/announcements/2022/05/24/geoserver-2-21-0-released.html#log4j-2-upgrade

## Build this Image

```shell
cd /path/to/this/repository/
docker build -t {YOUR_TAG} .
```

## Credits
This GeoServer Docker Image was heavily inspired by the one here: https://github.com/terrestris/docker-geoserver/ of the [terrestris](https://github.com/terrestris) organization. Thank you!

Also a big thank you to the fabulous [GeoServer project](http://geoserver.org) and its maintainers / contributors. GeoServer is excellent, you rock!
