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

class PVPRaterPageState extends DatabaseState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
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
