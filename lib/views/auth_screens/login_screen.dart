import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/bloc/app_bloc/app_bloc_files.dart';
import 'package:pokemate/shared/custom_snackbar.dart';
import 'package:pokemate/themes/theme_notifiers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemate/views/auth_screens/get_started_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = 'aadi@gmail.com';
  String password = 'aadi123';
  String stateMessage = '';
  bool showPassword = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final colors = context.read<ThemeNotifier>();
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) async {
        if (state is LoginPageState) {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context)
              .showSnackBar(showCustomSnackBar(context, state.message));
        }
        if (state is Authenticated) {
          stateMessage = 'Success!';
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          print('Navigating..');
          Navigator.popUntil(context, ModalRoute.withName('/'));
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        'assets/${colors.isDarkMode ? 'dark' : 'light'}_bg.png'),
                    fit: BoxFit.cover),
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 30,
                        color: colors.t1,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: colors.accent),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                          color: colors.onAccent,
                        ),
                      ),
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        _formKey.currentState?.save();
                        ScaffoldMessenger.of(context).showSnackBar(
                            showCustomSnackBar(context, stateMessage));
                        BlocProvider.of<AppBloc>(context)
                            .add(LoginUser(email: email, password: password));
                      },
                    ),
                    SizedBox(height: 110.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                              fontSize: 15,
                              color: Theme.of(context).colorScheme.onSurface),
                        ),
                        TextButton(
                          child: Text(
                            "Sign Up!",
                            style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const GetStartedPage()));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
