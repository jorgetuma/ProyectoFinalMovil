import 'package:flutter/material.dart';
import 'package:pokedex/api/apiservice.dart';
import 'package:pokedex/modelos/pokemoninfo.dart';

class DetailTabBar extends StatelessWidget {
  final PokemonInfo pokemon;

  const DetailTabBar({super.key, required PokemonInfo this.pokemon});
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 1,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: Color(0Xff5f6368),
            tabs: <Widget>[
              Tab(
                icon: Text(
                  "Description",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                icon: Text(
                  "Stats",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                icon: Text(
                  "Evolutions",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                icon: Text(
                  "Abilities",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Tab(
                icon: Text(
                  "Moves",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: Column(
                  children: <Widget>[],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: Column(
                  children: <Widget>[
                    Column(
                      children: pokemon.stats.map((stat) {
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                          title: Text(
                            '${stat.stat.name}: ${stat.baseStat}',
                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                          ),
                          subtitle: LinearProgressIndicator(
                            value: stat.baseStat /
                                100.0, // Asumiendo un rango de 0-100
                            backgroundColor: Colors.grey[300], // Color de fondo
                            valueColor: AlwaysStoppedAnimation<Color>(ApiService.getInstance().getColorType(ApiService.getInstance().pokemonInfo!.types[0].type.name)), // Color de la barra de progreso
                            minHeight: 20,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
            ),
            Center(
              child: Text("Evolutions"),
            ),
            Center(
              child: Text("Abilities"),
            ),
            Center(
              child: Text("Moves"),
            ),
          ],
        ),
      ),
    );
  }
}
