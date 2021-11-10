import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc_files.dart';
import 'package:pokemate/models/pokemon_common.dart';
import 'package:pokemate/shared/loading.dart';
import 'package:pokemate/themes/theme_notifiers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemate/views/wild_pokemon/wild_pokemon_page.dart';

class WildPokemonForm extends StatefulWidget {
  final InputType inputType;
  final File? image;

  const WildPokemonForm({Key? key, required this.inputType, this.image})
      : super(key: key);

  @override
  _WildPokemonFormState createState() => _WildPokemonFormState();
}

class _WildPokemonFormState extends State<WildPokemonForm> {
  File? _image;
  String tempMessage = '';
  String _name = '';
  int _cp = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _image = widget.image;
    if (_image != null) {
      context
          .read<DatabaseBloc>()
          .add(GetWildPokemonInfoFromImage(image: _image!));
    }
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
              if (state is WildPokemonFormState) {
                _name = state.name;
                _cp = state.cp;
                // _id = (await PokemonJSON.getID(context, _name)) as String;
              }
            },
            builder: (context, state) {
              if (state is Fetching) {
                return const Center(child: LoadingSmall(size: 100));
              }
              return Form(
                key: _formKey,
                child: Column(
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
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WildPokemonPage(
                                name: _name,
                                cp: _cp,
                              ),
                            ));
                      },
                    ),
                    Text(
                      _cp.toString(),
                      style: TextStyle(
                        fontSize: 30,
                        color: colors.t1,
                      ),
                    ),
                    Text(
                      _name,
                      style: TextStyle(
                        fontSize: 30,
                        color: colors.t1,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
