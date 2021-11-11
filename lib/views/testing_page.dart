import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc.dart';
import 'package:pokemate/models/pokemon_common.dart';
import 'package:pokemate/models/pokemon_pvp.dart';
import 'package:pokemate/repositories/api_repository.dart';
import 'package:pokemate/themes/theme_notifiers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Map<String, dynamic>? ivData = {};
  Map<String, dynamic>? pvpData = {};
  Map<String, dynamic>? pokemonData = {};
  String name = 'Charizard';
  List<int> ivs = [0, 14, 15];
  String league = 'ultra';

  @override
  Widget build(BuildContext context) {
    final colors = context.read<ThemeNotifier>();
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(colors.bgImagePath), fit: BoxFit.cover),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(
              'TestScreen',
              style: TextStyle(
                fontSize: 30,
                color: colors.t1,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: colors.accent),
              child: Text(
                'API',
                style: TextStyle(
                  fontSize: 20,
                  color: colors.onAccent,
                ),
              ),
              onPressed: () async {
                PokemonJSON pokemonJSON = context.read<DatabaseBloc>().pokemonJSON;
                APIRepository apiRepository = APIRepository();
                int pokemonId = pokemonJSON.getID(name);
                ivData = await apiRepository.getPVPIVInfo(name, ivs, league);
                pvpData = await apiRepository.getLeaguePVPInfo(name, league);
                pokemonData = await apiRepository.getPVPDetails(pokemonId);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: colors.accent),
              child: Text(
                'model',
                style: TextStyle(
                  fontSize: 20,
                  color: colors.onAccent,
                ),
              ),
              onPressed: () async {
                PokemonJSON pokemonJSON = context.read<DatabaseBloc>().pokemonJSON;
                PVPMovesJSON pvpMovesJSON = context.read<DatabaseBloc>().pvpMovesJSON;
                if (pokemonData != null && pvpData!=null && ivData!=null) {
                  PokemonPVP pokemon = PokemonPVP.fromAPI(
                    name: name,
                    ivs: ivs,
                    league: league,
                    pokemonData: pokemonData!,
                    pvpData: pvpData!,
                    ivData: ivData!,
                    pokemonJSON: pokemonJSON,
                    pvpMovesJSON: pvpMovesJSON,
                  );
                  print(pokemon);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}