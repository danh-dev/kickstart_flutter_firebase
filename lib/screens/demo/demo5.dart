import 'package:flutter/material.dart';

class Demo5 extends StatefulWidget {
  const Demo5({super.key});

  @override
  State<Demo5> createState() => _Demo5State();
}

class _Demo5State extends State<Demo5> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Demo 5'),
      ),
    );
  }
}
