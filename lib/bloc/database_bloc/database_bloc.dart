import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/models/pokemon_common.dart';
import 'package:pokemate/models/pokemon_db.dart';
import 'package:pokemate/models/pokemon_pvp.dart';
import 'package:pokemate/models/raid_boss.dart';
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
  late PokemonJSON pokemonJSON;
  late PVPMovesJSON pvpMovesJSON;

  DatabaseBloc({
    required this.userData,
    required this.databaseRepository,
    required BuildContext tempContext,
  }) : super(Init()) {
    DefaultAssetBundle.of(tempContext)
        .loadString("assets/pokemon.json")
        .then((value) {
      pokemonJSON = PokemonJSON(value);
      print('Pokemon JSON loaded');
    });
    DefaultAssetBundle.of(tempContext)
        .loadString("assets/moves.json")
        .then((value) {
      pvpMovesJSON = PVPMovesJSON(value);
      print('Moves JSON loaded');
    });
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
      GetRaidBossInfo event, Emitter<DatabaseState> emit) async {
    emit(const HomePageState(pageState: PageState.loading));
    // PokemonJSON pokemonJSON2 = PokemonJSON(await DefaultAssetBundle.of(event.context)
    //     .loadString("assets/pokemon.json"));
    var raidBossData = await apiRepository.getRaidBossInfo();
    if (raidBossData != null) {
      List<RaidBoss> raidBossList = [];
      for (var raidBoss in raidBossData['raid_table']) {
        raidBossList.add(RaidBoss.fromAPI(
          raidBossData: raidBoss,
          pokemonJSON: pokemonJSON,
        ));
      }
      emit(HomePageState(raidBossList: raidBossList, pageState: PageState.success));
    } else {
      emit(const HomePageState(pageState: PageState.error));
    }
  }

  Future<void> _onGetPVPInfoFromImage(
      GetPVPInfoFromImage event, Emitter<DatabaseState> emit) async {
    List<int> ivs = [];
    String name = '';
    PageState pageState = PageState.success;
    // TensorFlow Object Detection for IVs
    try {
      emit(const PVPRaterFormState(pageState: PageState.loading));
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
        pageState = PageState.error;
      }
    } on Exception catch (_) {
      pageState = PageState.error;
    }
    // Image Processing and OCR
    try {
      // Preprocess image for OCR on separate Isolate/Thread
      await compute(OCRRepository.processImage, event.image.path);
      // Run OCR on file
      name = await ocrRepository.extractPokemonName(event.image.path);
    } on Exception catch (_) {
      pageState = PageState.error;
    }
    emit(PVPRaterFormState(ivs: ivs, name: name, pageState: pageState));
  }

  Future<void> _onGetPVPInfoFromAPI(
      GetPVPInfoFromAPI event, Emitter<DatabaseState> emit) async {
    emit(const PVPRaterPageState(pageState: PageState.loading));
    try {
      int pokemonId = pokemonJSON.getID(event.name);
      var ivData =
          await apiRepository.getPVPIVInfo(event.name, event.ivs, event.league);
      var pvpData =
          await apiRepository.getLeaguePVPInfo(event.name, event.league);
      var pokemonData = await apiRepository.getPVPDetails(pokemonId);
      if (pokemonData != null && pvpData != null && ivData != null) {
        PokemonPVP pokemon = PokemonPVP.fromAPI(
          name: event.name,
          ivs: event.ivs,
          league: event.league,
          pokemonData: pokemonData,
          pvpData: pvpData,
          ivData: ivData,
          pokemonJSON: pokemonJSON,
          pvpMovesJSON: pvpMovesJSON,
        );
        print(pokemon);
        emit(PVPRaterPageState(pokemon: pokemon, pageState: PageState.success));
      } else {
        emit(const PVPRaterPageState(pageState: PageState.error));
      }
    } on Exception catch (_) {
      emit(const PVPRaterPageState(pageState: PageState.error));
    }
  }

  Future<void> _onGetWildPokemonInfoFromImage(
      GetWildPokemonInfoFromImage event, Emitter<DatabaseState> emit) async {
    emit(const WildPokemonFormState(pageState: PageState.loading));
    String name = '';
    int cp = 0;
    // Image Processing and OCR
    try {
      // Preprocess image for OCR on separate Isolate
      await compute(OCRRepository.processImage, event.image.path);
      // Run OCR on file
      var res = await ocrRepository.extractNameAndCP(event.image.path);
      name = res['name'];
      cp = int.tryParse(res['cp']) ?? 0;
      emit(WildPokemonFormState(name: name, cp: cp, pageState: PageState.success));
    } on Exception catch (_) {
      emit(const WildPokemonFormState(pageState: PageState.error));
    }
  }

  Future<void> _onGetWildPokemonInfoFromAPI(
      GetWildPokemonInfoFromAPI event, Emitter<DatabaseState> emit) async {
    emit(const WildPokemonPageState(pageState: PageState.loading));
    try {
      int id = pokemonJSON.getID(event.name);
      var res = await apiRepository.getWildPokemonInfo(id);
      if (res != null) {
        WildPokemon pokemon =
            WildPokemon.fromAPI(name: event.name, cp: event.cp, data: res, pokemonJSON: pokemonJSON);
        print(pokemon);
        emit(WildPokemonPageState(pokemon: pokemon, pageState: PageState.success));
      } else {
        emit(const WildPokemonPageState(pageState: PageState.error));
      }
    } on Exception catch (_) {
      emit(const WildPokemonPageState(pageState: PageState.error));
    }
  }

  Future<void> _onGetMyPokemons(
      GetMyPokemons event, Emitter<DatabaseState> emit) async {
    emit(const MyPokemonsPageState(pageState: PageState.loading));
    try {
      List<PokemonDB> list = await databaseRepository.getPokemons();
      emit(MyPokemonsPageState(pokemonList: list, pageState: PageState.success));
    } on Exception catch (_) {
      emit(const MyPokemonsPageState(pageState: PageState.error));
    }
  }

  Future<void> _onAddPokemon(
      AddPokemon event, Emitter<DatabaseState> emit) async {
    emit(const PokemonDBState(pageState: PageState.loading));
    try {
      PokemonDB pokemonDB = PokemonDB.fromPokemonPVP(event.pokemon);
      await databaseRepository.addPokemon(pokemonDB);
      print('Added to Database');
      emit(const PokemonDBState(pageState: PageState.success));
    } on Exception catch (_) {
      emit(const PokemonDBState(pageState: PageState.error));
    }
  }

  Future<void> _onUpdatePokemon(
      UpdatePokemon event, Emitter<DatabaseState> emit) async {
    emit(const PokemonDBState(pageState: PageState.loading));
    try {
      await databaseRepository.updatePokemon(event.pokemon);
      emit(const PokemonDBState(pageState: PageState.success));
    } on Exception catch (_) {
      emit(const PokemonDBState(pageState: PageState.error));
    }
  }

  Future<void> _onDeletePokemon(
      DeletePokemon event, Emitter<DatabaseState> emit) async {
    emit(const PokemonDBState(pageState: PageState.loading));
    try {
      await databaseRepository.deletePokemon(event.pokemon);
      emit(const PokemonDBState(pageState: PageState.success));
    } on Exception catch (_) {
      emit(const PokemonDBState(pageState: PageState.error));
    }
  }
}
