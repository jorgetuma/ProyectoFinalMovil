import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> searchResults = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      updateSearchResults(_searchController.text);
    });
  }

  Future<void> updateSearchResults(String query) async {
    if (query.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final allPokemonData = prefs.getKeys();

      List<String> matchingPokemon = allPokemonData.where((pokemonId) {
        final value = prefs.get(pokemonId);

        if (value is String) {
          // Check if the query matches a Pokemon name or ID.
          final nameLower = value.toLowerCase();
          if (nameLower.contains(query.toLowerCase())) {
            return true; // Matches the Pokemon name.
          } else if (pokemonId.contains(query)) {
            return true; // Matches the Pokemon ID.
          }
        }

        return false;
      }).toList();

      // Sort by Pokémon ID
      matchingPokemon.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

      // Update the search results.
      setState(() {
        searchResults = matchingPokemon;
      });
  }
  }

  // Function to get the Pokémon name from SharedPreferences
  Future<String> getPokemonName(String pokemonId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(pokemonId) ?? 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                // top: MediaQuery.of(context).viewPadding.top,
                left: 0,
                right: 0,
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            IconData(0xef36, fontFamily: 'MaterialIcons'),
                            size: 50,
                            color: Colors.red,
                          ),
                          Text('Pokedex', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.red,),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  autofocus: true,
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Search Pokemon by name or ID',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  // Add text field controllers and handlers as needed
                                ),
                              ),
                            ),
                            Container(
                              child: IconButton(
                                onPressed: () {
                                  // Handle filter button click here
                                },
                                icon: Icon(Icons.filter_list, color: Colors.red),
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle, // Circular shape
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.red, // Border color
                                  width: 1.0, // Border width
                                ),// Button color
                              ),

                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 150,
                bottom: 0,
                width: width,
                child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.4,
                ),
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    String pokemonId = searchResults[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(id:pokemonId)));
                          print("ID: $pokemonId");
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green,
                          ),
                          child: FutureBuilder(
                            future: getPokemonName(searchResults[index]),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator(); // Show a loading indicator while fetching the name.
                              } else if (snapshot.hasError) {
                                return Text('Error'); // Handle errors, if any.
                              } else {
                                final pokemonName = snapshot.data.toString();
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: CachedNetworkImage(
                                                imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${searchResults[index]}.png',
                                                placeholder: (context, url) => CircularProgressIndicator(),
                                                errorWidget: (context, url, error) => Image.asset('images/pokeball.png'),
                                              ),
                                            ),
                                            Text(
                                              pokemonName, // Display the fetched Pokémon name
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        top: 5,
                                        right: 5,
                                        child: Text(
                                          "#${searchResults[index]}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    );

                  },
                ),
              ),
            ],
          ),
        )
    );
  }
}
