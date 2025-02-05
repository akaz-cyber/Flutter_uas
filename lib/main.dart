import 'package:flutter/material.dart';
import 'package:uas_flutter/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

   await Supabase.initialize(
    url: 'https://ncewzecpjyjlbcofclee.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5jZXd6ZWNwanlqbGJjb2ZjbGVlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzgxNDEwNDUsImV4cCI6MjA1MzcxNzA0NX0.UF-1twina2YwZZVVLbs1kaCOnSCfsONV4YArliVrw9w',
  );

  runApp(const App());
}
