class PokemonDB {
  String id;
  String name;
  List<int> ivs;
  int cp;
  PokemonType type1;
  PokemonType type2;

  PokemonDB({
    this.id = '',
    this.name = '',
    this.ivs = const [0, 0, 0],
    this.cp = 0,
    this.type1 = PokemonType.normal,
    this.type2 = PokemonType.normal,
  });

  PokemonDB.fromJson(Map<String, Object?> json, String id)
      : this(
          id: id,
          name: json['name']! as String,
          ivs: json['ivs']! as List<int>,
          cp: json['cp']! as int,
          type1: PokemonType.values[(json['type1'] as int)],
          type2: PokemonType.values[(json['type2'] as int)],
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'ivs': ivs,
      'cp': cp,
      'type1': type1,
      'type2': type2,
    };
  }

  @override
  String toString(){
    return '$name, IVS: $ivs, CP$cp, $type1-$type2';
  }
}

class TypeEffect {
  final PokemonType type;
  final double multiplier;

  const TypeEffect({
    this.type = PokemonType.normal,
    this.multiplier = 1.0,
  });
}

enum PokemonType {
  normal,
  fire,
  water,
  electric,
  grass,
  ice,
  fighting,
  poison,
  ground,
  flying,
  psychic,
  bug,
  rock,
  ghost,
  dragon,
  dark,
  steel,
  fairy,
}
