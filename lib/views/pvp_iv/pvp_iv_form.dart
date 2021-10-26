import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc_files.dart';
import 'package:pokemate/models/pokemon_common.dart';
import 'package:pokemate/shared/loading.dart';
import 'package:pokemate/themes/theme_notifiers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PVPRaterForm extends StatefulWidget {
  final InputType inputType;
  final File? image;

  const PVPRaterForm({Key? key, required this.inputType, this.image})
      : super(key: key);

  @override
  _PVPRaterFormState createState() => _PVPRaterFormState();
}

class _PVPRaterFormState extends State<PVPRaterForm> {
  File? _image;
  String tempMessage = '';
  String _name = '';
  List<int> _ivs = [0,0,0];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _image = widget.image;
    if(_image != null){
      context.read<DatabaseBloc>().add(GetPVPIVs(image: _image!));
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
                image: AssetImage(
                    'assets/${colors.isDarkMode ? 'dark' : 'light'}_bg.png'),
                fit: BoxFit.cover),
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: BlocConsumer<DatabaseBloc, DatabaseState>(
            listener: (context, state){
              if(state is Fetching){
                tempMessage = 'Loading';
              }
              if(state is PVPRaterFormState){
                tempMessage = '${state.ivs[0]}/${state.ivs[1]}/${state.ivs[2]}';
                _ivs = state.ivs;
                _name = state.name;
              }
            },
            builder: (context, state) {
              if (state is Fetching){
                return const Loading();
              }
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'PVP IV Rater',
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
                      onPressed: () {},
                    ),
                    Text(
                      tempMessage,
                      style: TextStyle(
                        fontSize: 30,
                        color: colors.t1,
                      ),
                    ),
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
