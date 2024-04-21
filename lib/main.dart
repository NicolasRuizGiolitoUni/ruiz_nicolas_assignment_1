import 'package:ruiz_nicolas_assignment_1/db/character.dart';
import 'package:ruiz_nicolas_assignment_1/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  // Ensure that the flutter framework is initialized and binding to the
  // underlying platform before accessing specific underlying funcionalities
  WidgetsFlutterBinding.ensureInitialized();

  // Set a directory where the data will be stored.
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();

  // We initialize Hive to the defined directory
  Hive.init(appDocumentDir.path);

  //Register the Character adaptar that takes care of converting the classes
  // into bytes and viceversa to increase efficiency
  Hive.registerAdapter(CharacterAdapter());

  // Open the box
  await Hive.openBox<Character>('charactersBox');

  //debugPaintSizeEnabled = true;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String title = 'ApiApp';
    return MaterialApp(
        title: title,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // Always put MaterialApp in MyApp class to avoid context errors.
        home: const HomePage());
  }
}
