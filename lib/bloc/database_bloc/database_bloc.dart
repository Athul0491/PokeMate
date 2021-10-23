import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/models/user.dart';
import 'package:pokemate/repositories/database_repository.dart';
import 'database_bloc_files.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  UserData userData;
  DatabaseRepository databaseRepository;

  DatabaseBloc({
    required this.userData,
    required this.databaseRepository,

  }) : super(Fetching()) {
    on<GetRaidBossInfo>(_onGetRaidBossInfo);
    on<GetPVPInfo>(_onGetPVPInfo);
    on<GetWildPokemonInfo>(_onGetWildPokemonInfo);
    on<GetMyPokemons>(_onGetMyPokemons);
    on<AddPokemon>(_onAddPokemon);
    on<UpdatePokemon>(_onUpdatePokemon);
    on<DeletePokemon>(_onDeletePokemon);
  }

  Future<void> _onGetRaidBossInfo(
      GetRaidBossInfo event, Emitter<DatabaseState> emit) async {

  }

  Future<void> _onGetPVPInfo(
      GetPVPInfo event, Emitter<DatabaseState> emit) async {

  }

  Future<void> _onGetWildPokemonInfo(
      GetWildPokemonInfo event, Emitter<DatabaseState> emit) async {

  }

  Future<void> _onGetMyPokemons(
      GetMyPokemons event, Emitter<DatabaseState> emit) async {

  }

  Future<void> _onAddPokemon(
      AddPokemon event, Emitter<DatabaseState> emit) async {

  }

  Future<void> _onUpdatePokemon(
      UpdatePokemon event, Emitter<DatabaseState> emit) async {

  }

  Future<void> _onDeletePokemon(
      DeletePokemon event, Emitter<DatabaseState> emit) async {

  }


}
