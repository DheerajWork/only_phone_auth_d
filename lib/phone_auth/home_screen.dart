import 'package:flutter/material.dart';
import 'package:only_phone_auth_d/Global.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("${Global.uid}"),
      ),
    );
  }
}
