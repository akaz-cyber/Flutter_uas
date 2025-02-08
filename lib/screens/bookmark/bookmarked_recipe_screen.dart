import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_flutter/global_components/bookmark_card_recipe.dart';
import 'package:uas_flutter/global_components/header_button_component.dart';
import 'package:uas_flutter/models/user.model.dart';
import 'package:uas_flutter/screens/recipe/detail_recipe_screen.dart';
import 'package:uas_flutter/services/user/user_services_implementation.dart';
import 'package:uas_flutter/themes.dart';

class BookmarkedRecipeScreen extends StatefulWidget {
  const BookmarkedRecipeScreen({super.key});

  @override
  State<BookmarkedRecipeScreen> createState() => _BookmarkedRecipeScreenState();
}

class _BookmarkedRecipeScreenState extends State<BookmarkedRecipeScreen> {
  final supabase = Supabase.instance.client;
  final UserService = UserServiceImplementation();
  UserModel? _user;
  List<Map<String, dynamic>> bookmarkedRecipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLoggedUser();
  }

  void _fetchLoggedUser() async {
    UserService.getUserData().then((user) {
      setState(() {
        _user = user;
      });
      if (_user != null) {
        fetchBookmarkedRecipes();
      }
    });
  }

  Future<void> fetchBookmarkedRecipes() async {
    if (_user == null) return;

    try {
      final response = await supabase
          .from('tb_bookmark')
          .select('tb_recipes(id, title, image, tb_users(username))')
          .eq('user_id', _user!.id!);

      setState(() {
        bookmarkedRecipes = response.map<Map<String, dynamic>>((data) {
          final recipe = data['tb_recipes'];
          return {
            "id": recipe['id'],
            "title": recipe['title'],
            "image": recipe['image'],
            "author": recipe['tb_users']['username'],
          };
        }).toList();
        isLoading = false;
      });
    } catch (error, stacktrace) {
      debugPrint("Error fetching bookmarks: $error\n$stacktrace");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: const HeaderButtonComponent(title: 'Saved Recipes'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookmarkedRecipes.isEmpty
              ? const Center(child: Text("No bookmarks found"))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: bookmarkedRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = bookmarkedRecipes[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Detailresep(
                                      recipeId: recipe["id"],
                                    ),
                                  ),
                                );
                              },
                              child: RecipeCard(
                                title: recipe["title"]!,
                                author: recipe["author"]!,
                                imageUrl: recipe["image"]!,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
