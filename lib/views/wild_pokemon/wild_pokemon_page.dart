import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc_files.dart';
import 'package:pokemate/models/pokemon_common.dart';
import 'package:pokemate/models/wild_pokemon.dart';
import 'package:pokemate/shared/custom_widgets.dart';
import 'package:pokemate/shared/loading.dart';
import 'package:pokemate/themes/theme_notifiers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemate/views/pvp_iv/pvp_rater_page.dart';

class WildPokemonPage extends StatefulWidget {
  final String name;
  final int cp;

  const WildPokemonPage({Key? key, required this.name, required this.cp})
      : super(key: key);

  @override
  _WildPokemonPageState createState() => _WildPokemonPageState();
}

class _WildPokemonPageState extends State<WildPokemonPage> {
  WildPokemon pokemon = WildPokemon(name: 'null');

  @override
  void initState() {
    super.initState();
    context
        .read<DatabaseBloc>()
        .add(GetWildPokemonInfoFromAPI(name: widget.name, cp: widget.cp));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.read<ThemeNotifier>();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<DatabaseBloc, DatabaseState>(
          listener: (context, state) async {
            if (state is WildPokemonPageState) {
              if (state.pageState == PageState.success) {
                pokemon = state.pokemon!;
              }
            }
          },
          builder: (context, state) {
            if (state is WildPokemonPageState) {
              if (state.pageState == PageState.loading) {
                return const Loading();
              }
              // TODO error handling
            }
            if (pokemon.name == 'null') {
              return const Loading();
            }
            return Container(
              decoration: BoxDecoration(image: colors.bgImage),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 25.w),
                          const CustomBackButton(),
                          SizedBox(height: 25.w),
                          Text(
                            pokemon.name,
                            style: TextStyle(
                              fontSize: 45,
                              fontWeight: FontWeight.w500,
                              color: colors.t1,
                            ),
                          ),
                          PokemonTypeList(types: pokemon.types),
                          SizedBox(height: 5.w),
                          Stack(
                            children: [
                              Container(
                                height: 250.w,
                                alignment: Alignment.topLeft,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 9.w),
                                      child: Text(
                                        'CP ',
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w400,
                                          color: colors.t1,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${pokemon.cp}',
                                      style: TextStyle(
                                        fontSize: 45,
                                        fontWeight: FontWeight.w500,
                                        color: colors.t1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 250.w,
                                alignment: Alignment.centerRight,
                                child: Image.network(pokemon.imageUrl),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.w),
                        ],
                      ),
                    ),
                    Card(
                      elevation: 5,
                      color: colors.bg2,
                      margin: EdgeInsets.only(bottom: 15.w),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30.w))),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20.w),
                            _buildHead(colors, 'Pokemon Details'),
                            // _buildDetails(colors, 'Est. Lvl:             ',
                            //     pokemon.estimatedLevel),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Est. Lvl:',
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w400,
                                    color: colors.t1,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    pokemon.estimatedLevel,
                                    style: TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.w600,
                                      color: colors.t1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.w),
                            _buildDetails(colors, 'Capture Rate:',
                                '${pokemon.captureRate}%'),
                            SizedBox(height: 10.w),
                            _buildDetails(colors, 'Flee Rate:        ',
                                '${pokemon.fleeRate}%'),
                            SizedBox(height: 25.w),
                            _buildHead(colors, 'Type effectiveness'),
                            TypeEffectivenessSection(
                                label: 'Weakness', list: pokemon.weakness),
                            SizedBox(height: 15.w),
                            TypeEffectivenessSection(
                                label: 'Resistance', list: pokemon.resistance),
                            SizedBox(height: 50.w),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Row _buildDetails(ThemeNotifier colors, String field, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: 9.w, right: 15.w),
            child: Text(
              field,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w400,
                color: colors.t1,
              ),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w500,
              color: colors.t1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHead(ThemeNotifier colors, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.w),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: colors.accent,
        ),
      ),
    );
  }
}
