import 'package:culesprojects/features/authentication/authcheck.dart';
import 'package:culesprojects/views/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://xxdxbhtexdwathzbjglk.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh4ZHhiaHRleGR3YXRoemJqZ2xrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDMxNTU3NjEsImV4cCI6MjA1ODczMTc2MX0.CX7YC_WzmbiXOe-u8rXu2FK1R3mkQM2IlKzjkZse2oc",
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Homepage());
  }
}
