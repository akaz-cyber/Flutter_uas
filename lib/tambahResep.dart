import 'package:flutter/material.dart';

class Tambahresep extends StatefulWidget {
  const Tambahresep({super.key});

  @override
  State<Tambahresep> createState() => _TambahresepState();
}

class _TambahresepState extends State<Tambahresep> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("ini halaman resep"),
      ),
    );
  }
}