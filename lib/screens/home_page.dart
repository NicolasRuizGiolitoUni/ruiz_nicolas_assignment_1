import 'package:ruiz_nicolas_assignment_1/screens/details_page.dart';
import 'package:flutter/material.dart';
import 'package:ruiz_nicolas_assignment_1/networking/api.dart';
import 'package:ruiz_nicolas_assignment_1/db/character.dart';

// Declere an ENUM for filter options. ENUM is the best option for a set of
// constants
enum FilterOptions { female, male }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Character>> futureCharacters;
  Set<FilterOptions> selectedFilters = <FilterOptions>{
    FilterOptions.female,
    FilterOptions.male
  };

  @override
  void initState() {
    super.initState();
    futureCharacters = fetchCharacters(); // Fetch the characters objects
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
          child: SafeArea(
            child: AppBar(
              title: const Padding(
                padding: EdgeInsets.only(top: 32.0),
                child: Text(
                  'Game of Thrones Characters',
                  style: TextStyle(fontFamily: 'Helvetica', fontSize: 25),
                  softWrap: true,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                ),
              ),
              centerTitle: true,
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        // The only pupose of using this container is to set a gradient bg
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              end: Alignment.topCenter,
              begin: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 243, 242, 242),
                Color.fromARGB(255, 255, 255, 255)
              ],
            ),
          ),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: FilterOptions
                        .values // we create a list of filter "chips" to feed the row with using map
                        .map((FilterOptions gender) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FilterChip(
                                  label: Text(
                                    gender.name,
                                    style: TextStyle(fontFamily: 'Helvetica'),
                                  ), // name of the buttons
                                  selected: selectedFilters.contains(
                                      gender), // mark the buttons when they are selected (returns a bool)
                                  onSelected: (bool selected) {
                                    setState(() {
                                      if (selected) {
                                        selectedFilters.add(gender);
                                      } else {
                                        selectedFilters.remove(gender);
                                      }
                                    });
                                  }),
                            ))
                        .toList(),
                  ),
                ),
                Expanded(
                  child: _ScrollableListOfCharacters(
                    futureCharacters: futureCharacters,
                    selectedFilters:
                        selectedFilters, // we pass the selected filter to render later only the characters whose gender is selected
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class _ScrollableListOfCharacters extends StatelessWidget {
  const _ScrollableListOfCharacters({
    Key? key,
    required this.futureCharacters,
    required this.selectedFilters,
  }) : super(key: key);

  final Future<List<Character>> futureCharacters;
  final Set<FilterOptions> selectedFilters;

  void openPage(BuildContext context, Character character) {
    String image = determineImage(character.gender);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(character: character, image: image),
      ),
    );
  }

  String determineImage(String gender) {
    return gender == 'Female'
        ? 'assets/images/femalechar.png'
        : 'assets/images/malechar.png';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Character>>(
      future: futureCharacters,
      builder: (context, AsyncSnapshot<List<Character>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        }

        // Apply filtering based on selected filters
        List<Character> filteredCharacters = snapshot.data!.where((character) {
          if (selectedFilters.contains(FilterOptions.female) &&
              character.gender.toLowerCase() != 'female') {
            return false; // Exclude non-female characters if "Female" chip is selected
          }
          if (selectedFilters.contains(FilterOptions.male) &&
              character.gender.toLowerCase() != 'male') {
            return false; // Exclude non-male characters if "Male" chip is selected
          }
          return true; // Include the character if it passes the filters
        }).toList();

        // If both filters are selected, show all characters
        if (selectedFilters.contains(FilterOptions.female) &&
            selectedFilters.contains(FilterOptions.male)) {
          filteredCharacters = snapshot.data!; // Show all characters
        }

        return ListView.builder(
          itemCount: filteredCharacters.length,
          itemBuilder: (context, index) {
            Character character = filteredCharacters[index];
            return Card(
              margin: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: Image.asset(
                  determineImage(character.gender),
                  width: 50,
                  height: 50,
                ),
                title: Text(character.name,
                    style: const TextStyle(fontFamily: 'Helvetica')),
                subtitle: Text(character.aliases[0],
                    style: const TextStyle(fontFamily: 'Helvetica')),
                trailing: const Icon(Icons.chevron_right_outlined),
                onTap: () => openPage(context, character),
              ),
            );
          },
        );
      },
    );
  }
}
