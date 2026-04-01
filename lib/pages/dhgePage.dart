import 'package:flutter/material.dart';

class dhgePage extends StatefulWidget {
  const dhgePage({super.key});

  @override
  State<dhgePage> createState() => _dhgePageState();
}

class _dhgePageState extends State<dhgePage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: .center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('DHGEEEEEEEEEEEE', style: TextStyle(fontSize: 24)),
          Text('Gera', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}
