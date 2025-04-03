import 'dart:async';
import 'package:culesprojects/features/authentication/authpage.dart';
import 'package:culesprojects/views/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Authcheck extends StatefulWidget {
  const Authcheck({super.key});

  @override
  State<Authcheck> createState() => _AuthcheckState();
}

class _AuthcheckState extends State<Authcheck> {
  late final StreamSubscription<AuthState> authSubscription;

  @override
  void initState() {
    super.initState();
    authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((
      data,
    ) {
      final session = data.session;

      if (session == null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Authpage()),
          (route) => false,
        );
      } else {
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: ((context) => Homepage())),
        //   (route) => false,
        // );
      }
    });
    refreshAuthState();
  }

  Future<void> refreshAuthState() async {
    try {
      await Supabase.instance.client.auth.refreshSession();
    } catch (e) {
      debugPrint("Session refresh failed: $e");
    }
  }

  // Future<void> refreshAuthState() async {
  //   await Supabase.instance.client.auth.refreshSession();
  // }

  @override
  void dispose() {
    authSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
