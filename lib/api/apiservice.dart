import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../modelos/pokemoninfo.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String whitePokeball = 'images/pokeball.png';
  static ApiService? instance;
  PokemonInfo? pokemonInfo;

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
        return Colors.brown[400]!;
        break;
      case 'fire':
        return Colors.red;
        break;
      case 'water':
        return Colors.blue;
        break;
      case 'grass':
        return Colors.green;
        break;
      case 'electric':
        return Colors.amber;
        break;
      case 'ice':
        return Colors.cyanAccent[400]!;
        break;
      case 'fighting':
        return Colors.orange;
        break;
      case 'poison':
        return Colors.purple;
        break;
      case 'ground':
        return Colors.orange[300]!;
        break;
      case 'flying':
        return Colors.indigo[200]!;
        break;
      case 'psychic':
        return Colors.pink;
        break;
      case 'bug':
        return Colors.lightGreen[500]!;
        break;
      case 'rock':
        return Colors.grey;
        break;
      case 'ghost':
        return Colors.indigo[400]!;
        break;
      case 'dark':
        return Colors.brown;
        break;
      case 'dragon':
        return Colors.indigo[800]!;
        break;
      case 'steel':
        return Colors.blueGrey;
        break;
      case 'fairy':
        return Colors.pinkAccent[100]!;
        break;
      default:
        return Colors.grey;
        break;
    }
  }
}