import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc.dart';
import 'package:pokemate/models/pokemon_common.dart';
import 'package:pokemate/models/pokemon_pvp.dart';
import 'package:pokemate/repositories/api_repository.dart';
import 'package:pokemate/themes/theme_notifiers.dart';
import 'package:pokemate/views/pvp_iv/pvp_rater_form.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemate/views/wild_pokemon/wild_pokemon_form.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Map<String, dynamic>? ivData = {};
  Map<String, dynamic>? pvpData = {};
  Map<String, dynamic>? pokemonData = {};
  String name = 'Charizard';
  List<int> ivs = [0, 14, 15];
  String league = 'ultra';

  @override
  Widget build(BuildContext context) {
    final colors = context.read<ThemeNotifier>();
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 25.w),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(colors.bgImage), fit: BoxFit.cover),
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Text(
              'TestScreen',
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
                PokemonJSON pokemonJSON = context.read<DatabaseBloc>().pokemonJSON;
                APIRepository apiRepository = APIRepository();
                int pokemonId = pokemonJSON.getID(name);
                ivData = await apiRepository.getPVPIVInfo(name, ivs, league);
                pvpData = await apiRepository.getLeaguePVPInfo(name, league);
                pokemonData = await apiRepository.getPVPDetails(pokemonId);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: colors.accent),
              child: Text(
                'model',
                style: TextStyle(
                  fontSize: 20,
                  color: colors.onAccent,
                ),
              ),
              onPressed: () async {
                PokemonJSON pokemonJSON = context.read<DatabaseBloc>().pokemonJSON;
                PVPMovesJSON pvpMovesJSON = context.read<DatabaseBloc>().pvpMovesJSON;
                if (pokemonData != null && pvpData!=null && ivData!=null) {
                  PokemonPVP pokemon = PokemonPVP.fromAPI(
                    name: name,
                    ivs: ivs,
                    league: league,
                    pokemonData: pokemonData!,
                    pvpData: pvpData!,
                    ivData: ivData!,
                    pokemonJSON: pokemonJSON,
                    pvpMovesJSON: pvpMovesJSON,
                  );
                  print(pokemon);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // chose image gallery
  Future<File?> _imageFromGallery() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile =
    await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File? image = File(pickedFile.path);
      return image;
    }
  }

  Widget _buildBottomCard(String targetPage) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.add_photo_alternate_outlined),
            title: const Text('Gallery'),
            onTap: () async {
              File? image = await _imageFromGallery();
              if (image != null) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => targetPage == 'PVPRater'
                          ? PVPRaterForm(
                        inputType: InputType.gallery,
                        image: image,
                      )
                          : WildPokemonForm(
                        inputType: InputType.gallery,
                        image: image,
                      ),
                    ));
              } else {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manual'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PVPRaterForm(
                        inputType: InputType.manual,
                      )));
            },
          ),
        ],
      ),
    );
  }
}