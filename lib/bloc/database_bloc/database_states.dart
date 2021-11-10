import 'package:equatable/equatable.dart';

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
  @override
  // TODO: implement props
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
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class MyPokemonPageState extends DatabaseState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
