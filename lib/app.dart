import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemate/shared/error_screen.dart';
import 'package:pokemate/themes/theme.dart';
import 'package:pokemate/views/home_screen.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      builder: () {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.from(
            textTheme: Theme.of(context).textTheme.apply(fontFamily: 'Poppins'),
            colorScheme: colorScheme,
          ),
          home: const SafeArea(
            child: HomeScreen(),
          ),
          builder: (context, child) {
            int width = MediaQuery.of(context).size.width.toInt();
            return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(textScaleFactor: width / 414),
              child: child ?? const SomethingWentWrong(),
            );
          },
        );
      },
    );
  }
}
