import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pokemate/bloc/app_bloc/app_bloc.dart';
import 'package:pokemate/bloc/app_bloc/app_bloc_files.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc_files.dart';
import 'package:pokemate/models/pokemon_common.dart';
import 'package:pokemate/models/raid_boss.dart';
import 'package:pokemate/models/user.dart';
import 'package:pokemate/shared/custom_snackbar.dart';
import 'package:pokemate/shared/loading.dart';
import 'package:pokemate/themes/theme_notifiers.dart';
import 'package:pokemate/views/pvp_iv/pvp_rater_form.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemate/views/settings_screen.dart';
import 'package:pokemate/views/wild_pokemon/wild_pokemon_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<RaidBoss> raidBossList = [];

  @override
  void initState() {
    super.initState();
    context
        .read<DatabaseBloc>()
        .add(GetRaidBossInfo(context));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.read<ThemeNotifier>();
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<DatabaseBloc, DatabaseState>(
          listener: (context, state) {
            if (state is HomePageState) {
              if (state.pageState == PageState.success) {
                raidBossList = state.raidBossList!;
              }
              if (state.pageState == PageState.error) {
                ScaffoldMessenger.of(context).showSnackBar(showCustomSnackBar(
                    context, 'Error occurred, Please enter manually!'));
              }
            }
          },
          builder: (context, state) {
            final UserData userData = context.read<AppBloc>().userData;
            if (state is HomePageState) {
              if (state.pageState == PageState.loading) {
                return const Loading();
              }
            }
            if (state is Init){
              return const Loading();
            }
            return Container(
              decoration: BoxDecoration(
                image: colors.bgImage,
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 25.w),
                  Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      iconSize: 35.w,
                      color: colors.accent,
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingPage()));
                      },
                    ),
                  ),
                  SizedBox(height: 20.w),
                  Text(
                    'Welcome back,',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                      color: colors.t2,
                      height: 0.9,
                    ),
                  ),
                  Text(
                    userData.name!.split(' ').first,
                    style: TextStyle(
                      height: 1.25,
                      fontSize: 45,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  SizedBox(height: 25.w),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.w)),
                      padding: EdgeInsets.zero,
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      height: 105.w,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/pvp_button_bg.png'),
                        fit: BoxFit.fitWidth,
                      )),
                      child: _buildButtonLabel('PVP Rater'),
                    ),
                    onPressed: () async {
                      await showModalBottomSheet(
                        context: context,
                        barrierColor: Colors.black.withOpacity(0.25),
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return _buildBottomCard(colors, 'PVPRater');
                        },
                      );
                    },
                  ),
                  SizedBox(height: 15.w),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.w)),
                      padding: EdgeInsets.zero,
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      height: 105.w,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/wild_pokemon_button_bg.jpg'),
                        fit: BoxFit.fitWidth,
                      )),
                      child: _buildButtonLabel('Wild Pokemon'),
                    ),
                    onPressed: () async {
                      await showModalBottomSheet(
                        context: context,
                        barrierColor: Colors.black.withOpacity(0.25),
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return _buildBottomCard(colors, 'WildPokemon');
                        },
                      );
                    },
                  ),
                  SizedBox(height: 15.w),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.w)),
                      padding: EdgeInsets.zero,
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      height: 105.w,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/my_pokemon_button_bg.jpg'),
                        fit: BoxFit.fitWidth,
                      )),
                      child: _buildButtonLabel('My Pokemons'),
                    ),
                    onPressed: () async {},
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Container _buildButtonLabel(String label) {
    return Container(
      height: 42.w,
      padding: EdgeInsets.symmetric(vertical: 6.w, horizontal: 25.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(15.w),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.black,
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

  Widget _buildBottomCard(ThemeNotifier colors, String targetPage) {
    return Card(
      margin: EdgeInsets.all(20.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.w),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.add_photo_alternate_outlined),
              title: Text(
                'Gallery',
                style: TextStyle(fontSize: 18, color: colors.t1),
              ),
              onTap: () async {
                File? image = await _imageFromGallery();
                if (image != null) {
                  await Navigator.push(
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
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
              },
            ),
            Divider(
              indent: 10.w,
              endIndent: 10.w,
              height: 8.w,
              thickness: 1.5.w,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.edit),
              title: Text(
                'Manual',
                style: TextStyle(fontSize: 18, color: colors.t1),
              ),
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => targetPage == 'PVPRater'
                          ? const PVPRaterForm(
                        inputType: InputType.manual,
                        image: null,
                      )
                          : const WildPokemonForm(
                        inputType: InputType.manual,
                        image: null,
                      ),
                    ));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
