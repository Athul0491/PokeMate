import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc_files.dart';
import 'package:pokemate/models/pokemon_pvp.dart';
import 'package:pokemate/shared/loading.dart';
import 'package:pokemate/themes/theme_notifiers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PVPRaterPage extends StatefulWidget {
  final String name;
  final List<int> ivs;
  final String league;

  const PVPRaterPage({
    Key? key,
    required this.name,
    required this.ivs,
    required this.league,
  }) : super(key: key);

  @override
  _PVPRaterPageState createState() => _PVPRaterPageState();
}

class _PVPRaterPageState extends State<PVPRaterPage> {
  late PokemonPVP pokemon;

  @override
  void initState() {
    super.initState();
    context
        .read<DatabaseBloc>()
        .add(GetPVPInfoFromAPI(name: widget.name, ivs: widget.ivs, league: widget.league));
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
              image: AssetImage(colors.bgImage),
              fit: BoxFit.cover,
            ),
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: BlocConsumer<DatabaseBloc, DatabaseState>(
            listener: (context, state) async {
              if (state is PVPRaterPageState) {
                pokemon = state.pokemon;
              }
            },
            builder: (context, state) {
              if (state is Fetching) {
                return const Center(child: LoadingSmall(size: 100));
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
                      'Save',
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
