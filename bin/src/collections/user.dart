import 'package:isar/isar.dart';

part 'user.g.dart';

@Collection()
class User {
  User({
    this.name = "",
    this.age = 0,
  });

  Id? id;
  @Index(unique: true)
  final String name;
  final int age;

  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"] ?? "",
        age = json["age"] ?? 0;

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "age": age,
      };
}
