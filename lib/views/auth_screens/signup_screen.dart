import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemate/bloc/app_bloc/app_bloc_files.dart';
import 'package:pokemate/shared/custom_snackbar.dart';
import 'package:pokemate/shared/custom_widgets.dart';
import 'package:pokemate/themes/theme_notifiers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignupPage extends StatefulWidget {
  final String name;
  final int age;

  const SignupPage({Key? key, required this.name, required this.age})
      : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String email = 'aadi@gmail.com';
  String password = 'aadi123';
  String stateMessage = '';
  bool showPassword = false;
  bool showConfirmPassword = false;
  EmailStatus emailStatus = EmailStatus.invalid;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final colors = context.read<ThemeNotifier>();
    return BlocConsumer<AppBloc, AppState>(
      listenWhen: (previous, current) => previous != current,
      buildWhen: (previous, current) => previous != current,
      listener: (context, state) {
        if (state is EmailInputState) {
          emailStatus = state.emailStatus;
          print(emailStatus);
        }
        if (state is SignupPageState) {
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
      builder: (context, snapshot) {
        return SafeArea(
          child: Scaffold(
            body: Container(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/${colors.isDarkMode ? 'dark' : 'light'}_bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Signup',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 20.w),
                    Stack(
                      children: [
                        TextFormField(
                          decoration: emailStatus == EmailStatus.valid
                              ? customInputDecoration(
                                      context: context, labelText: 'Email')
                                  .copyWith(
                                  enabledBorder: greenBorder,
                                  focusedBorder: greenBorder,
                                )
                              : customInputDecoration(
                                  context: context, labelText: 'Email'),
                          style: formTextStyle(colors),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!validateEmail(email)) {
                              return 'Invalid email format';
                            }
                            if (emailStatus == EmailStatus.invalid) {
                              return 'This email is already taken!';
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                            if (value.isNotEmpty && validateEmail(email)) {
                              context
                                  .read<AppBloc>()
                                  .add(CheckEmailStatus(email: value));
                            } else {
                              setState(() {
                                emailStatus = EmailStatus.invalid;
                              });
                            }
                          },
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 15.w),
                          height: 55.w,
                          alignment: Alignment.centerRight,
                          child: emailStatus == EmailStatus.loading
                              ? const CircularProgressIndicator()
                              : emailStatus == EmailStatus.valid
                                  ? Icon(
                                      Icons.check,
                                      size: 30.w,
                                      color: Colors.green,
                                    )
                                  : Icon(
                                      Icons.close,
                                      size: 30.w,
                                      color: email == ''
                                          ? Colors.transparent
                                          : Colors.red,
                                    ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.w),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: colors.accent),
                      child: Text(
                        'Signup',
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
                        BlocProvider.of<AppBloc>(context).add(SignupUser(
                          email: email,
                          password: password,
                          name: widget.name,
                          age: widget.age,
                        ));
                      },
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

  bool validateEmail(String email) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  OutlineInputBorder greenBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.green,
      width: 2.w,
      style: BorderStyle.solid,
    ),
    borderRadius: BorderRadius.all(Radius.circular(15.0.w)),
  );
}
