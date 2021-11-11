import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:pokemate/models/pokemon_db.dart';

abstract class DatabaseEvent extends Equatable {
  const DatabaseEvent();

  @override
  List<Object?> get props => [];
}

class GetRaidBossInfo extends DatabaseEvent {
  final BuildContext context;

  const GetRaidBossInfo(this.context);

  @override
  List<Object?> get props => [];
}

class GetPVPInfoFromImage extends DatabaseEvent {
  final File image;

  const GetPVPInfoFromImage({required this.image});

  @override
  List<Object?> get props => [image];
}

class GetPVPInfoFromAPI extends DatabaseEvent {
  final String name;
  final List<int> ivs;
  final String league;

  const GetPVPInfoFromAPI({
    required this.name,
    required this.ivs,
    required this.league,
  });

  @override
  List<Object?> get props => [name, ivs, league];
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
  List<Object?> get props => [];
}

class AddPokemon extends DatabaseEvent {
  final PokemonDB pokemon;

  const AddPokemon(this.pokemon);

  @override
  List<Object?> get props => [pokemon];
}

class UpdatePokemon extends DatabaseEvent {
  final PokemonDB pokemon;

  const UpdatePokemon(this.pokemon);

  @override
  List<Object?> get props => [pokemon];
}

class DeletePokemon extends DatabaseEvent {
  final PokemonDB pokemon;

  const DeletePokemon(this.pokemon);

  @override
  List<Object?> get props => [pokemon];
}
