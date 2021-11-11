import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  bool isDarkMode;

  Color get bg =>
      isDarkMode ? const Color(0xFF0F0F0F) : const Color(0xFFFBFBFB);

  Color get onBg =>
      isDarkMode ? const Color(0xFF171717) : const Color(0xFFF6F6F6);

  Color get bg2 =>
      isDarkMode ? const Color(0xFF1D1D1D) : const Color(0xFFF3F3F3);

  Color get card =>
      isDarkMode ? const Color(0xFF363636) : const Color(0xFFFFFFFF);

  Color get t1 =>
      isDarkMode ? const Color(0xFFFFFFFF) : const Color(0xFF000000);

  Color get t2 =>
      isDarkMode ? const Color(0xFF9E9E9E) : const Color(0xFF818181);

  Color get t3 =>
      isDarkMode ? const Color(0xFF000000) : const Color(0xFFFFFFFF);

  Color get accent =>
      isDarkMode ? const Color(0xFFE50914) : const Color(0xFFE50914);

  Color get onAccent =>
      isDarkMode ? const Color(0xFFFFFFFF) : const Color(0xFFFFFFFF);

  String get bgImagePath =>
      isDarkMode ? 'assets/dark_bg.png' : 'assets/light_bg.png';

  DecorationImage get bgImage => isDarkMode
      ? const DecorationImage(
      image: AssetImage('assets/dark_bg.png'), fit: BoxFit.cover)
      :  const DecorationImage(
      image: AssetImage('assets/light_bg.png'), fit: BoxFit.cover);

  ThemeNotifier(this.isDarkMode);

  bool get isDark => isDarkMode;

  ThemeData getTheme(BuildContext context) {
    return ThemeData.from(
      textTheme: Theme.of(context).textTheme.apply(
            fontFamily: 'Poppins',
            displayColor: t1,
            bodyColor: t1,
          ),
      colorScheme: isDarkMode
          ? const ColorScheme.dark().copyWith(
              primary: accent,
              onPrimary: onAccent,
              background: bg,
              surface: card,
            )
          : const ColorScheme.light().copyWith(
              primary: accent,
              onPrimary: t1,
              background: bg,
              surface: card,
            ),
    );
  }

  setTheme(bool newValue) async {
    isDarkMode = newValue;
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', newValue);
    notifyListeners();
  }
}
