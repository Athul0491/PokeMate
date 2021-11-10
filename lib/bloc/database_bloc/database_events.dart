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

class GetPVPInfoFromImage extends DatabaseEvent {
  final File image;

  const GetPVPInfoFromImage({required this.image});

  @override
  List<Object?> get props => [image];
}

class GetPVPInfoFromAPI extends DatabaseEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class GetWildPokemonInfoFromImage extends DatabaseEvent {
  final File image;

  const GetWildPokemonInfoFromImage({required this.image});

  @override
  List<Object?> get props => [image];
}

class GetWildPokemonInfoFromAPI extends DatabaseEvent {
  final String name;
  final int cp;

  const GetWildPokemonInfoFromAPI({required this.name, required this.cp});

  @override
  List<Object?> get props => [name, cp];
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
