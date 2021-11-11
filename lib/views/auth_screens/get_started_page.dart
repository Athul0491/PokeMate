import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/shared/custom_widgets.dart';
import 'package:pokemate/themes/theme_notifiers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pokemate/views/auth_screens/login_screen.dart';
import 'package:pokemate/views/auth_screens/signup_screen.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  _GetStartedPageState createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  String name = '';
  int age = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final colors = context.read<ThemeNotifier>();
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(colors.bgImagePath), fit: BoxFit.cover),
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 25.w),
                  const CustomBackButton(),
                  SizedBox(height: 70.h),
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
                  SizedBox(height: 60.h),
                  Text(
                    "Let's get started",
                    style: TextStyle(
                      height: 1.25.w,
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  SizedBox(height: 25.h),
                  TextFormField(
                    decoration: customInputDecoration(
                        context: context, labelText: 'Name'),
                    style: formTextStyle(colors),
                    onSaved: (value) {
                      name = value ?? '';
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                    },
                  ),
                  SizedBox(height: 20.w),
                  TextFormField(
                    decoration: customInputDecoration(
                        context: context, labelText: 'Age'),
                    style: formTextStyle(colors),
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      age = int.tryParse(value ?? '') ?? 18;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      }
                    },
                  ),
                  SizedBox(height: 25.w),
                  CustomElevatedButton(
                    text: 'Next',
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      _formKey.currentState?.save();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SignupPage(name: name, age: age)));
                    },
                  ),
                  SizedBox(height: 95.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextButton(
                        child: Text(
                          "Login!",
                          style: TextStyle(fontSize: 16, color: colors.accent),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
