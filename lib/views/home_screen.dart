import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/bloc/app_bloc/app_bloc.dart';
import 'package:pokemate/bloc/app_bloc/app_bloc_files.dart';
import 'package:pokemate/themes/theme_notifiers.dart';

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
      body: Column(
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
    );
  }
}
