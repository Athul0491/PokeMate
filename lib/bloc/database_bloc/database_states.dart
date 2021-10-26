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

  const PVPRaterFormState({this.name = '', this.ivs = const [0,0,0]});

  @override
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
