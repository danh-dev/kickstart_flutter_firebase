import 'package:flutter/material.dart';

class Demo3 extends StatefulWidget {
  const Demo3({super.key});

  @override
  State<Demo3> createState() => _Demo3State();
}

class _Demo3State extends State<Demo3> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Demo 3'),
      ),
    );
  }
}
