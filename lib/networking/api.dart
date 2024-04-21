import 'dart:async';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../db/character.dart';

Future<List<Character>> fetchCharacters() async {
  //This function checks if theres data in the db and returns the stored characters if so.
  // Else, it fetches data from the API, stores them in the db and returns them.

  final box = Hive.box<Character>('charactersBox');

  if (box.isEmpty) {
    final characters = await _fetchCharactersFromApi();

    for (var character in characters) {
      box.add(character);
    }
    return characters;
  } else {
    return List<Character>.from(box.values);
  }
}

Future<List<Character>> _fetchCharactersFromApi() async {
  // Declere a list of characters to where we will store instances of the Character class
  final List<Character> listOfCharacter = [];

  // Declere a set to later check if names are repeated. Set is more efficent than lists.
  final Set<String> addedNames = {};

  // Page count to increase pagination of API
  int pageCount = 1;

  while (listOfCharacter.length < 100) {
    final response = await http.get(Uri.parse(
        'https://www.anapioficeandfire.com/api/characters?page=$pageCount&pageSize=50'));

    // If the server did return a 200 OK response,
    // then parse the JSON.
    if (response.statusCode == 200) {
      final characters = jsonDecode(response.body);

      // Iterate through each characters of the 50 we got from the JSON
      for (var char in characters) {
        //Check if character has name
        if (char['name'] != '' &&
            (char['aliases'] != null && char['aliases'].isNotEmpty)) {
          final name = char['name'];
          // Check if name is already in the list
          if (!addedNames.contains(name)) {
            addedNames.add(name);
            //print(char['name'] + ' ' + char['url'] + char['aliases']);
            print(char['name'] + ' ' + char['url']);
            // We instanciate a Character class and add them to the list
            listOfCharacter.add(Character.fromJson(char));
            // Stop fetching if got 50 characters
            if (listOfCharacter.length == 100) {
              print(listOfCharacter.length);
              break;
            }
          }
        }
      }
      pageCount++;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load characters');
    }
  }
  return listOfCharacter;
}
