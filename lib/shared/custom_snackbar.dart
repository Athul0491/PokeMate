import 'package:flutter/material.dart';
import 'package:pokemate/bloc/app_bloc/app_states.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pokemate/themes/theme_notifiers.dart';

SnackBar showCustomSnackBar(BuildContext context, String message) {
  final colors = context.read<ThemeNotifier>();
  return SnackBar(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.w)),
    margin: EdgeInsets.all(15.w),
    behavior: SnackBarBehavior.floating,
    backgroundColor: colors.card,
    content: Row(
      children: [
        Text(
          message,
          style: TextStyle(
            fontSize: 15,
            color: colors.t1,
            fontWeight: FontWeight.w400,
          ),
        ),
        const Spacer(),
        message == LoginPageState.loading.message
            ? SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  color: colors.accent,
                  strokeWidth: 2,
                ),
              )
            : const SizedBox.shrink(),
      ],
    ),
    action: message == LoginPageState.loading.message
        ? null
        : SnackBarAction(
            label: 'OK',
            textColor: colors.accent,
            onPressed: () {},
          ),
  );
}
