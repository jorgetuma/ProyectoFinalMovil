import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
          title: Text('Pokedex'),
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
                  return Card(
                    child: Column(
                      children: [
                        Text(pokedex[index]['name']),
                        Container(
                          width: 100,
                          height: 100,
                          child: CachedNetworkImage(
                            imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${index+1}.png',
                            placeholder: (context, url) => CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Icon(Icons.error),
                          ),
                        ),
                      ],
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
    var url = Uri.https("pokeapi.co", "/api/v2/pokemon", {"offset": offset.toString()});
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
