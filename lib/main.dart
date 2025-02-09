import 'package:flutter/material.dart';
import 'package:uas_flutter/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://hkrjemkvfimidgulhslu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhrcmplbWt2ZmltaWRndWxoc2x1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzg3NTQ4MTYsImV4cCI6MjA1NDMzMDgxNn0.UcHCqfHobXa94lIcQly7LbmLAx8b92ciKHOjcfr8rCs',
  );
  runApp(const App());
}
