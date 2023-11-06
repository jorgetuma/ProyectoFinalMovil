import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/detail_screen.dart';
import 'package:pokedex/search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List pokedex = [];
  ScrollController _scrollController = ScrollController();
  bool isFirstTime = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Check if it's the first time the app is opened or SharedPreferences is empty.
    checkFirstTime().then((firstTime) {
      if (firstTime) {
        print('First time!');
        // Fetch and save all Pokémon data from the API.
        fetchAndSaveAllPokemonData().then((success) {
          if (success) {
            setState(() {
              isFirstTime = false;
            });
          }
        });
      } else {
        print('Not first time!');
      }
    });

    if(mounted) {
      fetchPokemonData();
      _scrollController.addListener(_scrollListener);
    }
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
                          Container(
                            child: IconButton(
                              onPressed: () {

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
                    String url = pokedex[index]['url'];
                    List<String> parts = url.split('/');
                    String pokemonId = parts[parts.length - 2];
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
                            color: Colors.green,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Stack(
                              children: [
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: CachedNetworkImage(
                                          imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemonId}.png',
                                          placeholder: (context, url) => CircularProgressIndicator(),
                                          errorWidget: (context, url, error) => Image.asset('images/pokeball.png'),
                                        ),
                                      ),
                                      Text(
                                        pokedex[index]['name'],
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
                                    "#${pokemonId}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
    var url = Uri.https("pokeapi.co", "/api/v2/pokemon", {"offset": offset.toString(), "limit": "50"});
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      List newPokemon = decodedJson['results'];

      setState(() {
        pokedex.addAll(newPokemon);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      fetchPokemonData(offset: pokedex.length);
    }
  }
}
