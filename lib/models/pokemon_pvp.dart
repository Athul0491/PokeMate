import 'package:pokemate/models/pokemon_common.dart';

class PokemonPVP {
  final String name;
  final List<int> ivs;
  late PokemonType type1;
  late PokemonType type2;
  late List<TypeEffect> weakness;
  late List<TypeEffect> resistance;
  late PVPStats pvpStats;

  PokemonPVP({
    this.name = '',
    this.ivs = const [0, 0, 0],
    this.type1 = const PokemonType.empty(),
    this.type2 = const PokemonType.empty(),
    this.weakness = const [],
    this.resistance = const [],
    this.pvpStats = const PVPStats(),
  });

  PokemonPVP.fromAPI({
    required this.name,
    required this.ivs,
    required Map<String, dynamic> pokemonData,
    required Map<String, dynamic> pvpData,
    required Map<String, dynamic> ivData,
  }) {
    type1 = PokemonType(pokemonData['Types'][0]['0']);
    if ({pokemonData['Types'] as List}.length > 1) {
      type2 = PokemonType(pokemonData['Types'][1]['1']);
    } else {
      type2 = const PokemonType.empty();
    }
  }
}

// var data = {
//   speciesId: swampert,
//   speciesName: Swampert,
//   rating: 704,
//   matchups: [
//     {opponent: giratina_altered, rating: 525},
//     {opponent: melmetal, rating: 838},
//     {opponent: muk_alolan, rating: 883},
//     {opponent: escavalier, rating: 718},
//     {opponent: charizard, rating: 565}
//   ],
//   counters: [
//     {opponent: cresselia, rating: 310},
//     {opponent: togekiss, rating: 472},
//     {opponent: obstagoon, rating: 403},
//     {opponent: articuno, rating: 354},
//     {opponent: venusaur, rating: 415}
//   ],
//   moves: {
//     fastMoves: [
//       {moveId: WATER_GUN, uses: 32129},
//       {moveId: MUD_SHOT, uses: 48271}
//     ],
//     chargedMoves: [
//       {moveId: SURF, uses: 10475},
//       {moveId: SLUDGE_WAVE, uses: 6938},
//       {moveId: RETURN, uses: 6105},
//       {moveId: MUDDY_WATER, uses: 12049},
//       {moveId: HYDRO_CANNON, uses: 31348},
//       {moveId: EARTHQUAKE, uses: 13516}
//     ]
//   },
//   moveset: [MUD_SHOT, HYDRO_CANNON, EARTHQUAKE],
//   score: 92.4,
//   scores: [94.4, 90.4, 89.1, 97.5, 77.6, 88.1],
//   rank: 5,
// }

class PVPStats {
  final int rank;
  final double lvl;
  final int cp;
  final double perfectionPercent;

  const PVPStats({
    this.rank = 0,
    this.lvl = 0,
    this.cp = 0,
    this.perfectionPercent = 0.0,
  });
}
