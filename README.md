# GeoServer Docker

A [GeoServer](http://geoserver.org/) Docker Image with predefined extensions and CORS support.

GeoServer is an open source server for sharing geospatial data. Designed for interoperability, it publishes data from any major spatial data source using open standards.

## Run as container

By running

```shell
docker run -p 18080:8080 meggsimum/geoserver:2.16.0
```

you'll get a cleaned standard GeoServer, which can be accessed by http://localhost:18080/geoserver


## CORS SUPPORT

This Docker Image allows to run GeoServer with CORS
([Cross-Origin Resource Sharing](https://en.wikipedia.org/wiki/Cross-origin_resource_sharing)) support.

In order to enable CORS for your GeoServer container the environment variable
`USE_CORS` can be used.

By running

```shell
docker run -e USE_CORS=1 -p 18080:8080 meggsimum/geoserver:2.16.0
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
docker run -e USE_WPS=1 -e USE_VECTOR_TILES=1 -p 18080:8080 meggsimum/geoserver:2.15.2
```

you'll get a GeoServer with installed and activated WPS and Vector Tiles extension.

## Credits
This GeoServer Docker Image was heavily inspired by the one here: https://github.com/terrestris/docker-geoserver/ of the [terrestris](https://github.com/terrestris) organization. Thank you!

Also a big thank you to the fabulous [GeoServer project](http://geoserver.org) and its maintainers / contributors. GeoServer is excellent, you rock!  


