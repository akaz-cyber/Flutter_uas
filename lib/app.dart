import 'package:flutter/material.dart';
import 'package:uas_flutter/global_components/nav_bar_component.dart';
import 'package:uas_flutter/screens/home/home_screen.dart';
import 'package:uas_flutter/screens/utility/welcome_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const BottomNavbar(),
    );
  }
}
