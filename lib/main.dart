import 'package:flutter/material.dart';
import 'package:google_maps/widget/custom_googlemap.dart';

void main() {
  runApp(const TestGoogleMaps());
}
class TestGoogleMaps extends StatelessWidget {
  const TestGoogleMaps({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomGoogleMap(),
    );
  }
}

