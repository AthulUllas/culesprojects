import 'package:culesprojects/views/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Loginpage extends HookWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    final isPasswordVisible = useState(false);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final supaBase = Supabase.instance.client;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 62, 49),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Sign In",
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
                controller: emailController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "E - mail",
                  hintStyle: TextStyle(color: Colors.black),
                  contentPadding: EdgeInsets.only(left: 12),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: passwordController,
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
                try {
                  await supaBase.auth.signInWithPassword(
                    email: emailController.text,
                    password: passwordController.text.trim(),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Homepage()),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
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
                    "SignIn",
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
