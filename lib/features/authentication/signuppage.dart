import 'package:culesprojects/features/authentication/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_regex/flutter_regex.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SignUpPage extends HookWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isPasswordVisible = useState(false);
    final signUpEmailController = useTextEditingController();
    final signUpPasswordController = useTextEditingController();
    // final signUpUserNameController = useTextEditingController();
    final supaBase = Supabase.instance.client;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 62, 49),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Sign Up",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: signUpEmailController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "E - mail",
                  hintStyle: TextStyle(color: Colors.black),
                  contentPadding: EdgeInsets.only(left: 12),
                ),
              ),
            ),
          ),
          // Container(
          //   margin: EdgeInsets.all(16),
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     border: Border.all(color: Colors.black, width: 1),
          //     borderRadius: BorderRadius.circular(10),
          //   ),
          //   child: TextField(
          //     controller: signUpUserNameController,
          //     decoration: InputDecoration(
          //       border: InputBorder.none,
          //       hintText: "Username",
          //       hintStyle: TextStyle(color: Colors.black),
          //       contentPadding: EdgeInsets.only(left: 12),
          //     ),
          //   ),
          // ),
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: signUpPasswordController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () {
                    isPasswordVisible.value = !isPasswordVisible.value;
                  },
                  icon: Icon(
                    isPasswordVisible.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
                border: InputBorder.none,
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.black),
                contentPadding: EdgeInsets.only(left: 12, top: 14),
              ),
              obscureText: !isPasswordVisible.value,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: InkWell(
              onTap: () async {
                if (signUpEmailController.text.isEmail()) {
                  try {
                    await supaBase.auth.signUp(
                      email: signUpEmailController.text,
                      password: signUpPasswordController.text.trim(),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                          bottom: 50,
                          left: 20,
                          right: 20,
                        ),
                        content: Text("Check your mail. Comeback and signIn"),
                        duration: Duration(seconds: 3),
                        showCloseIcon: true,
                      ),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Loginpage()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        margin: EdgeInsets.only(
                          bottom: 50,
                          left: 20,
                          right: 20,
                        ),
                        content: Text(e.toString()),
                        duration: Duration(seconds: 3),
                        showCloseIcon: true,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(bottom: 50, left: 20, right: 20),
                      content: Text("Not a valid email"),
                      duration: Duration(seconds: 3),
                      showCloseIcon: true,
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
                    "SignUp",
                    style: TextStyle(color: Colors.white, fontSize: 18),
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
