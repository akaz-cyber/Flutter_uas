import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_flutter/global_components/header_button_component.dart';
import 'package:uas_flutter/models/recipe.model.dart';
import 'package:uas_flutter/models/user.model.dart';
import 'package:uas_flutter/screens/profile/edit_profile_screen.dart';
import 'package:uas_flutter/screens/utility/welcome_screen.dart';
import 'package:uas_flutter/services/user/user_services_impl.dart';
import 'package:uas_flutter/services/recipe/recipe_services_impl.dart';
import 'package:uas_flutter/themes.dart';
import 'package:uas_flutter/global_components/recipe_card_component.dart';
import 'package:uas_flutter/screens/recipe/detail_recipe_screen.dart'; // Import halaman detail resep

final supabase = Supabase.instance.client;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final userService = UserServicesImplmpl();
  final recipeService = RecipeServicesImpl();

  final logger = Logger();

  UserModel? _user;
  // Future<List<RecipeModel>>? _recipesFuture; // Ubah jadi nullable
  Stream<List<Map<String, dynamic>>>? _stream;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    final userData = await userService.getUserData();

    setState(() {
      _user = userData;
      if (_user != null) {
        _stream = supabase
            .from('tb_recipes')
            .stream(primaryKey: ['id'])
            .eq('user_id', _user!.id!)
            .order('created_at', ascending: false);

        logger.i("COOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
        if (_stream != null) {
          logger.i(_stream!.first.toString());
        }
      }
    });
  }

  Future<void> _deleteRecipe(int recipeId) async {
    try {
      await recipeService.deleteRecipe(recipeId);
      // Setelah penghapusan berhasil, muat ulang daftar resep
      _getUserInfo();
    } catch (error) {
      // Tampilkan pesan error jika diperlukan
      SnackBar(content: Text('Gagal menghapus resep: $error'));
    }
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
              ).then((_) => _getUserInfo());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: _user?.profileImage != null
                      ? NetworkImage(_user!.profileImage!)
                      : const AssetImage('assets/images/default_profile.jpg')
                          as ImageProvider,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _user?.username ?? '',
                        style: semiBoldText16.copyWith(
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        _user?.bio ?? '',
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
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const WelcomeScreen()),
                        (Route<dynamic> route) => false,
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
            Expanded(
              child: _stream == null
                  ? const Center(child: CircularProgressIndicator())
                  : StreamBuilder<List<Map<String, dynamic>>>(
                      stream: _stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Gagal memuat resep'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(child: Text('Belum ada resep'));
                        }
                        final recipes = snapshot.data!
                            .map(
                                (data) => RecipeModel.fromJsonWithoutUser(data))
                            .toList();

                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.2,
                          ),
                          itemCount: recipes.length,
                          itemBuilder: (context, index) {
                            final recipe = recipes[index];
                            return RecipeCardComponent(
                              recipe: recipe,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Detailresep(recipeId: recipe.id),
                                  ),
                                );
                              },
                              onDelete: () => _deleteRecipe(recipe.id),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
