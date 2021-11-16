import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc_files.dart';
import 'package:pokemate/models/pokemon_common.dart';
import 'package:pokemate/models/pokemon_db.dart';
import 'package:pokemate/models/pokemon_pvp.dart';
import 'package:pokemate/shared/custom_snackbar.dart';
import 'package:pokemate/shared/custom_widgets.dart';
import 'package:pokemate/shared/loading.dart';
import 'package:pokemate/themes/theme_notifiers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PVPRaterPage extends StatefulWidget {
  final String? name;
  final List<int>? ivs;
  final String? league;
  final PokemonDB? pokemonDB;

  const PVPRaterPage({
    Key? key,
    this.name,
    this.ivs,
    this.league,
    this.pokemonDB,
  }) : super(key: key);

  @override
  _PVPRaterPageState createState() => _PVPRaterPageState();
}

class _PVPRaterPageState extends State<PVPRaterPage> {
  PokemonPVP pokemon = PokemonPVP(name: 'null');
  PokemonDB pokemonDB = PokemonDB(name: 'null');

  @override
  void initState() {
    super.initState();
    if (widget.pokemonDB == null) {
      context.read<DatabaseBloc>().add(GetPVPInfoFromAPI(
          name: widget.name!, ivs: widget.ivs!, league: widget.league!));
    } else {
      pokemonDB = widget.pokemonDB!;
      context.read<DatabaseBloc>().add(GetPVPInfoFromAPI(
          name: pokemonDB.name, ivs: pokemonDB.ivs, league: pokemonDB.league));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.read<ThemeNotifier>();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<DatabaseBloc, DatabaseState>(
          listener: (context, state) async {
            if (state is PVPRaterPageState) {
              if (state.pageState == PageState.success) {
                pokemon = state.pokemon!;
              }
            }
          },
          builder: (context, state) {
            if (state is PVPRaterPageState) {
              if (state.pageState == PageState.loading) {
                return const Loading();
              }
              // TODO error handling
            }
            if ((state is! PVPRaterPageState || pokemon.name == 'null') &&
                state is! PokemonDBState) {
              return const Loading();
            }
            return Container(
              decoration: BoxDecoration(image: colors.bgImage),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: colors.bg2,
                      height: 300.w,
                    ),
                  ),
                  SingleChildScrollView(
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
                              Row(
                                children: [
                                  const CustomBackButton(),
                                  const Spacer(),
                                  pokemonDB.name != 'null'
                                      ? IconButton(
                                          iconSize: 35.w,
                                          color: colors.accent,
                                          icon: const Icon(Icons.delete_outline),
                                          onPressed: () {
                                            context
                                                .read<DatabaseBloc>()
                                                .add(DeletePokemon(pokemonDB));
                                          },
                                        )
                                      : IconButton(
                                          iconSize: 35.w,
                                          color: colors.accent,
                                          icon: const Icon(Icons.bookmark_border),
                                          onPressed: () {
                                            context
                                                .read<DatabaseBloc>()
                                                .add(AddPokemon(pokemon));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(showCustomSnackBar(
                                                    context, 'Saved to Database!'));
                                          },
                                        ),
                                ],
                              ),
                              SizedBox(height: 25.w),
                              Row(
                                children: [
                                  SizedBox(
                                    height: 35.w,
                                    child: Image.asset(
                                        'assets/${pokemon.league}_league_logo.png'),
                                  ),
                                  SizedBox(width: 15.w),
                                  Text(
                                    pokemon.name,
                                    style: TextStyle(
                                      fontSize: 45,
                                      fontWeight: FontWeight.w500,
                                      color: colors.t1,
                                    ),
                                  ),
                                ],
                              ),
                              PokemonTypeList(types: pokemon.types),
                              SizedBox(height: 5.w),
                              Stack(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 250.w,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      '#${pokemon.metaDetails.rank}',
                                      style: TextStyle(
                                        fontSize: 50,
                                        fontWeight: FontWeight.w500,
                                        color: colors.t1,
                                      ),
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
                          elevation: 0,
                          color: colors.bg2,
                          margin: EdgeInsets.zero,
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
                                _buildHead(colors, 'PvP IV Perfection'),
                                IVSection(
                                    ivStats: pokemon.userIVStats,
                                    label: 'Your Stats'),
                                SizedBox(height: 12.w),
                                IVSection(
                                    ivStats: pokemon.bestIVStats,
                                    label: 'Best Stats'),
                                SizedBox(height: 25.w),
                                _buildHead(colors, 'Type effectiveness'),
                                TypeEffectivenessSection(
                                    label: 'Weakness', list: pokemon.weakness),
                                SizedBox(height: 15.w),
                                TypeEffectivenessSection(
                                    label: 'Resistance', list: pokemon.resistance),
                                SizedBox(height: 30.w),
                                _buildHead(colors, 'Moveset'),
                                MoveSetSection(
                                    label: 'Best Moves', list: pokemon.bestMoveSet),
                                MoveSetSection(
                                    label: 'Fast Moves', list: pokemon.fastMoves),
                                MoveSetSection(
                                    label: 'Charged Moves',
                                    list: pokemon.chargedMoves),
                                SizedBox(height: 15.w),
                                _buildHead(colors, 'Matchup'),
                                MatchUpSection(
                                    list: pokemon.metaDetails.keyWins,
                                    label: 'Key Wins'),
                                SizedBox(height: 5.w),
                                MatchUpSection(
                                    list: pokemon.metaDetails.keyLosses,
                                    label: 'Key Losses'),
                                SizedBox(height: 50.w),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
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

class IVSection extends StatelessWidget {
  final String label;
  final IVStats ivStats;

  const IVSection({Key? key, required this.label, required this.ivStats})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.read<ThemeNotifier>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w500,
            color: colors.t1,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              ivStats.perfectionPercent.toStringAsPrecision(3),
              style: TextStyle(
                fontSize: 58,
                fontWeight: FontWeight.w500,
                color: colors.t1,
                height: 1.1.w,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 3.w, bottom: 5.w),
              child: Text(
                '%',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: colors.accent,
                ),
              ),
            ),
            const Spacer(),
            _buildIV(colors, ivStats.ivs[0], 'Atk'),
            _buildIVDivider(colors),
            _buildIV(colors, ivStats.ivs[1], 'Def'),
            _buildIVDivider(colors),
            _buildIV(colors, ivStats.ivs[2], 'HP'),
          ],
        )
      ],
    );
  }

  Padding _buildIVDivider(ThemeNotifier colors) {
    return Padding(
      padding: EdgeInsets.fromLTRB(5.w, 16.w, 5.w, 32.w),
      child: Text(
        '/',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: colors.accent,
        ),
      ),
    );
  }

  Column _buildIV(ThemeNotifier colors, int iv, String ivLabel) {
    return Column(
      children: [
        Text(
          '$iv',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.w500,
            color: colors.t1,
            height: 0.7.w,
          ),
        ),
        Text(
          ivLabel,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: colors.t1,
          ),
        ),
        SizedBox(height: 8.w),
      ],
    );
  }
}

