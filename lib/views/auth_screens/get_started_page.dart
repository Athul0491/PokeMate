import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/themes/theme_notifiers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemate/views/auth_screens/signup_screen.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  String name = 'Aaditya';
  int age = 20;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final colors = context.read<ThemeNotifier>();
    return SafeArea(
      child: Scaffold(
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
                  'Get Started',
                  style: TextStyle(
                    fontSize: 30,
                    color: colors.t1,
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: colors.accent),
                  child: Text(
                    'Next',
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignupPage(
                                name: name, age: age)));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}