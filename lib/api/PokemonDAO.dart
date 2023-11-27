class PokemonDAO {
  final int id;
  final String name;
  final String type;
  final bool isFavorite;

  PokemonDAO({
    required this.id,
    required this.name,
    required this.type,
    required this.isFavorite,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['isFavorite'] = this.isFavorite ? 1 : 0;

    return data;
  }

  PokemonDAO.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        type = map['type'], // Convert type back to List<String>
        isFavorite = map['isFavorite'] == 1 ? true : false;
}
