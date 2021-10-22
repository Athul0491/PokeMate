import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/app.dart';
import 'package:pokemate/shared/error_screen.dart';
import 'package:pokemate/shared/loading.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:pokemate/themes/theme_notifiers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.transformer = sequential<dynamic>();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]).then((_) {
    SharedPreferences.getInstance().then((prefs) {
      var darkModeOn = prefs.getBool('darkMode') ?? true;
      runApp(ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => ThemeNotifier(darkModeOn),
        child: const FlutterFireInit(),
        builder: (context, widget){
          return widget ?? Container();
        },
      ));
    });
  });
}

class FlutterFireInit extends StatefulWidget {
  const FlutterFireInit({Key? key}) : super(key: key);

  @override
  _FlutterFireInitState createState() => _FlutterFireInitState();
}

class _FlutterFireInitState extends State<FlutterFireInit> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const MaterialApp(home: SomethingWentWrong());
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return const App();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const MaterialApp(home: Loading());
      },
    );
  }
}
