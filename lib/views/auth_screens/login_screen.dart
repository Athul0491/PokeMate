import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/themes/theme_notifiers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final colors = context.read<ThemeNotifier>();
    return Scaffold(
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
        child: Column(
          children: [
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 30,
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
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
