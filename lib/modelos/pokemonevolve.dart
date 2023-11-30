class PokemonEvolve {
  final int id;
  final Chain chain;

  PokemonEvolve({required this.id, required this.chain});

  factory PokemonEvolve.fromJson(Map<String, dynamic> json) {
    return PokemonEvolve(
      id: json['id'],
      chain: Chain.fromJson(json['chain'] as Map<String, dynamic>),
    );
  }
}

class Chain {
  final List<Chain> evolvesTo;
  final bool isBaby;
  final Species species;

  Chain({required this.evolvesTo, required this.isBaby, required this.species});

  factory Chain.fromJson(Map<String, dynamic> json) {
    var evolvesToList = json['evolves_to'] as List;
    List<Chain> evolvesTo = evolvesToList.map((entry) => Chain.fromJson(entry)).toList();
    return Chain(
      evolvesTo: evolvesTo,
      isBaby: json['is_baby'],
      species: Species.fromJson(json['species'] as Map<String, dynamic>),
    );
  }
}

class Species {
  final String name;
  final String url;

  Species({required this.name, required this.url});

  factory Species.fromJson(Map<String, dynamic> json) {
    return Species(
      name: json['name'],
      url: json['url'],
    );
  }
}