import 'package:pokemate/models/pokemon_common.dart';
import 'package:pokemate/models/pokemon_pvp.dart';

class PokemonDB {
  String id;
  String name;
  List<int> ivs;
  List<PokemonType> types;
  String imageUrl;
  String league;

  PokemonDB({
    this.id = '',
    this.name = '',
    this.ivs = const [0, 0, 0],
    this.types = const [],
    this.imageUrl = '',
    this.league = '',
  });

  PokemonDB.fromJson(Map<String, Object?> json, String id)
      : this(
          id: id,
          name: json['name']! as String,
          ivs: [for (var iv in (json['ivs']! as List<dynamic>)) iv],
          types: [
            for (var type in (json['types']! as List<dynamic>)) PokemonType(type)
          ],
          imageUrl: json['imageURL']! as String,
          league: json['league']! as String,
        );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'ivs': ivs,
      'types': [for (PokemonType type in types) type.name],
      'imageURL': imageUrl,
      'league': league,
    };
  }

  PokemonDB.fromPokemonPVP(PokemonPVP pokemon)
      : this(
          id: '',
          name: pokemon.name,
          ivs: pokemon.ivs,
          types: pokemon.types,
          imageUrl: pokemon.imageUrl,
          league: pokemon.league,
        );

  @override
  String toString() {
    return '$name, IVS: $ivs, $types';
  }
}
