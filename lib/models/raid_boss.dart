import 'package:pokemate/models/pokemon_common.dart';
import 'package:pokemate/shared/shared_methods.dart';

class RaidBoss {
  late String name;
  late String cpRange;
  late String boostedCpRange;
  late String tier;
  late String imageUrl;
  late List<PokemonType> types;

  RaidBoss.fromAPI({
    required Map<String, dynamic> raidBossData,
    required PokemonJSON pokemonJSON,
  }) {
    name = raidBossData['name'];
    cpRange = raidBossData['cpRange'];
    boostedCpRange = raidBossData['cpWeather'];
    tier = raidBossData['tier'];
    imageUrl = pokemonJSON.getImage(name.split(' ').last);
    types = pokemonJSON.getTypes(name.split(' ').last);
  }
}

class RaidBossComplete {
  late String name;
  late String cpRange;
  late String boostedCpRange;
  late String tier;
  late String imageUrl;
  late List<PokemonType> types;
  late List<TypeEffect> weakness;
  late List<TypeEffect> resistance;
  late List<String> stats;

  RaidBossComplete.fromAPI({
    required Map<String, dynamic> raidBossData,
    required Map<String, dynamic> pokemonData,
    required PokemonJSON pokemonJSON,
  }) {
    name = raidBossData['name'];
    cpRange = raidBossData['cpRange'];
    boostedCpRange = raidBossData['cpWeather'];
    tier = raidBossData['tier'];
    imageUrl = pokemonJSON.getImage(name.split(' ').last);
    types = [];
    for (int i = 0; i < (pokemonData['Types'] as List).length; i++) {
      types.add(PokemonType(pokemonData['Types'][i]['$i']));
    }
    weakness = [];
    for (var type in pokemonData['Vulnerable']) {
      String multiplier = type['multiplier'] ?? '0%';
      String name = type['name'] ?? 'Normal';
      multiplier = multiplier.substring(0, multiplier.length - 1);
      weakness.add(TypeEffect(
        type: PokemonType(name.capitalize()),
        multiplier: double.tryParse(multiplier)!,
      ));
    }
    resistance = [];
    for (var type in pokemonData['Resistant']) {
      String multiplier = type['multiplier'] ?? '0%';
      String name = type['name'] ?? 'Normal';
      multiplier = multiplier.substring(0, multiplier.length - 1);
      resistance.add(TypeEffect(
        type: PokemonType(name.capitalize()),
        multiplier: double.tryParse(multiplier)!,
      ));
    }
    stats = (pokemonData['Stats'] as String).split(',');
  }
}
