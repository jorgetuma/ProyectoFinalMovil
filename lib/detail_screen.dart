import 'package:flutter/cupertino.dart';
import 'package:pokedex/api/apiservice.dart';
import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class DetailScreen extends StatefulWidget {
  final String id;

  DetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadPokemonInfo();
  }

  // Función para cargar la información del Pokémon
  void _loadPokemonInfo() async {
    await ApiService.getInstance().getInfoPokemon(widget.id.toString());
    setState(() {
      //Actualizando el estado
    });
  }

  @override
  Widget build(BuildContext context) {
    final pokemonInfo = ApiService.getInstance().pokemonInfo;

    if (pokemonInfo == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(pokemonInfo.forms[0].name, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 21)),
        elevation: 0,
        backgroundColor: ApiService.getInstance().getColorType(pokemonInfo.types[0].type.name),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: ApiService.getInstance().getColorType(pokemonInfo.types[0].type.name),
      body: Stack(
        children: <Widget>[Container(
          height: MediaQuery.of(context).size.height / 3,
        ),
          Positioned(
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
                          )
                      ),
                      Center(
                        child: ApiService.getInstance().getImage(pokemonInfo.id.toString()),
                      )
                    ],
                  )
              )
          ),
          SlidingSheet(
            elevation: 0,
            cornerRadius: 16,
            snapSpec: const SnapSpec(
              snap: true,
              snappings: [0.7, 1.0],
              positioning: SnapPositioning.relativeToAvailableSpace,
            ),

            builder: (context, state) {
              return Container(
                height: MediaQuery.of(context).size.height,
              );
            },
          ),
          ],
      ),
    );
  }
}
