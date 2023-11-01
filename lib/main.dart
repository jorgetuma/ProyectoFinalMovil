import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'home_screen.dart';

void main() {
  runApp(Pokedex());
}

class Pokedex extends StatelessWidget {
  const Pokedex({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex',
      home: HomeScreen(),
    );
  }
}


// class Pokedex extends StatefulWidget {
//   const Pokedex({super.key});
//
//   @override
//   State<Pokedex> createState() => _PokedexState();
// }
//
// class _PokedexState extends State<Pokedex> {
//   List pokedex = [];
//   ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     if(mounted) {
//       fetchPokemonData();
//       _scrollController.addListener(_scrollListener);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Pokedex',
//       home: Scaffold(
//           appBar: AppBar(
//             title: Text('Pokedex'),
//           ),
//           body: Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               children: [
//                 Expanded(child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   childAspectRatio: 1.4,
//                 ),controller: _scrollController,
//                   itemCount: pokedex.length,
//                   itemBuilder: (context, index) {
//                     return Card(
//                       child: Column(
//                         children: [
//                           Text(pokedex[index]['name']),
//                         ],
//                       ),
//                     );
//                   },
//                 ))
//               ],
//             ),
//           )
//       ),
//     );
//   }
//
//   void fetchPokemonData({int offset = 0}) {
//     var url = Uri.https("pokeapi.co", "/api/v2/pokemon", {"offset": offset.toString()});
//     http.get(url).then((response) {
//       if (response.statusCode == 200) {
//         var decodedJson = jsonDecode(response.body);
//         List newPokemon = decodedJson['results'];
//         setState(() {
//           pokedex.addAll(newPokemon); // Add new data to the existing list.
//         });
//       }
//     });
//   }
//
//   void _scrollListener() {
//     if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
//       // The user has scrolled to the end; load more data.
//       fetchPokemonData(offset: pokedex.length);
//     }
//   }
//
// }
//
