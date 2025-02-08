import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_flutter/global_components/header_button_component.dart';
import 'package:uas_flutter/global_components/recipe_card_component.dart';
import 'package:uas_flutter/screens/profile/edit_profile_screen.dart';
import 'package:uas_flutter/screens/utility/welcome_screen.dart';
import 'package:uas_flutter/themes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final supabase = Supabase.instance.client;
  User? _user;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  void _getUserInfo() {
    setState(() {
      _user = supabase.auth.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: HeaderButtonComponent(
        title: "Account",
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Profil Pengguna
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: _user?.userMetadata?['avatar_url'] != null
                      ? NetworkImage(_user!.userMetadata!['avatar_url'])
                      : const AssetImage('assets/images/default_profile.jpg')
                          as ImageProvider,
                ),
                const SizedBox(width: 10),
                Expanded(
                  // Mencegah overflow
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _user?.userMetadata?['full_name'] ?? "User",
                        style: semiBoldText16.copyWith(
                            fontWeight: FontWeight.bold),
                        maxLines: 1, // Maksimal 1 baris
                        overflow: TextOverflow
                            .ellipsis, // Tambahkan ... jika terlalu panjang
                      ),
                      Text(
                        "Penikmat kuliner",
                        style: regularText14,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await supabase.auth.signOut();
                    await GoogleSignIn().signOut();
                    if (mounted) {
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const WelcomeScreen()),
                        (Route<dynamic> route) =>
                            false, // Menghapus semua rute sebelumnya
                      );
                    }
                  },
                  child: Text(
                    "Logout",
                    style: semiBoldText14.copyWith(color: grayColor),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            Text("Your Recipes", style: semiBoldText20),

            const SizedBox(height: 20),
            // Daftar Resep dalam Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.2,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return const RecipeCardComponent();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
