import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/models/user.dart';
import 'package:pokemate/repositories/database_repository.dart';
import 'package:pokemate/repositories/tensorflow_repository.dart';
import 'database_bloc_files.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  UserData userData;
  DatabaseRepository databaseRepository;
  TensorflowRepository tensorflowRepository = TensorflowRepository();

  DatabaseBloc({
    required this.userData,
    required this.databaseRepository,
  }) : super(Fetching()) {
    on<GetRaidBossInfo>(_onGetRaidBossInfo);
    on<GetPVPIVs>(_onGetPVPIVs);
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

  Future<void> _onGetPVPIVs(
      GetPVPIVs event, Emitter<DatabaseState> emit) async {
    try {
      emit(Fetching());
      await tensorflowRepository.loadModel();
      var recognitions = await tensorflowRepository.predictImage(event.image);
      if (recognitions!=null && recognitions.length>=3) {
        List<int> ivs = [];
        recognitions.sort((first, second) => (first['rect']['y'] as double)
            .compareTo(second['rect']['y'] as double));
        for (var re in recognitions) {
          // print("${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%");
          ivs.add(int.tryParse((re['detectedClass'] as String).substring(2)) ?? 0);
          // print(ivs);
        }
        emit(PVPRaterFormState(ivs: [ivs[0], ivs[1], ivs[2]], name: 'Lesgooo'));
      } else {

        emit(const PVPRaterFormState(name: ''));
      }
    } on Exception catch (_) {
      emit(const PVPRaterFormState(name: 'SomethingWentWrong'));
    }
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
