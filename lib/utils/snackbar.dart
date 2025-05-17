import 'package:culesprojects/utils/colors.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

Future<void> snackBar(String message, BuildContext context) async {
  final colors = Colours();
  showFlash(
    context: context,
    duration: Duration(seconds: 1),
    builder: (context, controller) {
      return FlashBar(
        controller: controller,
        content: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 2),
            child: Text(message),
          ),
        ),
        contentTextStyle: TextStyle(
          fontSize: 18,
          color: colors.primaryTextColor,
          fontWeight: FontWeight.bold,
        ),
        position: FlashPosition.top,
        behavior: FlashBehavior.floating,
        margin: EdgeInsets.only(left: 20, right: 20, top: 24),
        backgroundColor: colors.primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        forwardAnimationCurve: Curves.easeInOutCubicEmphasized,
      );
    },
  );
}
