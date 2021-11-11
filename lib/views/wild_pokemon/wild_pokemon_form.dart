import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc_files.dart';
import 'package:pokemate/models/pokemon_common.dart';
import 'package:pokemate/shared/custom_snackbar.dart';
import 'package:pokemate/shared/custom_widgets.dart';
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
  late InputType _inputType;

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
    _inputType = widget.inputType;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.read<ThemeNotifier>();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<DatabaseBloc, DatabaseState>(
          listener: (context, state) async {
            if (state is WildPokemonFormState) {
              if (state.pageState == PageState.success) {
                _name = state.name!;
                _cp = state.cp!;
              }
              if (state.pageState == PageState.error) {
                ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
                    context, 'Error occurred, Please enter manually!'));
                _inputType = InputType.manual;
              }
            }
          },
          builder: (context, state) {
            if (state is WildPokemonFormState) {
              if (state.pageState == PageState.loading) {
                return const Loading();
              }
            }
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(colors.bgImagePath),
                  fit: BoxFit.cover,
                ),
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 25.w),
                    const CustomBackButton(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Wild Pokemon',
                            style: TextStyle(
                              fontSize: 45,
                              color: colors.t1,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 40.h),
                          _buildLabel(colors, 'Name'),
                          TextFormField(
                            initialValue: _name,
                            decoration: customInputDecoration(
                                context: context, labelText: 'Eg. Charizard'),
                            style: formTextStyle(colors),
                            onSaved: (value) {
                              _name = value ?? '';
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter Pokemon's name";
                              }
                            },
                          ),
                          SizedBox(height: 20.h),
                          _buildLabel(colors, 'CP'),
                          TextFormField(
                            initialValue: _inputType == InputType.gallery
                                ? _cp.toString()
                                : '',
                            keyboardType: TextInputType.number,
                            decoration: customInputDecoration(
                                context: context, labelText: '0'),
                            style: formTextStyle(colors),
                            onSaved: (value) {
                              _cp = int.tryParse(value!) ?? 0;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter pokemon's cp";
                              }
                              if (int.tryParse(value) == null) {
                                return "Invalid";
                              }
                              if (int.tryParse(value)! > 10000) {
                                return "Cannot be more than 10,000";
                              }
                              if (int.tryParse(value)! < 0) {
                                return "Cannot be negative";
                              }
                            },
                          ),
                          SizedBox(height: 30.h),
                          CustomElevatedButton(
                            text: 'Next',
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              _formKey.currentState?.save();
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
                          SizedBox(height: 130.h),
                        ],
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

  Padding _buildLabel(ThemeNotifier colors, String label) {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, bottom: 8.w),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 17,
          color: colors.t2,
        ),
      ),
    );
  }
}
