import 'package:flutter/material.dart';
import 'package:uas_flutter/global_components/header_button_component.dart';
import 'package:uas_flutter/global_components/recipe_card_component.dart';
import 'package:uas_flutter/screens/profile/edit_profile_screen.dart';
import 'package:uas_flutter/themes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                  ));
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
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      "https://static.promediateknologi.id/crop/0x0:0x0/0x0/webp/photo/p2/233/2024/04/28/Rendang-206972355.jpg"),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sigit Rendang",
                      style:
                          semiBoldText16.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Penikmat rendang",
                      style: regularText14,
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    // Tambahkan fungsi logout
                  },
                  child: Text("Logout",
                      style: semiBoldText14.copyWith(color: grayColor)),
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
                  crossAxisCount: 2, // Dua kolom
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.2, // Rasio item agar tampilan bagus
                ),
                itemCount: 4, // Jumlah item
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
