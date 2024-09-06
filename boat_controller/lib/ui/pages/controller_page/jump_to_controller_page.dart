import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JumpToControllerPage extends StatefulWidget {
  const JumpToControllerPage({super.key});

  @override
  State<JumpToControllerPage> createState() => _JumpToControllerPageState();
}

class _JumpToControllerPageState extends State<JumpToControllerPage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(context, '/connectionFormPage');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue.shade300,
      ),
    );
  }
}
