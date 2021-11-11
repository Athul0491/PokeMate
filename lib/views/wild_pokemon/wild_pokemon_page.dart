import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc_files.dart';
import 'package:pokemate/models/wild_pokemon.dart';
import 'package:pokemate/shared/loading.dart';
import 'package:pokemate/themes/theme_notifiers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WildPokemonPage extends StatefulWidget {
  final String name;
  final int cp;

  const WildPokemonPage({Key? key, required this.name, required this.cp})
      : super(key: key);

  @override
  _WildPokemonPageState createState() => _WildPokemonPageState();
}

class _WildPokemonPageState extends State<WildPokemonPage> {
  late WildPokemon pokemon;

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
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(colors.bgImagePath),
              fit: BoxFit.cover,
            ),
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: BlocConsumer<DatabaseBloc, DatabaseState>(
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
              return Column(
                children: [
                  Text(
                    'Wild Pokemon Rater',
                    style: TextStyle(
                      fontSize: 30,
                      color: colors.t1,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: colors.accent),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 20,
                        color: colors.onAccent,
                      ),
                    ),
                    onPressed: () async {},
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
