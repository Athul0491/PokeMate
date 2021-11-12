import 'package:pokemate/models/pokemon_common.dart';
import 'package:pokemate/shared/shared_methods.dart';

class PokemonPVP {
  final String name;
  final List<int> ivs;
  final String league;
  late List<PokemonType> types;
  late List<TypeEffect> weakness;
  late List<TypeEffect> resistance;
  late String imageUrl;
  late List<String> stats;
  late IVStats userIVStats;
  late IVStats bestIVStats;
  late PVPMetaDetails metaDetails;
  late List<PVPMove> fastMoves;
  late List<PVPMove> chargedMoves;
  late List<PVPMove> bestMoveSet;

  PokemonPVP({
    this.name = '',
    this.ivs = const [0, 0, 0],
    this.league = '',
  });

  PokemonPVP.fromAPI({
    required this.name,
    required this.ivs,
    required this.league,
    required Map<String, dynamic> pokemonData,
    required Map<String, dynamic> pvpData,
    required Map<String, dynamic> ivData,
    required PokemonJSON pokemonJSON,
    required PVPMovesJSON pvpMovesJSON,
  }) {
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
    imageUrl = pokemonJSON.getImage(name);
    stats = (pokemonData['Stats'] as String).split(',');
    String perfStr = ivData['user_pokemon']['perfection'];
    userIVStats = IVStats(
      rank: int.tryParse(ivData['user_pokemon']['rank']) ?? 0,
      ivs: ivs,
      lvl: double.tryParse(ivData['user_pokemon']['lvl']) ?? 0,
      cp: int.tryParse(ivData['user_pokemon']['cp']) ?? 0,
      perfectionPercent:
          double.tryParse(perfStr.substring(0, perfStr.length - 1)) ?? 0,
    );
    perfStr = ivData['rank1_pokemon']['perfection'];
    bestIVStats = IVStats(
      rank: int.tryParse(ivData['rank1_pokemon']['rank']) ?? 0,
      ivs: [
        int.tryParse(ivData['rank1_pokemon']['att']) ?? 0,
        int.tryParse(ivData['rank1_pokemon']['def']) ?? 0,
        int.tryParse(ivData['rank1_pokemon']['hp']) ?? 0,
      ],
      lvl: double.tryParse(ivData['rank1_pokemon']['lvl']) ?? 0,
      cp: int.tryParse(ivData['rank1_pokemon']['cp']) ?? 0,
      perfectionPercent:
          double.tryParse(perfStr.substring(0, perfStr.length - 1)) ?? 0,
    );
    List<PVPMatchUp> keyWins = [];
    print(pvpData);
    for (var matchUpData in pvpData['matchups']) {
      String name = (matchUpData['opponent'] as String).split('_').first;
      keyWins.add(PVPMatchUp(
        name: (matchUpData['opponent'] as String).replaceAll('_', ' ').capitalize(),
        rating: matchUpData['rating'],
        type: pokemonJSON.getTypes(name),
        imageUrl: pokemonJSON.getImage(name),
      ));
    }
    List<PVPMatchUp> keyLosses = [];
    for (var matchUpData in pvpData['counters']) {
      String name = (matchUpData['opponent'] as String).split('_').first;
      keyLosses.add(PVPMatchUp(
        name: (matchUpData['opponent'] as String).replaceAll('_', ' ').capitalize(),
        rating: matchUpData['rating'],
        type: pokemonJSON.getTypes(name),
        imageUrl: pokemonJSON.getImage(name),
      ));
    }
    metaDetails = PVPMetaDetails(
      rank: (pvpData['rank']),
      rating: (pvpData['rating']),
      overallScore: pvpData['score'],
      scores: [
        for (var score in pvpData['scores'])
          (score is double) ? score : (score as int).floorToDouble(),
      ],
      keyWins: keyWins,
      keyLosses: keyLosses,
    );
    fastMoves = [];
    for (var move in pvpData['moves']['fastMoves']) {
      fastMoves.add(pvpMovesJSON.getMoveSet(move['moveId']));
    }
    chargedMoves = [];
    for (var move in pvpData['moves']['chargedMoves']) {
      chargedMoves.add(pvpMovesJSON.getMoveSet(move['moveId']));
    }
    bestMoveSet = [];
    for (var move in pvpData['moveset']) {
      bestMoveSet.add(pvpMovesJSON.getMoveSet(move));
    }
  }

  @override
  String toString() {
    return '$name - $ivs, #${metaDetails.rank}';
  }
}

class IVStats {
  final int rank;
  final List<int> ivs;
  final double lvl;
  final int cp;
  final double perfectionPercent;

  const IVStats({
    this.rank = 0,
    this.ivs = const [0, 0, 0],
    this.lvl = 0,
    this.cp = 0,
    this.perfectionPercent = 0.0,
  });
}

class PVPMetaDetails {
  final int rank;
  final int rating;
  final double overallScore;
  final List<double> scores;
  final List<PVPMatchUp> keyWins;
  final List<PVPMatchUp> keyLosses;

  const PVPMetaDetails({
    this.rank = 0,
    this.rating = 0,
    this.keyWins = const [],
    this.keyLosses = const [],
    this.overallScore = 0,
    this.scores = const [],
  });
}

class PVPMatchUp {
  final String name;
  final String imageUrl;
  final List<PokemonType> type;
  final int rating;

  const PVPMatchUp({
    this.name = '',
    this.imageUrl = '',
    this.rating = 0,
    this.type = const [],
  });
}

class PVPMove {
  final String name;
  final PokemonType type;
  final String archetype;

  const PVPMove({
    this.name = '',
    this.type = const PokemonType.empty(),
    this.archetype = '',
  });
}
