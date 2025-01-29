import 'package:flutter/material.dart';
import 'package:uas_flutter/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

   await Supabase.initialize(
    url: 'https://tzuvkoodnjsvdkhgigjx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR6dXZrb29kbmpzdmRraGdpZ2p4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc5NjE3NDEsImV4cCI6MjA1MzUzNzc0MX0.81pglKfTbJE2eiyNon7faIOMMo4I6Akz8UDcqxswBNs',
  );

  runApp(const App());
}
