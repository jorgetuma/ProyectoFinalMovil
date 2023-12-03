
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
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

  final _pokemonStreamController = StreamController<List<PokemonDAO>>.broadcast();
  Stream<List<PokemonDAO>> get pokemonStream => _pokemonStreamController.stream;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), databaseName);
      _database = await openDatabase(path, version: 1, onCreate: _onCreate);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? lastUpdateDate = prefs.getString('lastUpdateDate');

      if (lastUpdateDate != null) {
        DateTime lastUpdate = DateTime.parse(lastUpdateDate);
        DateTime now = DateTime.now();
        Duration difference = now.difference(lastUpdate);

        if (difference.inDays > 0 || (await getPokemonRowCount())! < 1292) {
          print("loading data");
          await _onCreate(_database, 1);
        }
      }

      return _database;
    } catch (e) {
      print("Error initializing database: $e");
      throw e; // Re-throw the exception to propagate the error
    }
  }

  Future<void> _onCreate(Database db, int version) async {

    // Drop the existing table if it exists
    await db.execute('DROP TABLE IF EXISTS $tableName');

    await db.execute('''
      CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY,
        num TEXT,
        name TEXT,
        type TEXT,
        isFavorite INTEGER
      )
    ''');

    await db.execute('''
    CREATE TABLE IF NOT EXISTS favorite_pokemons(
        id INTEGER PRIMARY KEY,
        pokemon_id INTEGER,
        FOREIGN KEY(pokemon_id) REFERENCES pokemons(id)
      )
    ''');
    // saveLastUpdateDate();
    print("DB created");
    Future.delayed(Duration(milliseconds: 100), () {
      fetchAndInsertPokemonData();
    });
  }

  Future<void> saveLastUpdateDate() async {
    print("date updated!!!");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lastUpdateDate', DateTime.now().toIso8601String());
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
        saveLastUpdateDate();

      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print("Error fetching Pokemon data: $e");
    }
  }

  Future<int> insertPokemon(PokemonDAO pokemon) async {
    Database db = await database;
    int result = await db.insert(tableName, pokemon.toJson());
    _pokemonStreamController.add(await getAllPokemons()); // Notify listeners
    return result;
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

    // Check if the Pokémon is being marked as a favorite or unfavorite
    if (isFavorite) {
      // Insert a record in the favorite_pokemons table
      await db.insert('favorite_pokemons', {'pokemon_id': id});
      print('added');
    } else {
      // Delete the record from the favorite_pokemons table
      await db.delete('favorite_pokemons', where: 'pokemon_id = ?', whereArgs: [id]);
      print('deleted');
    }

    _pokemonStreamController.add(await getAllPokemons()); // Notify listeners

    return 1;
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

  void dispose() {
    _pokemonStreamController.close();
  }

  Future<int?> getPokemonRowCount() async {
    Database db = await database;
    int? count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
    return count;
  }

  Future<bool> isPokemonFavorite(int pokemonId) async {
    try {
      Database db = await database;
      List<Map<String, dynamic>> result = await db.query(
        'favorite_pokemons',
        where: 'pokemon_id = ?',
        whereArgs: [pokemonId],
      );

      // If the result list is not empty, the Pokémon is marked as a favorite
      return result.isNotEmpty;
    } catch (e) {
      print('Error checking if Pokemon is a favorite: $e');
      return false;
    }
  }

  Future<List<PokemonDAO>> getAllFavoritePokemons() async {
    try {
      Database db = await database;

      // Join the two tables to get details of favorite Pokémon
      List<Map<String, dynamic>> maps = await db.rawQuery('''
        SELECT pokemons.*
        FROM favorite_pokemons
        INNER JOIN pokemons ON favorite_pokemons.pokemon_id = pokemons.id
      ''');

      return List.generate(maps.length, (index) {
        return PokemonDAO.fromMap(maps[index]);
      });
    } catch (e) {
      print("Error fetching favorite Pokémon: $e");
      throw e; // Handle the error or re-throw it as needed
    }
  }


}

