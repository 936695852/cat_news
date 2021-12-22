import 'package:flutter/material.dart';

class UnknowPage extends StatelessWidget {
  const UnknowPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Not Fount'),
      ),
      body: const Center(
        child: Text('This screen is not found, try to hit get back first 😁.'),
      ),
    );
  }
}
