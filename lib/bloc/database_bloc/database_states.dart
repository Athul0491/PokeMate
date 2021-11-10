import 'package:equatable/equatable.dart';
import 'package:pokemate/models/pokemon_pvp.dart';
import 'package:pokemate/models/wild_pokemon.dart';

abstract class DatabaseState extends Equatable {
  const DatabaseState();

  @override
  List<Object?> get props => [];
}

class Fetching extends DatabaseState {
  @override
  List<Object?> get props => ['Fetching'];
}

class HomePageState extends DatabaseState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class PVPRaterFormState extends DatabaseState {
  final String name;
  final List<int> ivs;
  final bool errorOccurred;

  const PVPRaterFormState({
    this.name = '',
    this.ivs = const [0, 0, 0],
    this.errorOccurred = false,
  });

  @override
  List<Object?> get props => [name, ivs, errorOccurred];
}

class PVPRaterPageState extends DatabaseState {
  final PokemonPVP pokemon;

  const PVPRaterPageState(this.pokemon);

  @override
  List<Object?> get props => throw UnimplementedError();
}

class WildPokemonFormState extends DatabaseState {
  final String name;
  final int cp;
  final bool errorOccurred;

  const WildPokemonFormState({
    this.name = '',
    this.cp = 0,
    this.errorOccurred = false,
  });

  @override
  List<Object?> get props => [name, cp, errorOccurred];
}

class WildPokemonPageState extends DatabaseState {
  final WildPokemon pokemon;

  const WildPokemonPageState(this.pokemon);

  @override
  List<Object?> get props => [pokemon];
}

class MyPokemonPageState extends DatabaseState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class FetchFailed extends DatabaseState {
  final String errorMessage;

  const FetchFailed(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
