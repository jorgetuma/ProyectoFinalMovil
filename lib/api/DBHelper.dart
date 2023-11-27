
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'PokemonDAO.dart';
import 'package:http/http.dart' as http;

class DatabaseHelper {
  static const String databaseName = 'pokemon_database.db';
  static const String tableName = 'pokemons';

  late Database _database;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), databaseName);
      _database = await openDatabase(path, version: 1, onCreate: _onCreate);

      return _database;
    } catch (e) {
      print("Error initializing database: $e");
      throw e; // Re-throw the exception to propagate the error
    }
  }

  Future<void> fetchAndInsertPokemonData({int offset = 0}) async {

    try {
      var url = Uri.https("pokeapi.co", "/api/v2/pokemon", {"limit": "1500"});
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        List<dynamic> newPokemon = decodedJson['results'];

        for (var pokemonData in newPokemon) {
          String url = pokemonData['url'];
          List<String> parts = url.split('/');
          String pokemonId = parts[parts.length - 2];

          var newurl = Uri.https("pokeapi.co", "/api/v2/pokemon/" + pokemonId);
          final response = await http.get(newurl);
          var decodeJson = jsonDecode(response.body);

          PokemonDAO pokemon = PokemonDAO(
            id: int.parse(pokemonId),
            name: pokemonData['name'],
            type: decodeJson['types'][0]['type']['name'],
            isFavorite: false,
          );

          // await ApiService.getInstance().getInfoPokemon(pokemonId);
          // print(ApiService.getInstance().pokemonInfo!);

          // Insert the Pokémon into the database
          await DatabaseHelper.instance.insertPokemon(pokemon);
          // await DatabaseHelper.instance.insertPokemon(ApiService.getInstance().pokemonInfo! as PokemonDAO);
        }

      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error fetching Pokemon data: $e");
    }
  }


  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY,
        num TEXT,
        name TEXT,
        type TEXT,
        isFavorite INTEGER
      )
    ''');
    Future.delayed(Duration(milliseconds: 100), () {
      fetchAndInsertPokemonData();
    });
  }

  Future<int> insertPokemon(PokemonDAO pokemon) async {
    Database db = await database;
    return await db.insert(tableName, pokemon.toJson());
  }

  Future<List<PokemonDAO>> getAllPokemons() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableName);

    return List.generate(maps.length, (index) {
      return PokemonDAO.fromMap(maps[index]);
    });
  }

  Future<int> updatePokemonFavoriteStatus(int id, bool isFavorite) async {
    Database db = await database;
    return await db.update(
      tableName,
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<PokemonDAO>> searchPokemon(String query) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'name LIKE ? OR id LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (index) {
      return PokemonDAO.fromMap(maps[index]);
    });
  }

}

