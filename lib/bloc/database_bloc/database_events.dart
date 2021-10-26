import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class DatabaseEvent extends Equatable {
  const DatabaseEvent();

  @override
  List<Object?> get props => [];
}

class GetRaidBossInfo extends DatabaseEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class GetPVPIVs extends DatabaseEvent {
  final File image;

  const GetPVPIVs({required this.image});

  @override
  List<Object?> get props => [image];
}

class GetPVPInfo extends DatabaseEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class GetWildPokemonInfo extends DatabaseEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class GetMyPokemons extends DatabaseEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class AddPokemon extends DatabaseEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class UpdatePokemon extends DatabaseEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class DeletePokemon extends DatabaseEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
