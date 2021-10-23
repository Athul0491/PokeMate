import 'package:pokemate/models/pokemon_common.dart';

class PokemonPVP {
  final String name;
  final List<int> ivs;
  final int cp;
  final PokemonType type1;
  final PokemonType type2;
  final TypeEffect weakness;
  final TypeEffect resistance;
  final PVPStats pvpStats;

  PokemonPVP({
    this.name = '',
    this.ivs = const [0, 0, 0],
    this.cp = 0,
    this.type1 = PokemonType.normal,
    this.type2 = PokemonType.normal,
    this.weakness = const TypeEffect(),
    this.resistance = const TypeEffect(),
    this.pvpStats = const PVPStats(),
  });
}

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
