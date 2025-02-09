import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_flutter/global_components/bookmark_card_recipe.dart';
import 'package:uas_flutter/global_components/header_button_component.dart';
import 'package:uas_flutter/models/recipe.model.dart';
import 'package:uas_flutter/models/user.model.dart';
import 'package:uas_flutter/screens/recipe/detail_recipe_screen.dart';
import 'package:uas_flutter/services/bookmark/bookmark_services_impl.dart';
import 'package:uas_flutter/services/recipe/recipe_services_impl.dart';
import 'package:uas_flutter/services/user/user_services_impl.dart';
import 'package:uas_flutter/themes.dart';

class BookmarkedRecipeScreen extends StatefulWidget {
  const BookmarkedRecipeScreen({super.key});

  @override
  State<BookmarkedRecipeScreen> createState() => _BookmarkedRecipeScreenState();
}

class _BookmarkedRecipeScreenState extends State<BookmarkedRecipeScreen> {
  // supabase & logger instance
  final supabase = Supabase.instance.client;
  final logger = Logger();

  // services
  final userService = UserServicesImplmpl();
  final recipeService = RecipeServicesImpl();
  final bookmarkService = BookmarkServicesImpl();

  // data
  List<RecipeModel> bookmarkedRecipes = [];

  // loading state
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookmarkedRecipes();

    // listen to changes
    bookmarkService.subscribeToBookmarkRecipeChanges(() {
      _fetchBookmarkedRecipes();
    });
  }

  Future<void> _fetchBookmarkedRecipes() async {
    try {
      UserModel? user = await userService.getUserData();
      List<RecipeModel> recipes =
          await bookmarkService.fetchBookmarkRecipes(user!.id!);

      setState(() {
        bookmarkedRecipes = recipes;
        isLoading = false;
      });
    } catch (error) {
      const SnackBar(
        content: Text("Failed to fetch bookmarked recipes"),
        backgroundColor: Colors.red,
      );
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
                                      recipeId: recipe.id,
                                    ),
                                  ),
                                );
                              },
                              child: RecipeCard(
                                title: recipe.title!,
                                author: recipe.user!.username!,
                                imageUrl: recipe.image!,
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
