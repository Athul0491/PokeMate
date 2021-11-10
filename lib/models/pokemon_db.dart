import 'package:pokemate/models/pokemon_common.dart';

class PokemonDB {
  String id;
  String name;
  List<int> ivs;
  int cp;
  List<PokemonType> types;
  String imageURL;

  PokemonDB(
      {this.id = '',
      this.name = '',
      this.ivs = const [0, 0, 0],
      this.cp = 0,
      this.types = const [],
      this.imageURL = ''});

  PokemonDB.fromJson(Map<String, Object?> json, String id)
      : this(
          id: id,
          name: json['name']! as String,
          ivs: json['ivs']! as List<int>,
          cp: json['cp']! as int,
          types: [
            for (var type in json['types']! as List<String>) PokemonType(type)
          ],
          imageURL: json['imageURL']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'ivs': ivs,
      'cp': cp,
      'types': [for (PokemonType type in types) type.name],
      'imageURL': imageURL,
    };
  }

  @override
  String toString() {
    return '$name, IVS: $ivs, CP$cp, $types';
  }
}