class TypeEffectivenessSection extends StatelessWidget {
  final String label;
  final List<TypeEffect> list;

  const TypeEffectivenessSection(
      {Key? key, required this.label, required this.list})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.read<ThemeNotifier>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w500,
            color: colors.t1,
          ),
        ),
        SizedBox(height: 7.w),
        Wrap(
          runSpacing: 10.w,
          spacing: 12.w,
          children: [
            for (int i = 0; i < list.length; i++)
              Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(30.w),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: list[i].type.color,
                    borderRadius: BorderRadius.circular(30.w),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.w),
                        ),
                        padding: EdgeInsets.fromLTRB(8.w, 4.w, 8.w, 6.w),
                        child: Text(
                          'x${list[i].multiplier.round()}%',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(12.w, 0.w, 12.w, 2.w),
                        child: Text(
                          list[i].type.name,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class MoveSetSection extends StatelessWidget {
  final List<PVPMove> list;
  final String label;

  const MoveSetSection({Key? key, required this.list, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.read<ThemeNotifier>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w500,
            color: colors.t1,
          ),
        ),
        SizedBox(height: 10.w),
        for (int i = 0; i < list.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: 15.w),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(20.w),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                height: 70.w,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: list[i].type.color,
                  borderRadius: BorderRadius.circular(20.w),
                ),
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  children: [
                    Text(
                      list[i].name,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      list[i].archetype,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class MatchUpSection extends StatelessWidget {
  final List<PVPMatchUp> list;
  final String label;

  const MatchUpSection({Key? key, required this.list, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.read<ThemeNotifier>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w500,
            color: colors.t1,
          ),
        ),
        SizedBox(height: 10.w),
        for (int i = 0; i < list.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: 15.w),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(20.w),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Container(
                height: 110.w,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: colors.card,
                  borderRadius: BorderRadius.circular(20.w),
                ),
                padding: EdgeInsets.only(left: 17.w),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          list[i].name,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: colors.t1,
                          ),
                        ),
                        PokemonTypeList(types: list[i].type),
                        SizedBox(height: 5.w),
                        Text(
                          'Rating: ${list[i].rating}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: colors.t1,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.all(5.w),
                      child: Image.network(list[i].imageUrl),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
