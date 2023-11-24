import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../configs/colors.dart';
import '../modelos/pokemonevolve.dart';
import '../modelos/specie.dart';
import '../modelos/pokemoninfo.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String whitePokeball = 'images/pokeball.png';
  static ApiService? instance;
  PokemonInfo? pokemonInfo;
  Specie? specie;
  PokemonEvolve? pokeEvolve;

  ApiService._();


  static ApiService getInstance() {
    if(instance == null) {
      instance = ApiService._();
    }
    return instance!;
  }

  Future<void> getInfoPokemon(String id) async {
    try {
      var url = Uri.https("pokeapi.co", "/api/v2/pokemon/" + id);
      final response = await http.get(url);
      var decodeJson = jsonDecode(response.body);
      pokemonInfo = PokemonInfo.fromJson(decodeJson);
    } catch (error, stacktrace) {
      print("Error al cargar la info del pokemon" + stacktrace.toString());
    }
  }

  Future<void> getSpeciePokemon(String id) async {
    try {
      var url = Uri.https("pokeapi.co", "/api/v2/pokemon-species/" + id);
      final response = await http.get(url);
      var decodeJson = jsonDecode(response.body);
      specie = Specie.fromJson(decodeJson);
    } catch (error, stacktrace) {
      print("Error al cargar la info sobre la especie del pokemon" + stacktrace.toString());
    }
  }

  Future<void> getEvolutionPokemon(String evolutionurl) async {
    try {
      var url = Uri.parse(evolutionurl);
      final response = await http.get(url);
      var decodeJson = jsonDecode(response.body);
      pokeEvolve = PokemonEvolve.fromJson(decodeJson);
    } catch (error, stacktrace) {
      print("Error al cargar la info sobre las evoluciones del pokemon" + stacktrace.toString());
    }
  }

  Widget getImage(String id) {
    try {
      return CachedNetworkImage(
        placeholder: (context, url) => new Container(
          color: Colors.transparent,
        ),
        imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
        errorWidget: (context, url, error) {
          // En caso de un error, muestra la imagen de reemplazo.
          return Image.asset(whitePokeball);
        },
      );
    } catch (e) {
      // Maneja la excepción de manera apropiada, como mostrar un mensaje de error.
      return Text("Error: $e");
    }
  }


  Color getColorType(String type) {
    switch (type) {
      case 'normal':
        // return Colors.brown[400]!;
        return AppColors.beige;
        break;
      case 'fire':
        return AppColors.lightRed;
        // return Colors.red;
        break;
      case 'water':
        // return Colors.blue;
        return AppColors.lightBlue;
        break;
      case 'grass':
        // return Colors.green;
      return AppColors.lightGreen;
        break;
      case 'electric':
        return AppColors.lightYellow;
        // return Colors.amber;
        break;
      case 'ice':
        return AppColors.lightCyan;
        // return Colors.cyanAccent[400]!;
        break;
      case 'fighting':
        return AppColors.red;
        // return Colors.orange;
        break;
      case 'poison':
        return AppColors.lightPurple;
        // return Colors.purple;
        break;
      case 'ground':
        return AppColors.darkBrown;
        // return Colors.orange[300]!;
        break;
      case 'flying':
        return AppColors.lilac;
        // return Colors.indigo[200]!;
        break;
      case 'psychic':
        return AppColors.lightPink;
        // return Colors.pink;
        break;
      case 'bug':
        return AppColors.lightTeal;
        // return Colors.lightGreen[500]!;
        break;
      case 'rock':
        return AppColors.lightBrown;
        // return Colors.grey;
        break;
      case 'ghost':
        return AppColors.purple;
        // return Colors.indigo[400]!;
        break;
      case 'dark':
        return AppColors.black;
        // return Colors.brown;
        break;
      case 'dragon':
        return AppColors.violet;
        // return Colors.indigo[800]!;
        break;
      case 'steel':
        return AppColors.grey;
        // return Colors.blueGrey;
        break;
      case 'fairy':
        return AppColors.pink;
        // return Colors.pinkAccent[100]!;
        break;
      default:
        return AppColors.lightBlue;
        // return Colors.grey;
        break;
    }
  }

   List<String> getEvolutions(EvolvesTo evolutionChain) {
    List<String> evolutionNames = [];

    //Agregar especie inicial
    evolutionNames.add(pokeEvolve!.chain.species.name);

    // Agregar la especie siguiente
    evolutionNames.add(evolutionChain.species.name);

    // Llamar a la función recursiva para obtener todas las evoluciones
    _getEvolutionsRecursive(evolutionChain.evolvesTo, evolutionNames);

    return evolutionNames;
  }

  static void _getEvolutionsRecursive(List<EvolvesTo> evolvesTo, List<String> evolutionNames) {
    for (var evolution in evolvesTo) {
      // Agregar el nombre de la especie a la lista
      evolutionNames.add(evolution.species.name);

      // Si hay más evoluciones, seguir recorriendo
      if (evolution.evolvesTo.isNotEmpty) {
        _getEvolutionsRecursive(evolution.evolvesTo, evolutionNames);
      }
    }
  }
}