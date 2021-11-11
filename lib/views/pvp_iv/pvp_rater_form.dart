import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc_files.dart';
import 'package:pokemate/models/pokemon_common.dart';
import 'package:pokemate/shared/custom_snackbar.dart';
import 'package:pokemate/shared/custom_widgets.dart';
import 'package:pokemate/shared/loading.dart';
import 'package:pokemate/shared/shared_methods.dart';
import 'package:pokemate/themes/theme_notifiers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemate/views/pvp_iv/pvp_rater_page.dart';

class PVPRaterForm extends StatefulWidget {
  final InputType inputType;
  final File? image;

  const PVPRaterForm({Key? key, required this.inputType, this.image})
      : super(key: key);

  @override
  _PVPRaterFormState createState() => _PVPRaterFormState();
}

class _PVPRaterFormState extends State<PVPRaterForm> {
  String _name = '';
  List<int> _ivs = [0, 0, 0];
  String _league = 'great';
  late InputType _inputType;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.image != null) {
      context
          .read<DatabaseBloc>()
          .add(GetPVPInfoFromImage(image: widget.image!));
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
            if (state is PVPRaterFormState) {
              if (state.pageState == PageState.success) {
                _ivs = state.ivs!;
                _name = state.name!;
              }
              if (state.pageState == PageState.error) {
                ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
                    context, 'Error occurred, Please enter manually!'));
                if (state.ivs!.isNotEmpty) {
                  _ivs = state.ivs!;
                } else {
                  _inputType = InputType.manual;
                }
                if (state.name != '') {
                  _name = state.name!;
                }
              }
            }
          },
          builder: (context, state) {
            if (state is PVPRaterFormState) {
              if (state.pageState == PageState.loading) {
                return const Loading();
              }
            }
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(colors.bgImagePath), fit: BoxFit.cover),
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
                    SizedBox(height: 40.h),
                    Text(
                      'PVP Rater',
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(colors, 'Atk'),
                              TextFormField(
                                initialValue: _inputType == InputType.gallery
                                    ? _ivs[0].toString()
                                    : '',
                                keyboardType: TextInputType.number,
                                decoration: customInputDecoration(
                                    context: context, labelText: '0'),
                                style: formTextStyle(colors),
                                onSaved: (value) {
                                  _ivs[0] = int.tryParse(value!) ?? 0;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Cannot\nbe empty";
                                  }
                                  if (int.tryParse(value) == null) {
                                    return "Invalid";
                                  }
                                  if (int.tryParse(value)! > 15 ||
                                      int.tryParse(value)! < 0) {
                                    return "Between\n0 - 15";
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 25.w),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(colors, 'Def'),
                              TextFormField(
                                initialValue: _inputType == InputType.gallery
                                    ? _ivs[1].toString()
                                    : '',
                                keyboardType: TextInputType.number,
                                decoration: customInputDecoration(
                                    context: context, labelText: '0'),
                                style: formTextStyle(colors),
                                onSaved: (value) {
                                  _ivs[1] = int.tryParse(value!) ?? 0;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Cannot\nbe empty";
                                  }
                                  if (int.tryParse(value) == null) {
                                    return "Invalid";
                                  }
                                  if (int.tryParse(value)! > 15 ||
                                      int.tryParse(value)! < 0) {
                                    return "Between\n0 - 15";
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 25.w),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel(colors, 'HP'),
                              TextFormField(
                                initialValue: _inputType == InputType.gallery
                                    ? _ivs[2].toString()
                                    : '',
                                keyboardType: TextInputType.number,
                                decoration: customInputDecoration(
                                    context: context, labelText: '0'),
                                style: formTextStyle(colors),
                                onSaved: (value) {
                                  _ivs[2] = int.tryParse(value!) ?? 0;
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Cannot\nbe empty";
                                  }
                                  if (int.tryParse(value) == null) {
                                    return "Invalid";
                                  }
                                  if (int.tryParse(value)! > 15 ||
                                      int.tryParse(value)! < 0) {
                                    return "Between\n0 - 15";
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    _buildLabel(colors, 'League'),
                    Row(
                      children: [
                        _buildLeagueCard(colors, 'great', '1500'),
                        SizedBox(width: 20.w),
                        _buildLeagueCard(colors, 'ultra', '2500'),
                        SizedBox(width: 20.w),
                        _buildLeagueCard(colors, 'master', 'None'),
                      ],
                    ),
                    SizedBox(height: 20.h),
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
                              builder: (context) => PVPRaterPage(
                                name: _name,
                                ivs: _ivs,
                                league: _league,
                              ),
                            ));
                      },
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

  Widget _buildLeagueCard(ThemeNotifier colors, String league, String maxCP) {
    return Flexible(
      child: InkWell(
        onTap: () {
          setState(() {
            _league = league;
          });
        },
        child: Card(
          color: colors.card,
          margin: EdgeInsets.only(bottom: 15.w),
          shape: RoundedRectangleBorder(
              side: league == _league
                  ? BorderSide(width: 3.w, color: colors.accent)
                  : const BorderSide(width: 0),
              borderRadius: BorderRadius.circular(20.w)),
          child: Container(
            // height: 80.w,
            padding: EdgeInsets.all(10.w),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(9.w),
                  child: Image.asset('assets/${league}_league_logo.png'),
                ),
                Text(
                  '${league.capitalize()} League',
                  style: TextStyle(
                    fontSize: 19,
                    height: 1.3.w,
                    color: colors.t1,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.w),
              ],
            ),
          ),
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
