class Specie {
  EvolutionChain evolutionChain;
  List<FlavorTextEntry> flavorTextEntries;

  Specie({
    required this.evolutionChain,
    required this.flavorTextEntries,
  });

  factory Specie.fromJson(Map<String, dynamic> json) {
    return Specie(
      evolutionChain: EvolutionChain.fromJson(json['evolution_chain']),
      flavorTextEntries: (json['flavor_text_entries'] as List)
          .map((entry) => FlavorTextEntry.fromJson(entry))
          .toList(),
    );
  }
}

class PokeColor {
  String name;
  String url;

  PokeColor({
    required this.name,
    required this.url,
  });

  factory PokeColor.fromJson(Map<String, dynamic> json) {
    return PokeColor(
      name: json['name'],
      url: json['url'],
    );
  }
}

class EggGroup {
  String name;
  String url;

  EggGroup({
    required this.name,
    required this.url,
  });

  factory EggGroup.fromJson(Map<String, dynamic> json) {
    return EggGroup(
      name: json['name'],
      url: json['url'],
    );
  }
}

class EvolutionChain {
  String url;

  EvolutionChain({
    required this.url,
  });

  factory EvolutionChain.fromJson(Map<String, dynamic> json) {
    return EvolutionChain(
      url: json['url'],
    );
  }
}

class FlavorTextEntry {
  String flavorText;
  Language language;
  Version version;

  FlavorTextEntry({
    required this.flavorText,
    required this.language,
    required this.version,
  });

  factory FlavorTextEntry.fromJson(Map<String, dynamic> json) {
    return FlavorTextEntry(
      flavorText: json['flavor_text'],
      language: Language.fromJson(json['language']),
      version: Version.fromJson(json['version']),
    );
  }
}

class Language {
  String name;
  String url;

  Language({
    required this.name,
    required this.url,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      name: json['name'],
      url: json['url'],
    );
  }
}

class Version {
  String name;
  String url;

  Version({
    required this.name,
    required this.url,
  });

  factory Version.fromJson(Map<String, dynamic> json) {
    return Version(
      name: json['name'],
      url: json['url'],
    );
  }
}