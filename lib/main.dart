import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pokemate/shared/error_screen.dart';
import 'package:pokemate/shared/loading.dart';
import 'package:pokemate/views/home_screen.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlutterFireInit());
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
          return const SomethingWentWrong();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return const App();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Loading();
      },
    );
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SafeArea(
        child: HomeScreen()
      ),
    );
  }
}

