import 'package:hive/hive.dart';

part 'character.g.dart';

@HiveType(typeId: 0)
class Character {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String gender;

  @HiveField(2)
  final List<String> aliases;

  const Character({
    required this.name,
    required this.gender,
    required this.aliases,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      aliases: List<String>.from(json['aliases']),
    );
  }
}
