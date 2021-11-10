import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pokemate/bloc/app_bloc/app_bloc.dart';
import 'package:pokemate/bloc/app_bloc/app_bloc_files.dart';
import 'package:pokemate/models/pokemon_common.dart';
import 'package:pokemate/themes/theme_notifiers.dart';
import 'package:pokemate/views/pvp_iv/pvp_iv_form.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemate/views/wild_pokemon/wild_pokemon_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              'HomeScreen',
              style: TextStyle(
                fontSize: 30,
                color: colors.t1,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: colors.accent),
              child: Text(
                'PVP Rater',
                style: TextStyle(
                  fontSize: 20,
                  color: colors.onAccent,
                ),
              ),
              onPressed: () async {
                await showModalBottomSheet(
                  context: context,
                  barrierColor: Colors.black.withOpacity(0.25),
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return _buildBottomCard('PVPRater');
                  },
                );
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: colors.accent),
              child: Text(
                'Wild Pokemon',
                style: TextStyle(
                  fontSize: 20,
                  color: colors.onAccent,
                ),
              ),
              onPressed: () async {
                await showModalBottomSheet(
                  context: context,
                  barrierColor: Colors.black.withOpacity(0.25),
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return _buildBottomCard('WildPokemon');
                  },
                );
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: colors.accent),
              child: Text(
                'My Pokemons',
                style: TextStyle(
                  fontSize: 20,
                  color: colors.onAccent,
                ),
              ),
              onPressed: () async {
                Client _client = Client();
                Response response = await _client.get(Uri.https(
                  'pokemate01.herokuapp.com',
                  '/api/pvp',
                  {'id': '6'},
                ));
                print(response.body);
                // Response response = await _client.get(Uri.https(
                //   'pokemate01.herokuapp.com',
                //   '/api/raid',
                // ));
                if(response.statusCode==200){
                  var data = jsonDecode(response.body);
                  print(data);
                }

              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: colors.accent),
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20,
                  color: colors.onAccent,
                ),
              ),
              onPressed: () {
                context.read<AppBloc>().add(LoggedOut());
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
