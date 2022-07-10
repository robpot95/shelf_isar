import 'dart:io';

import 'package:isar/isar.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';
import 'package:shelf_router/shelf_router.dart';

import 'src/collections/user.dart';
import 'src/rest_api/user_rest_api.dart';

void main(List<String> args) async {
  await Isar.initializeIsarCore(download: true);
  final isar = await Isar.open(
    <CollectionSchema>[UserSchema],
    directory: Directory.current.path,
  );

  final Router router = Router();

  // Create routes
  router.mount("/user/", UserRestApi(isar: isar).router);

  // Configure a pipeline that logs requests.
  final handler = Pipeline().addMiddleware(logRequests()).addMiddleware(corsHeaders()).addHandler(router);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  withHotreload(() => serve(handler, "localhost", port));
  print("Server ip: $ip - listening on port $port");
}
