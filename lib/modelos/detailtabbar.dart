import 'package:flutter/material.dart';
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
                          title: Text(
                            '${stat.stat.name}: ${stat.baseStat}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: LinearProgressIndicator(
                            value: stat.baseStat /
                                100.0, // Asumiendo un rango de 0-100
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
