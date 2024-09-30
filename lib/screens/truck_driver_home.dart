import 'package:flutter/material.dart';

class TruckDriverHome extends StatelessWidget {
  const TruckDriverHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Truck Driver Home'),
      ),
      body: const Center(
        child: Text('Welcome to Truck Driver Home'),
      ),
    );
  }
}
