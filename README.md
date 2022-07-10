A server app built using [Shelf](https://pub.dev/packages/shelf) and hosting a database [Isar](https://pub.dev/packages/isar),
configured to enable running with [Docker](https://www.docker.com/).

This sample code handles HTTP GET requests to `/user/`, HTTP POST `/user/` AND HTTP DELETE `/user/name`

# Running the sample

## Running with the Dart SDK

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

```
$ dart run bin/server.dart
Server listening on port 8080
```

And then open your browser:
```
$ http://0.0.0.0:8080/user/
```

## Running with Docker

If you have [Docker Desktop](https://www.docker.com/get-started) installed, you
can build and run with the `docker` command:

```
$ docker build . -t myserver
$ docker run -it -p 8080:8080 myserver
Server listening on port 8080
```

You should see the logging printed in the first terminal:
```
2021-05-06T15:47:04.620417  0:00:00.000158 GET     [200] /
2021-05-06T15:47:08.392928  0:00:00.001216 GET     [200] /user/
```
