import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemate/bloc/app_bloc/app_bloc.dart';
import 'package:pokemate/bloc/app_bloc/app_bloc_files.dart';
import 'package:pokemate/bloc/database_bloc/database_bloc.dart';
import 'package:pokemate/models/pokemon_common.dart';
import 'package:pokemate/models/user.dart';
import 'package:pokemate/repositories/auth_repository.dart';
import 'package:pokemate/repositories/database_repository.dart';
import 'package:pokemate/shared/error_screen.dart';
import 'package:pokemate/shared/loading.dart';
import 'package:pokemate/themes/theme_notifiers.dart';
import 'package:pokemate/wrapper.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late String pokemonJsonStr;
  late String pvpMoveJsonStr;

  Future loadAssets() async {
    pokemonJsonStr =
        await DefaultAssetBundle.of(context).loadString("assets/pokemon.json");
    pvpMoveJsonStr =
        await DefaultAssetBundle.of(context).loadString("assets/moves.json");
  }

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
        child: FutureBuilder(
          // To load the pokemon.json file and passing it to bloc
          future: loadAssets(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const MaterialApp(home: Loading());
            }
            print('fuck you');
            return BlocBuilder<AppBloc, AppState>(
              builder: (context, state) {
                return BlocProvider<DatabaseBloc>(
                  create: (context) {
                    UserData userData = context.read<AppBloc>().userData;
                    return DatabaseBloc(
                      userData: userData,
                      databaseRepository: DatabaseRepository(uid: userData.uid),
                      pokemonJSON: PokemonJSON(pokemonJsonStr),
                      pvpMovesJSON: PVPMovesJSON(pvpMoveJsonStr),
                    );
                  },
                  child: ScreenUtilInit(
                    designSize: const Size(414, 896),
                    builder: () {
                      return Consumer<ThemeNotifier>(
                        builder: (context, colors, child) {
                          return MaterialApp(
                            debugShowCheckedModeBanner: false,
                            theme: colors.getTheme(context),
                            home: SafeArea(
                              child: Wrapper(state: state),
                            ),
                            builder: (context, child) {
                              int width =
                                  MediaQuery.of(context).size.width.toInt();
                              return MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(textScaleFactor: width / 414),
                                child: child ?? const SomethingWentWrong(),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
