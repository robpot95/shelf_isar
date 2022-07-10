import 'dart:convert';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../collections/user.dart';

class UserRestApi {
  const UserRestApi({required this.isar});

  final Isar isar;

  Handler get router {
    final Router router = Router();
    router.get("/", (Request request) async {
      // Retrive all users
      return Response.ok(
        jsonEncode({"users": await isar.users.where().findAll()}),
        headers: <String, String>{"Content-Type": ContentType.json.mimeType},
      );
    });

    router.post("/", (Request request) async {
      // Read the requests body and decode it
      final payload = await request.readAsString();
      final Map<String, dynamic> data = jsonDecode(payload);

      // Convert the json response to an object
      final user = User.fromJson(data);

      // Check if user exsist else add new user
      final getUser = await isar.users.getByName(user.name);
      if (getUser != null) {
        // Send back a json response of the POST
        return Response(
          HttpStatus.ok,
          body: jsonEncode(getUser),
          headers: <String, String>{"Content-Type": ContentType.json.mimeType},
        );
      } else {
        await isar.writeTxn(() async {
          await isar.users.put(user);
        });

        // Send back a json response of the POST
        final addedEntry = await isar.users.getByName(user.name);
        return Response(
          HttpStatus.created,
          body: jsonEncode(addedEntry),
          headers: <String, String>{"Content-Type": ContentType.json.mimeType},
        );
      }
    });

    router.delete("/<name|.+>", (Request request, String name) async {
      // Find user by name and delete
      final user = await isar.users.getByName(name);
      if (user != null) {
        await isar.writeTxn(() async => await isar.users.delete(user.id ?? 0));
        return Response.ok("Deleted $name");
      }

      return Response.notFound("User: $name not found.");
    });

    return router;
  }
}
