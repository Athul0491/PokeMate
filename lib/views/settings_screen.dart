import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/bloc/app_bloc/app_bloc_files.dart';
import 'package:pokemate/shared/custom_widgets.dart';
import 'package:pokemate/themes/theme_notifiers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final colors = context.read<ThemeNotifier>();
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(image: colors.bgImage),
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 25.w),
              const CustomBackButton(),
              SizedBox(height: 40.w),
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 45,
                  color: colors.t1,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 35.w),
              _buildCategoryHead(colors, 'Theme', Icons.light_mode),
              _buildTheme(colors),
              SizedBox(height: 20.w),
              _buildCategoryHead(
                  colors, 'Account', Icons.account_circle_outlined),
              SizedBox(height: 7.w),
              _buildTile(colors, label: 'Edit Account', onTap: () {}),
              _buildTile(colors, label: 'Delete Account', onTap: () {}),
              _buildTile(colors, label: 'Sign out', onTap: () {
                context.read<AppBloc>().add(LoggedOut());
              }),
              SizedBox(height: 20.w),
              _buildCategoryHead(colors, 'About', Icons.info_outline),
              SizedBox(height: 7.w),
              _buildTile(colors, label: 'More About Us', onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }

  ListTile _buildTile(ThemeNotifier colors,
      {String label = '', void Function()? onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        label,
        style: TextStyle(
            fontSize: 25, fontWeight: FontWeight.w300, color: colors.t1),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 28.w, color: colors.accent),
      onTap: onTap,
    );
  }

  Row _buildCategoryHead(ThemeNotifier colors, String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20.w, color: colors.t2),
        SizedBox(width: 12.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: colors.t2,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  SwitchListTile _buildTheme(ThemeNotifier colors) {
    return SwitchListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 0),
      activeColor: colors.accent,
      title: Text(
        'Dark Mode',
        style: TextStyle(
            fontSize: 25, fontWeight: FontWeight.w300, color: colors.t1),
      ),
      value: colors.isDarkMode,
      onChanged: (bool newValue) async {
        setState(() {
          colors.setTheme(newValue);
        });
      },
    );
  }
}
