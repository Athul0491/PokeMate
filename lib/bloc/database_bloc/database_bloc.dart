import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/models/pokemon_common.dart';
import 'package:pokemate/models/user.dart';
import 'package:pokemate/models/wild_pokemon.dart';
import 'package:pokemate/repositories/api_repository.dart';
import 'package:pokemate/repositories/database_repository.dart';
import 'package:pokemate/repositories/ocr_repository.dart';
import 'package:pokemate/repositories/tensorflow_repository.dart';
import 'database_bloc_files.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  UserData userData;
  DatabaseRepository databaseRepository;
  TensorflowRepository tensorflowRepository = TensorflowRepository();
  OCRRepository ocrRepository = OCRRepository();
  APIRepository apiRepository = APIRepository();
  PokemonJSON pokemonJSON;

  DatabaseBloc({
    required this.userData,
    required this.databaseRepository,
    required this.pokemonJSON,
  }) : super(Fetching()) {
    on<GetRaidBossInfo>(_onGetRaidBossInfo);
    on<GetPVPInfoFromImage>(_onGetPVPInfoFromImage);
    on<GetPVPInfoFromAPI>(_onGetPVPInfoFromAPI);
    on<GetWildPokemonInfoFromImage>(_onGetWildPokemonInfoFromImage);
    on<GetWildPokemonInfoFromAPI>(_onGetWildPokemonInfoFromAPI);
    on<GetMyPokemons>(_onGetMyPokemons);
    on<AddPokemon>(_onAddPokemon);
    on<UpdatePokemon>(_onUpdatePokemon);
    on<DeletePokemon>(_onDeletePokemon);
  }

  Future<void> _onGetRaidBossInfo(
      GetRaidBossInfo event, Emitter<DatabaseState> emit) async {}

  Future<void> _onGetPVPInfoFromImage(
      GetPVPInfoFromImage event, Emitter<DatabaseState> emit) async {
    List<int> ivs = [0, 0, 0];
    String name = '';
    bool errorOccurred = false;
    // TensorFlow Object Detection for IVs
    try {
      emit(Fetching());
      // Load TensorFlow Model
      await tensorflowRepository.loadModel();
      // Run TFLite model
      var recognitions = await tensorflowRepository.predictImage(event.image);
      if (recognitions != null && recognitions.length >= 3) {
        // Extract IVs
        ivs = [];
        // Sort according to y position of the object box
        recognitions.sort((first, second) => (first['rect']['y'] as double)
            .compareTo(second['rect']['y'] as double));
        for (var re in recognitions) {
          // print("${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%");
          ivs.add(
              int.tryParse((re['detectedClass'] as String).substring(2)) ?? 0);
        }
      } else {
        errorOccurred = true;
      }
    } on Exception catch (_) {
      errorOccurred = true;
    }
    // Image Processing and OCR
    try {
      // Preprocess image for OCR on separate Isolate
      await compute(OCRRepository.processImage, event.image.path);
      // Run OCR on file
      name = await ocrRepository.extractPokemonName(event.image.path);
    } on Exception catch (_) {
      errorOccurred = true;
    }
    emit(PVPRaterFormState(ivs: ivs, name: name, errorOccurred: errorOccurred));
  }

  Future<void> _onGetPVPInfoFromAPI(
      GetPVPInfoFromAPI event, Emitter<DatabaseState> emit) async {}

  Future<void> _onGetWildPokemonInfoFromImage(
      GetWildPokemonInfoFromImage event, Emitter<DatabaseState> emit) async {
    emit(Fetching());
    String name = '';
    int cp = 0;
    bool errorOccurred = false;
    // Image Processing and OCR
    try {
      // Preprocess image for OCR on separate Isolate
      await compute(OCRRepository.processImage, event.image.path);
      // Run OCR on file
      var res = await ocrRepository.extractNameAndCP(event.image.path);
      name = res['name'];
      cp = int.tryParse(res['cp']) ?? 0;
    } on Exception catch (_) {
      errorOccurred = true;
    }
    emit(WildPokemonFormState(name: name, cp: cp, errorOccurred: errorOccurred));
  }

  Future<void> _onGetWildPokemonInfoFromAPI(
      GetWildPokemonInfoFromAPI event, Emitter<DatabaseState> emit) async {
    int id = pokemonJSON.getID(event.name);
    var res = await apiRepository.getWildPokemonInfo(id);
    if(res!=null){
      WildPokemon pokemon = WildPokemon.fromAPI(name: event.name, cp: event.cp, data: res);
      print(pokemon);
    } else {
      print('Bruh');
    }
  }

  Future<void> _onGetMyPokemons(
      GetMyPokemons event, Emitter<DatabaseState> emit) async {

  }

  Future<void> _onAddPokemon(
      AddPokemon event, Emitter<DatabaseState> emit) async {}

  Future<void> _onUpdatePokemon(
      UpdatePokemon event, Emitter<DatabaseState> emit) async {}

  Future<void> _onDeletePokemon(
      DeletePokemon event, Emitter<DatabaseState> emit) async {}
}
