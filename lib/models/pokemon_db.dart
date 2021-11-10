import 'package:pokemate/models/pokemon_common.dart';

class PokemonDB {
  String id;
  String name;
  List<int> ivs;
  int cp;
  PokemonType type1;
  PokemonType type2;
  String imageURL;

  PokemonDB(
      {this.id = '',
        this.name = '',
        this.ivs = const [0, 0, 0],
        this.cp = 0,
        this.type1 = const PokemonType.empty(),
        this.type2 = const PokemonType.empty(),
        this.imageURL = ''});

  PokemonDB.fromJson(Map<String, Object?> json, String id)
      : this(
    id: id,
    name: json['name']! as String,
    ivs: json['ivs']! as List<int>,
    cp: json['cp']! as int,
    type1: PokemonType(json['type1'] as String),
    type2: PokemonType(json['type2'] as String),
    imageURL: json['imageURL']! as String,
  );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'ivs': ivs,
      'cp': cp,
      'type1': type1,
      'type2': type2,
      'imageURL': imageURL,
    };
  }

  @override
  String toString() {
    return '$name, IVS: $ivs, CP$cp, $type1-$type2';
  }
}