import 'package:flutter/material.dart';
import 'package:pokemate/bloc/app_bloc/app_bloc_files.dart';
import 'package:pokemate/shared/loading.dart';
import 'package:pokemate/views/auth_screens/welcome_screen.dart';
import 'package:pokemate/views/home_screen.dart';

class Wrapper extends StatelessWidget {
  final AppState state;

  const Wrapper({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state is Uninitialized) {
      return const Loading();
    } else if (state is Unauthenticated ||
        state is LoginPageState ||
        state is SignupPageState ||
        state is EmailInputState) {
      return const WelcomeScreen();
    } else if (state is Authenticated) {
      return const HomeScreen();
    } else {
      return const Loading();
    }
  }
}
