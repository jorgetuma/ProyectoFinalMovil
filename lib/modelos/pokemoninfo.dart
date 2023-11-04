import 'package:flutter/foundation.dart';

class PokemonInfo {
  List<Ability> abilities;
  int baseExperience;
  List<Form> forms;
  List<GameIndex> gameIndices;
  int height;
  List<dynamic> heldItems;
  int id;
  bool isDefault;
  String locationAreaEncounters;
  List<Move> moves;
  List<Stat> stats;
  List<Type> types;
  int weight;

  PokemonInfo({
    required this.abilities,
    required this.baseExperience,
    required this.forms,
    required this.gameIndices,
    required this.height,
    required this.heldItems,
    required this.id,
    required this.isDefault,
    required this.locationAreaEncounters,
    required this.moves,
    required this.stats,
    required this.types,
    required this.weight,
  });

  factory PokemonInfo.fromJson(Map<String, dynamic> json) {
    return PokemonInfo(
      abilities: (json['abilities'] as List)
          .map((ability) => Ability.fromJson(ability))
          .toList(),

      baseExperience:
      json['base_experience'] ?? 0,
      forms: (json['forms'] as List)
          .map((form) => Form.fromJson(form))
          .toList(),
      gameIndices: (json['game_indices'] as List)
          .map((gameIndex) => GameIndex.fromJson(gameIndex))
          .toList(),
      height: json['height'],
      heldItems: json['held_items'],
      id: json['id'],
      isDefault: json['is_default'],
      locationAreaEncounters: json['location_area_encounters'],
      moves: (json['moves'] as List)
          .map((move) => Move.fromJson(move))
          .toList(),
      stats: (json['stats'] as List)
          .map((stat) => Stat.fromJson(stat))
          .toList(),
      types: (json['types'] as List)
          .map((type) => Type.fromJson(type))
          .toList(),
      weight: json['weight'],
    );
  }
}
class Ability {
  Ability({required this.ability, required this.isHidden, required this.slot});
  final NamedResource ability;
  final bool isHidden;
  final int slot;

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      ability: NamedResource.fromJson(json['ability']),
      isHidden: json['is_hidden'],
      slot: json['slot'],
    );
  }
}

class NamedResource {
  NamedResource({required this.name, required this.url});
  final String name;
  final String url;

  factory NamedResource.fromJson(Map<String, dynamic> json) {
    return NamedResource(
      name: json['name'],
      url: json['url'],
    );
  }
}

class Form {
  Form({required this.name, required this.url});
  final String name;
  final String url;

  factory Form.fromJson(Map<String, dynamic> json) {
    return Form(
      name: json['name'],
      url: json['url'],
    );
  }
}

class GameIndex {
  GameIndex({required this.gameIndex, required this.version});
  final int gameIndex;
  final NamedResource version;

  factory GameIndex.fromJson(Map<String, dynamic> json) {
    return GameIndex(
      gameIndex: json['game_index'],
      version: NamedResource.fromJson(json['version']),
    );
  }
}

class Move {
  Move({required this.move, required this.versionGroupDetails});
  final NamedResource move;
  final List<VersionGroupDetail> versionGroupDetails;

  factory Move.fromJson(Map<String, dynamic> json) {
    return Move(
      move: NamedResource.fromJson(json['move']),
      versionGroupDetails: (json['version_group_details'] as List)
          .map((detail) => VersionGroupDetail.fromJson(detail))
          .toList(),
    );
  }
}

class VersionGroupDetail {
  VersionGroupDetail({
    required this.levelLearnedAt,
    required this.moveLearnMethod,
    required this.versionGroup,
  });
  final int levelLearnedAt;
  final NamedResource moveLearnMethod;
  final NamedResource versionGroup;

  factory VersionGroupDetail.fromJson(Map<String, dynamic> json) {
    return VersionGroupDetail(
      levelLearnedAt: json['level_learned_at'],
      moveLearnMethod: NamedResource.fromJson(json['move_learn_method']),
      versionGroup: NamedResource.fromJson(json['version_group']),
    );
  }
}
  class Stat {
  Stat({required this.baseStat, required this.effort, required this.stat});
  final int baseStat;
  final int effort;
  final NamedResource stat;

  factory Stat.fromJson(Map<String, dynamic> json) {
  return Stat(
  baseStat: json['base_stat'],
  effort: json['effort'],
  stat: NamedResource.fromJson(json['stat']),
  );
  }
  }

  class Type {
  Type({required this.slot, required this.type});
  final int slot;
  final NamedResource type;

  factory Type.fromJson(Map<String, dynamic> json) {
  return Type(
  slot: json['slot'],
  type: NamedResource.fromJson(json['type']),
  );
  }
  }
