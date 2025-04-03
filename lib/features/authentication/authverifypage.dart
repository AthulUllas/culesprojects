import 'package:culesprojects/secrets/authsecret.dart';
import 'package:culesprojects/views/pages/homepage.dart';
import 'package:flutter/material.dart';

class AuthVerify extends StatelessWidget {
  const AuthVerify({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = TextEditingController();
    bool isSuperUser;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: authController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter auth number",
                hintStyle: TextStyle(color: Colors.grey),
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.red,
                    showCloseIcon: true,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 50, right: 20, left: 20),
                    content: Text(
                      "Auth wrong",
                      style: TextStyle(color: Colors.white),
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: Container(
              height: 50,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "Continue",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
