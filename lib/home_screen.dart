import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List pokedex = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(mounted) {
      fetchPokemonData();
      _scrollController.addListener(_scrollListener);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading: Icon(Icons.menu),
          title: Text('Pokedex'),
          actions: [
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
              ))
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
