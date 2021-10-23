import 'package:flutter/material.dart';
import 'package:pokemate/themes/theme_notifiers.dart';
import 'package:pokemate/views/auth_screens/get_started_page.dart';
import 'package:pokemate/views/auth_screens/login_screen.dart';
import 'package:pokemate/views/auth_screens/signup_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
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
              'Welcome Screen',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            _buildTheme(colors),
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: colors.accent),
              child: Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 20,
                  color: colors.onAccent,
                ),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const GetStartedPage()));
              },
            ),
          ],
        ),
      ),
    );
  }

  SwitchListTile _buildTheme(ThemeNotifier themeNotifier) {
    return SwitchListTile(
      title: const Text(
        'Dark Theme',
        style: TextStyle(fontSize: 21, fontWeight: FontWeight.w400),
      ),
      value: themeNotifier.isDarkMode,
      onChanged: (bool newValue) async {
        setState(() {
          themeNotifier.setTheme(newValue);
        });
      },
    );
  }
}
