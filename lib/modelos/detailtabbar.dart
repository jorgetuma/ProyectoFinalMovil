import 'package:flutter/material.dart';

class DetailTabBar extends StatelessWidget {
  const DetailTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
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
                  style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold),),
              ),
              Tab(
                icon: Text(
                  "Estats",
                  style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold),),
              ),
              Tab(
                icon: Text(
                  "Evolutions",
                  style: TextStyle( fontSize: 14, fontWeight: FontWeight.bold),),
              ),
              Tab(
                icon: Text(
                  "Abilities",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
              ),
              Tab(
                icon: Text(
                  "Moves",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            Center(
              child: Text("description"),
            ),
            Center(
              child: Text("Stats"),
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
