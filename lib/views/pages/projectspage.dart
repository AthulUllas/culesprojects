import 'package:flutter/material.dart';

class Projectspage extends StatelessWidget {
  const Projectspage({super.key, required this.appBarTitle});

  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle), centerTitle: true),
    );
  }
}
