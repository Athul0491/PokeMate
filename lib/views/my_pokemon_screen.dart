import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc_files.dart';
import 'package:pokemate/models/pokemon_common.dart';
import 'package:pokemate/models/pokemon_db.dart';
import 'package:pokemate/shared/custom_widgets.dart';
import 'package:pokemate/shared/loading.dart';
import 'package:pokemate/themes/theme_notifiers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemate/views/pvp_iv/pvp_rater_page.dart';

class MyPokemonsPage extends StatefulWidget {
  const MyPokemonsPage({Key? key}) : super(key: key);

  @override
  _MyPokemonsPageState createState() => _MyPokemonsPageState();
}

class _MyPokemonsPageState extends State<MyPokemonsPage> {
  List<PokemonDB> pokemonList = [];

  @override
  void initState() {
    super.initState();
    context.read<DatabaseBloc>().add(GetMyPokemons());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.read<ThemeNotifier>();
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<DatabaseBloc, DatabaseState>(
          listener: (context, state) {
            if (state is MyPokemonsPageState) {
              if (state.pageState == PageState.success) {
                pokemonList = state.pokemonList!;
                print(pokemonList);
              }
            }
          },
          builder: (context, state) {
            if (state is MyPokemonsPageState) {
              if (state.pageState == PageState.loading) {
                return const Loading();
              }
            }
            return Container(
              decoration: BoxDecoration(
                image: colors.bgImage,
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 25.w),
                    const CustomBackButton(),
                    SizedBox(height: 25.w),
                    Text(
                      'My Pokemons',
                      style: TextStyle(
                        fontSize: 45,
                        color: colors.t1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 30.w),
                    pokemonList.isEmpty
                        ? Padding(
                          padding: EdgeInsets.only(top: 250.h),
                          child: Center(
                            child: Text(
                              'You have not added any Pokemons yet,\nPlease add from the PVPRater Section!',
                              style: TextStyle(
                                fontSize: 17,
                                color: colors.t2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                        : Flexible(
                            child: ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: pokemonList.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                PokemonDB pokemon = pokemonList[index];
                                return _buildPokemonCard(colors, pokemon);
                              },
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

  Widget _buildPokemonCard(ThemeNotifier colors, PokemonDB pokemon) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PVPRaterPage(pokemonDB: pokemon)));
      },
      child: Card(
        elevation: 5,
        color: colors.card,
        margin: EdgeInsets.only(bottom: 20.w),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
        child: Container(
          padding: EdgeInsets.only(left: 20.w),
          height: 130.w,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 28.w,
                          child: Image.asset(
                              'assets/${pokemon.league}_league_logo.png'),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          pokemon.name,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: colors.t1,
                          ),
                        ),
                      ],
                    ),
                    PokemonTypeList(types: pokemon.types),
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildIV(pokemon, colors, pokemon.ivs[0]),
                        _buildIVDivider(colors),
                        _buildIV(pokemon, colors, pokemon.ivs[1]),
                        _buildIVDivider(colors),
                        _buildIV(pokemon, colors, pokemon.ivs[2]),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 5.w, right: 10.w, top: 5.w),
                child: Image.network(pokemon.imageUrl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildIVDivider(ThemeNotifier colors) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.w),
      child: Text(
        '  /  ',
        style: TextStyle(
          fontSize: 10,
          color: colors.t1,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Text _buildIV(PokemonDB pokemon, ThemeNotifier colors, int iv) {
    return Text(
      '$iv',
      style: TextStyle(
        fontSize: 27,
        color: colors.t1,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
