import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/bloc/app_bloc/app_bloc_files.dart';
import 'package:pokemate/shared/custom_snackbar.dart';
import 'package:pokemate/shared/custom_widgets.dart';
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
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(colors.bgImagePath),
                    fit: BoxFit.cover),
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 25.w),
                      const CustomBackButton(),
                      SizedBox(height: 90.h),
                      Text(
                        'Welcome to,',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w300,
                          color: colors.t2,
                          height: 0.9,
                        ),
                      ),
                      Text(
                        'PokeMate',
                        style: TextStyle(
                          height: 1.25,
                          fontSize: 45,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      SizedBox(height: 75.h),
                      Text(
                        'Login to continue',
                        style: TextStyle(
                          height: 1.25.w,
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                      SizedBox(height: 25.h),
                      Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(15.w),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: TextFormField(
                          decoration:
                          customInputDecoration(context: context, labelText: 'Email'),
                          style: formTextStyle(colors),
                          onSaved: (value) {
                            email = value ?? '';
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!validateEmail(email)) {
                              return 'Invalid email format';
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 20.w),
                      Stack(
                        children: [
                          Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(15.w),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: TextFormField(
                              decoration: customInputDecoration(
                                  context: context, labelText: 'Password'),
                              style: formTextStyle(colors),
                              obscureText: !showPassword,
                              onSaved: (value) {
                                password = value ?? '';
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                              },
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 10.w),
                            height: 56.w,
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: Icon(
                                  showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  size: 28.w),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.w),
                      CustomElevatedButton(
                        text: 'Login',
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
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).colorScheme.onSurface),
                            ),
                            TextButton(
                              child: Text(
                                "Sign Up!",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: colors.accent),
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool validateEmail(String email) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }
}
