// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_flutter/global_components/nav_bar_component.dart';
import 'package:uas_flutter/services/user/user_services_impl.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final supabase = Supabase.instance.client;
  final logger = Logger();
  final userService = UserServicesImplmpl();

  @override
  void initState() {
    _setupAuthListener();
    super.initState();
  }

  StreamSubscription? _authSubscription;

  void _setupAuthListener() {
    _authSubscription = supabase.auth.onAuthStateChange.listen((data) {
      if (!mounted) return;

      if (data.event == AuthChangeEvent.signedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const BottomNavbar()),
        );
      }
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel(); // Pastikan listener dihentikan
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildBackground(),
          _buildGradientOverlay(),
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/bg_splash-screen.jpg"),
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            // ignore: deprecated_member_use
            Colors.black.withOpacity(0.2),
            Colors.black.withOpacity(0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/logo.png',
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 280),
          _buildTitle(),
          const SizedBox(height: 10),
          _buildSubtitle(),
          const SizedBox(height: 40),
          _buildGoogleSignInButton(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      "Get Cooking",
      style: GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      "Simple way to find Tasty Recipe",
      style: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.white70,
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        onPressed: () async {
          await userService.googleSignIn();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/google-icon.png',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 10),
              Text(
                "Sign in with Google",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
