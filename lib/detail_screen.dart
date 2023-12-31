import 'package:flutter/cupertino.dart';
import 'package:pokedex/api/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/modelos/detailtabbar.dart';
import 'package:pokedex/modelos/pokemonevolve.dart';
import 'package:pokedex/modelos/pokemoninfo.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'api/DBHelper.dart';

class DetailScreen extends StatefulWidget {
  final String id;

  DetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool isFavorite = false;
  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
    if (mounted) {
      _loadPokemonInfo();
    }

  }

  Future<void> _loadFavoriteStatus() async {
    isFavorite = await DatabaseHelper.instance.isPokemonFavorite(int.parse(widget.id));
    if (mounted) {
      setState(() {
        // Trigger a rebuild if the widget is still in the tree
      });
    }
  }

  // Función para cargar la información del Pokémon
  void _loadPokemonInfo() async {
    await ApiService.getInstance().getInfoPokemon(widget.id.toString());
    if (mounted) {
      setState(() {
        //Actualizando el estado
        _loadPokemonSpecie();
      });
    }
  }

  void _loadPokemonSpecie() async {
    await ApiService.getInstance().getSpeciePokemon(ApiService.getInstance().getIdFromUrl(ApiService.getInstance().pokemonInfo!.species.url));
    if (mounted) {
      setState(() {
        //Actualizando el estado
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pokemonInfo = ApiService
        .getInstance()
        .pokemonInfo;
    _loadPokemonEvolve();
    if (pokemonInfo == null || ApiService.getInstance().specie == null || ApiService.getInstance().pokeEvolve == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    var alturaMinima = MediaQuery.of(context).size.height / 1.8;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemonInfo.forms[0].name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21)),
        elevation: 0,
        backgroundColor: ApiService.getInstance().getColorType(
            pokemonInfo.types[0].type.name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          // Other actions can go here if needed
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              // Handle favorite/unfavorite logic here
              setState(() {
                isFavorite = !isFavorite;
              });
              // Update the database with the new favorite status
              DatabaseHelper.instance.updatePokemonFavoriteStatus(
                pokemonInfo.id,
                isFavorite,
              );
            },
          ),
        ],
      ),
      backgroundColor: ApiService.getInstance().getColorType(
          pokemonInfo.types[0].type.name),
      body: Stack(
        children: <Widget>[
          pokemonTypes(pokemonInfo.types),
          Container(
            height: MediaQuery
                .of(context)
                .size
                .height / 3,
          ),
          Positioned(
            top: 40,
            child: SizedBox(
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Hero(
                    tag: 1,
                    child: Opacity(
                      opacity: 0.2,
                      child: Image.asset(ApiService.whitePokeball),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: ApiService.getInstance().getImage(pokemonInfo.id.toString()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SlidingUpPanel(
            panel: DetailTabBar(pokemon: pokemonInfo),
            maxHeight: MediaQuery
                .of(context)
                .size
                .height,
            minHeight: alturaMinima,
          ),
        ],
      ),
    );
  }

  void _loadPokemonEvolve() async {
    final specie = ApiService.getInstance().specie;
    if(specie !=null) {
      await ApiService.getInstance().getEvolutionPokemon(specie.evolutionChain.url);
    }
    if (mounted) {
      setState(() {
        //Actualizando el estado
      });
    }
  }

  Widget pokemonTypes(List<Type> types) {
    List<Widget> lista = [];

    lista.add(
      Padding(
        padding: EdgeInsets.only(right: 8), // Ajusta el espacio a la derecha
        child: Text(
          '#' + ApiService
              .getInstance()
              .pokemonInfo!
              .id
              .toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            color: Colors.white,
          ),
        ),
      ),
    );

    types.forEach((name) {
      lista.add(
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(80, 255, 255, 255),
              ),
              child: Text(
                name.type.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: 8, // Ajusta el espacio entre los tipos
            )
          ],
        ),
      );
    });

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: lista,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
