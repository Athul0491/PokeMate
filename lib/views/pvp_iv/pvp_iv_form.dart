import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc_files.dart';
import 'package:pokemate/models/pokemon_common.dart';
import 'package:pokemate/shared/loading.dart';
import 'package:pokemate/shared/shared_methods.dart';
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
  List<int> _ivs = [0, 0, 0];
  String _id = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _image = widget.image;
    if (_image != null) {
      context.read<DatabaseBloc>().add(GetPVPInfoFromImage(image: _image!));
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
                image: AssetImage(colors.bgImage), fit: BoxFit.cover),
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: BlocConsumer<DatabaseBloc, DatabaseState>(
            listener: (context, state) async {
              if (state is PVPRaterFormState) {
                _ivs = state.ivs;
                _name = state.name;
                int startTime = DateTime.now().millisecondsSinceEpoch;
                String data = await DefaultAssetBundle.of(context)
                    .loadString("assets/pokemon.json");
                final jsonResult = jsonDecode(data);
                print('_' + _name + '_');
                _id = jsonResult[_name.toLowerCase()]['name'].toString();
                int endTime = DateTime.now().millisecondsSinceEpoch;
                print("Loading took ${endTime - startTime}ms");
                print(_id);
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
                      onPressed: () async {
                        Client _client = Client();
                        // Response response = await _client.get(
                        //     Uri.https("pokemate01.herokuapp.com","/api/ultra-league", {
                        //       'Pokemon': 'stunfisk'
                        //     })
                        // );
                        Response response = await _client.get(Uri.https(
                          "pokemate01.herokuapp.com",
                          "/api/pvp",
                          {
                            'name': 'Sylveon'.capitalize(),
                            'attack': '0',
                            'defence': '14',
                            'hp': '14',
                            'league': '0',
                          },
                        ));
                        Map data = jsonDecode(response.body);
                        print(data);
                      },
                    ),
                    Text(
                      _ivs.toString(),
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
