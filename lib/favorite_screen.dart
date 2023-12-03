import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'api/DBHelper.dart';
import 'api/PokemonDAO.dart';
import 'api/apiservice.dart';
import 'detail_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<PokemonDAO> favorites = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (mounted) {
      fetchFavoritePokemons();
    }
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
                          Text('Favorites', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.red,),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
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
                ),
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    String pokemonId = favorites[index].id.toString();
                    var color = ApiService.getInstance().getColorType(favorites[index].type);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(id:pokemonId)));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ApiService.getInstance().getColorType(favorites[index].type),
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
                                        capitalize(favorites[index].name),
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
                                            favorites[index].type,
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
                                        future: DatabaseHelper.instance.isPokemonFavorite(favorites[index].id),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
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
                                                await DatabaseHelper.instance.updatePokemonFavoriteStatus(favorites[index].id, newFavoriteStatus);

                                                if (!newFavoriteStatus) {
                                                  setState(() {
                                                    favorites.removeAt(index);
                                                  });
                                                }
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

  Future<void> fetchFavoritePokemons() async {
    try {
      List<PokemonDAO> allFavorites = await DatabaseHelper.instance.getAllFavoritePokemons();

      // Sort the list by id
      allFavorites.sort((a, b) => a.id.compareTo(b.id));

      setState(() {
        favorites.addAll(allFavorites);
      });
    } catch(e) {
      print("Error fetching Pokemon data: $e");
    }
  }

  String capitalize(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input[0].toUpperCase() + input.substring(1);
  }
}
