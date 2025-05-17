import 'package:culesprojects/secrets/authsecret.dart';
import 'package:culesprojects/utils/colors.dart';
import 'package:culesprojects/utils/snackbar.dart';
import 'package:culesprojects/views/pages/homepage.dart';
import 'package:flutter/material.dart';

class AuthVerify extends StatelessWidget {
  const AuthVerify({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = TextEditingController();
    final colors = Colours();
    bool isSuperUser;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: colors.primaryColor, width: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: authController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter auth number",
                hintStyle: TextStyle(color: colors.textFieldHintColor),
                contentPadding: EdgeInsets.only(left: 12),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              if (authController.text == AuthSecret().userSecret) {
                isSuperUser = false;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Homepage(isSuperUser: isSuperUser),
                  ),
                  (route) => false,
                );
              } else if (authController.text == AuthSecret().adminSecret) {
                isSuperUser = true;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Homepage(isSuperUser: isSuperUser),
                  ),
                  (route) => false,
                );
              } else {
                snackBar("Auth wrong", context);
              }
            },
            child: Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                color: colors.primaryTextColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Continue",
                  style: TextStyle(
                    color: colors.secondaryTextColor,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
