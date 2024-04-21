import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ruiz_nicolas_assignment_1/db/character.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key, required this.character, required this.image});

  final String image;
  final Character character;

  void goBack(context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    String name = character.name;
    List<String> aliasesList = character.aliases;
    String gender = character.gender;

    String aliases = aliasesList.join(', ');

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            name,
            style: const TextStyle(fontFamily: 'Helvetica'),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        image,
                        height: 200,
                        width: 200,
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 20.0, left: 12, right: 12),
                      child: Column(
                        children: [
                          _MyCustomRow(label: 'Name:', value: name),
                          _MyCustomRow(label: 'Gender:', value: gender),
                          _MyCustomRow(label: 'Aliases:', value: aliases),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => goBack(context),
              child: const Text('Go back'),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyCustomRow extends StatelessWidget {
  const _MyCustomRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 8, right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontFamily: 'Helvetica'),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${'.' * 15}  $value',
              style: const TextStyle(fontFamily: 'Helvetica'),
            ),
          ),
        ],
      ),
    );
  }
}
