import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/api/PokemonDAO.dart';
import 'package:pokedex/detail_screen.dart';
import 'package:pokedex/favorite_screen.dart';
import 'package:pokedex/search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api/DBHelper.dart';
import 'api/apiservice.dart';
import 'modelos/pokemoninfo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  // List pokedex = [];
  List<PokemonDAO> pokedex = [];
  ScrollController _scrollController = ScrollController();
  bool isFirstTime = true;
  bool isFetching = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Check if first time or SharedPreferences is empty.
    // checkFirstTime().then((firstTime) {
    //   if (firstTime) {
    //     print('First time!');
    //     // Fetch and save all Pokémon data from the API.
    //     fetchAndSaveAllPokemonData().then((success) {
    //       if (success) {
    //         setState(() {
    //           isFirstTime = false;
    //         });
    //       }
    //     });
    //   } else {
    //     print('Not first time!');
    //   }
    // });

    if(mounted) {
      fetchPokemonData();
      _listenToPokemonStream();
      // _scrollController.addListener(_scrollListener);
    }
  }

  void _listenToPokemonStream() {
    DatabaseHelper.instance.pokemonStream.listen((List<PokemonDAO> updatedPokedex) {
      setState(() {
        pokedex = updatedPokedex;
      });
    });
  }

  Future<bool> checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstTime') ?? true;
  }

  Future<bool> fetchAndSaveAllPokemonData() async {
    try {
      var url = Uri.https("pokeapi.co", "/api/v2/pokemon", {"limit": "1500"});
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        List newPokemon = decodedJson['results'];

        final prefs = await SharedPreferences.getInstance();

        for (var pokemonData in newPokemon) {
          String name = pokemonData['name'];
          String url = pokemonData['url'];
          List<String> parts = url.split('/');
          String pokemonId = parts[parts.length - 2];

          // Save the data
          prefs.setString(pokemonId, name);
        }

        await prefs.setBool('isFirstTime', false);

        return true;
      } else {
        // Handle API request failure.
        return false;
      }
    } catch (e) {
      // Handle errors
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        // ),
        body: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              Positioned(
                // top: MediaQuery.of(context).viewPadding.top,
                left: 0,
                right: 0,
                height: 100,
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
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
                                },
                                icon: Icon(Icons.search, color: Colors.red),
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
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteScreen()));
                                },
                                icon: Icon(Icons.favorite_outline, color: Colors.red),
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
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 100,
                bottom: 0,
                width: width,
                child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.4,
                ),controller: _scrollController,
                  itemCount: pokedex.length,
                  itemBuilder: (context, index) {
                    // var color = ApiService.getInstance().getColorType(pokedex[index].types[0].type.name);
                    // String url = pokedex[index]['url'];
                    // String url = pokedex[index]['url'];
                    // List<String> parts = url.split('/');
                    // String pokemonId = pokedex[index].id.toString();
                    String pokemonId = pokedex[index].id.toString();
                    var color = ApiService.getInstance().getColorType(pokedex[index].type);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(id:pokemonId)));
                          // print("ID: $pokemonId"); // Print the ID when the card is clicked
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ApiService.getInstance().getColorType(pokedex[index].type),
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
                                        // errorWidget: (context, url, error) => Image.asset('images/pokeball.png'),
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
                                        capitalize(pokedex[index].name),
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
                                            pokedex[index].type,
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
                                      left: 10,
                                      child: Text(
                                        "#${pokemonId}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black26,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 5,
                                      right: 10,
                                      child: FutureBuilder<bool>(
                                        future: DatabaseHelper.instance.isPokemonFavorite(pokedex[index].id),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            // Return a loading indicator or placeholder if needed
                                            return CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            // Handle error
                                            return Icon(Icons.favorite_border, color: Colors.grey);
                                          } else {
                                            bool isFavorite = snapshot.data ?? false;

                                            return GestureDetector(
                                              onTap: () async {
                                                // Toggle the favorite status
                                                bool newFavoriteStatus = !isFavorite;

                                                // Update the database with the new favorite status
                                                await DatabaseHelper.instance.updatePokemonFavoriteStatus(pokedex[index].id, newFavoriteStatus);

                                                // If you want to perform any additional actions when the favorite status changes,
                                                // you can do that here.

                                                // Note: setState might be needed if you are using this within a StatefulWidget
                                              },
                                              child: Icon(
                                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                                color: isFavorite ? Colors.red : Colors.grey,
                                              ),
                                            );
                                          }
                                        },
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

  Future<void> fetchPokemonData({int offset = 0}) async {
    if (isFetching) {
      return;
    }

    try {
      setState(() {
        isFetching = true;
      });

      // var url = Uri.https("pokeapi.co", "/api/v2/pokemon", {"offset": offset.toString(), "limit": "50"});
      // final response = await http.get(url);
      //
      // if (response.statusCode == 200) {
      //   final decodedJson = jsonDecode(response.body);
      //   List<dynamic> newPokemon = decodedJson['results'];
      //
      //   for (var pokemonData in newPokemon) {
      //     String url = pokemonData['url'];
      //     List<String> parts = url.split('/');
      //     String pokemonId = parts[parts.length - 2];
      //
      //     await ApiService.getInstance().getInfoPokemon(pokemonId);
      //     pokedex.add(ApiService.getInstance().pokemonInfo!);
      //   }
      //
      //   setState(() {});
      // } else {
      //   throw Exception('Failed to load data');
      // }
      List<PokemonDAO> allPokemon = await DatabaseHelper.instance.getAllPokemons();
      print("fetching");
      pokedex.addAll(allPokemon);
    } catch (e) {
      print("Error fetching Pokemon data: $e");
    } finally {
      setState(() {
        isFetching = false;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent * 0.5) {
      fetchPokemonData(offset: pokedex.length);
    }
  }

  @override
  void dispose() {
    DatabaseHelper.instance.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String capitalize(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }

}
