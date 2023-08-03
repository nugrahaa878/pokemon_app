import 'package:flutter/material.dart';

class HomepageView extends StatelessWidget {
  const HomepageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemon App'),
      ),
      body: const Center(
        child: Text('Ini page homepage pokemon'),
      ),
    );
  }
}
