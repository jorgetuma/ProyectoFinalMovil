import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/api/PokemonDAO.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/DBHelper.dart';
import 'api/apiservice.dart';
import 'detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<PokemonDAO> searchResults = [];
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
      try {
        List<PokemonDAO> allPokemons = await DatabaseHelper.instance.getAllPokemons();
        List<PokemonDAO> matchingPokemon = [];

        for (var pokemon in allPokemons) {
          // Check if the query matches a Pokemon name or ID.
          final nameLower = pokemon.name.toLowerCase();
          if (nameLower.contains(query.toLowerCase()) || pokemon.id.toString().contains(query) || pokemon.type.contains(query)) {
            matchingPokemon.add(pokemon);
          }
        }

        // Update the search results.
        setState(() {
          searchResults = matchingPokemon;
        });
      } catch (e) {
        print("Error updating search results: $e");

        // Update the search results to show an error
        // setState(() {
        //   searchResults = ['error'];
        // });
      }
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
          bottom: false,
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
                                    hintText: 'Search Pokemon by name, ID or type',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                  ),
                                  // Add text field controllers and handlers as needed
                                ),
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
                    String pokemonId = searchResults[index].id.toString();
                    var color = ApiService.getInstance().getColorType(searchResults[index].type);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(id:pokemonId)));
                          print("ID: $pokemonId"); // Print the ID when the card is clicked
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ApiService.getInstance().getColorType(searchResults[index].type),
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Positioned(
                                        bottom: -15,
                                        right: -15,
                                        child: Image.asset('images/pokeball.png', height: 100, fit: BoxFit.fitHeight,)
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: CachedNetworkImage(
                                        imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemonId}.png',
                                        placeholder: (context, url) => CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => Icon(Icons.error_outline, color: Colors.transparent,),
                                        height: 100,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    ),
                                    Positioned(
                                      top: 22,
                                      left: 10,
                                      child: Text(
                                        // pokedex[index]['name'],
                                        searchResults[index].name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 50,
                                      left: 10,
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                          child: Text(
                                            searchResults[index].type,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.black12,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 10,
                                      child: Text(
                                        "#${pokemonId}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
