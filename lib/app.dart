import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemate/bloc/app_bloc/app_bloc.dart';
import 'package:pokemate/bloc/app_bloc/app_bloc_files.dart';
import 'package:pokemate/repositories/auth_repository.dart';
import 'package:pokemate/shared/error_screen.dart';
import 'package:pokemate/themes/theme.dart';
import 'package:pokemate/views/home_screen.dart';
import 'package:pokemate/wrapper.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<AuthRepository>(
      create: (context) => AuthRepository(),
      child: BlocProvider<AppBloc>(
        create: (context) {
          AppBloc appBloc =
              AppBloc(authRepository: context.read<AuthRepository>());
          appBloc.add(AppStarted());
          return appBloc;
        },
        child: Builder(builder: (context) {
          return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
            // BlocProvider for DatabaseBloc
            return ScreenUtilInit(
              designSize: const Size(414, 896),
              builder: () {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  theme: ThemeData.from(
                    textTheme: Theme.of(context).textTheme.apply(
                          fontFamily: 'Poppins',
                          displayColor: Colors.white,
                          bodyColor: Colors.white,
                        ),
                    colorScheme: const ColorScheme.dark().copyWith(
                      primary: const Color(0xFFE50914),
                      onPrimary: Colors.white,
                      background: const Color(0xFF0F0F0F),
                      surface: const Color(0xFF363636),
                    ),
                  ),
                  home: SafeArea(
                    child: Wrapper(state: state),
                  ),
                  builder: (context, child) {
                    int width = MediaQuery.of(context).size.width.toInt();
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(textScaleFactor: width / 414),
                      child: child ?? const SomethingWentWrong(),
                    );
                  },
                );
              },
            );
          });
        }),
      ),
    );
  }
}
