class PokemonEvolve {
  final int id;
  final Chain chain;

  PokemonEvolve({required this.id, required this.chain});

  factory PokemonEvolve.fromJson(Map<String, dynamic> json) {
    return PokemonEvolve(
      id: json['id'],
      chain: Chain.fromJson(json['chain']),
    );
  }
}

class Chain {
  final List<EvolvesTo> evolvesTo;
  final bool isBaby;
  final Species species;

  Chain({required this.evolvesTo, required this.isBaby, required this.species});

  factory Chain.fromJson(Map<String, dynamic> json) {
    return Chain(
      evolvesTo: List<EvolvesTo>.from(json['evolves_to'].map((x) => EvolvesTo.fromJson(x))),
      isBaby: json['is_baby'],
      species: Species.fromJson(json['species']),
    );
  }
}

class EvolvesTo {
  final List<EvolvesTo> evolvesTo;
  final bool isBaby;
  final Species species;

  EvolvesTo({required this.evolvesTo, required this.isBaby, required this.species});

  factory EvolvesTo.fromJson(Map<String, dynamic> json) {
    return EvolvesTo(
      evolvesTo: json['evolves_to'] != null
          ? List<EvolvesTo>.from(json['evolves_to'].map((x) => EvolvesTo.fromJson(x)))
          : [],
      isBaby: json['is_baby'],
      species: Species.fromJson(json['species']),
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