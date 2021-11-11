import 'package:equatable/equatable.dart';
import 'package:pokemate/models/pokemon_db.dart';
import 'package:pokemate/models/pokemon_pvp.dart';
import 'package:pokemate/models/raid_boss.dart';
import 'package:pokemate/models/wild_pokemon.dart';

abstract class DatabaseState extends Equatable {
  const DatabaseState();

  @override
  List<Object?> get props => [];
}

class Init extends DatabaseState {
  @override
  List<Object?> get props => ['Init'];
}

class HomePageState extends DatabaseState {
  final List<RaidBoss>? raidBossList;
  final PageState pageState;

  const HomePageState({this.raidBossList, required this.pageState});

  @override
  List<Object?> get props => [raidBossList, pageState];
}

class PVPRaterFormState extends DatabaseState {
  final String? name;
  final List<int>? ivs;
  final PageState pageState;

  const PVPRaterFormState({
    this.name,
    this.ivs,
    required this.pageState,
  });

  @override
  List<Object?> get props => [name, ivs, pageState];
}

class PVPRaterPageState extends DatabaseState {
  final PokemonPVP? pokemon;
  final PageState pageState;

  const PVPRaterPageState({this.pokemon, required this.pageState});

  @override
  List<Object?> get props => [pokemon, pageState];
}

class WildPokemonFormState extends DatabaseState {
  final String? name;
  final int? cp;
  final PageState pageState;

  const WildPokemonFormState({
    this.name,
    this.cp,
    this.pageState = PageState.success,
  });

  @override
  List<Object?> get props => [name, cp, pageState];
}

class WildPokemonPageState extends DatabaseState {
  final WildPokemon? pokemon;
  final PageState pageState;

  const WildPokemonPageState({this.pokemon, required this.pageState});

  @override
  List<Object?> get props => [pokemon, pageState];
}

class MyPokemonPageState extends DatabaseState {
  final List<PokemonDB>? list;
  final PageState pageState;

  const MyPokemonPageState({this.list, required this.pageState});

  @override
  List<Object?> get props => [list, pageState];
}

enum PageState { success, loading, error }
