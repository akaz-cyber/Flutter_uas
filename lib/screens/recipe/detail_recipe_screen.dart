import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_flutter/models/recipe.model.dart';
import 'package:uas_flutter/models/user.model.dart';
import 'package:uas_flutter/services/bookmark/bookmark_services_impl.dart';
import 'package:uas_flutter/services/recipe/recipe_services_impl.dart';
import 'package:uas_flutter/services/user/user_services_impl.dart';
import 'package:uas_flutter/themes.dart';

class Detailresep extends StatefulWidget {
  final int recipeId;
  const Detailresep({super.key, required this.recipeId});
  @override
  State<Detailresep> createState() => _DetailresepState();
}

class _DetailresepState extends State<Detailresep> {
  // Initialize Supabase instance
  final supabase = Supabase.instance.client;
  final logger = Logger();

  // Services
  final userService = UserServicesImplmpl();
  final recipeService = RecipeServicesImpl();
  final bookmarkService = BookmarkServicesImpl();

  RecipeModel? _detailRecipe;
  UserModel? _loggedUser;
  bool isLoading = true;
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _fetchRecipe();
  }

  Future<void> _toggleBookmark() async {
    bookmarkService.toggleBookmark(_loggedUser!.id!, widget.recipeId);
    _fetchRecipe();
  }

  Future<void> _fetchRecipe() async {
    try {
      UserModel? user = await userService.getUserData();

      RecipeModel? response =
          await recipeService.fetchRecipeById(widget.recipeId);

      if (mounted) {
        setState(() {
          _loggedUser = user;
          _detailRecipe = response;
          isLoading = false;
        });
      }

      await checkIfBookmarked();
    } catch (error) {
      logger.e("Failed to fetch recipe with ID: ${widget.recipeId}");
      if (mounted) {
        setState(() {
          _detailRecipe = null;
          isLoading = false;
        });
      }
    }
  }

  Future<void> checkIfBookmarked() async {
    final response = await bookmarkService.checkIfBookmarked(
      _loggedUser!.id!,
      widget.recipeId,
    );

    setState(() {
      isBookmarked = response;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_detailRecipe == null) {
      return const Center(child: Text("Recipe not found"));
    }

    List<String> parseStringToList(String? data) {
      if (data == null || data.isEmpty) return [];
      return data.split(',').map((e) => e.trim()).toList();
    }

    List<String> ingredientsList =
        parseStringToList(_detailRecipe!.ingredients);
    List<String> stepsList = parseStringToList(_detailRecipe!.steps);
    List<String> stepsImages = parseStringToList(_detailRecipe!.stepsImage);

    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Stack(
                children: [
                  // Container untuk gambar
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(_detailRecipe!.image!),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),

                  // Ikon panah ke kiri (
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((0.8 * 255).toInt()),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Judul resep
              Text(_detailRecipe!.title!, style: semiBoldText20),

              const SizedBox(height: 8),

              // Waktu memasak dan ikon bookmark
              Row(
                children: [
                  const Icon(Icons.access_time,
                      size: 18, color: Colors.black54),
                  const SizedBox(width: 5),
                  Text(
                    _detailRecipe!.timeConsumed!,
                    style: regularText14,
                  ),
                  const Spacer(),
                  IconButton(
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: backgroundPrimary,
                      ),
                      onPressed: () {
                        _toggleBookmark();
                      }),
                ],
              ),

              const SizedBox(height: 8),

              // Nama pembuat resep
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 16,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _detailRecipe!.user!.username!,
                    style: mediumText14,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                _detailRecipe!.description!,
                style: regularText12,
              ),

              const SizedBox(height: 8),

              // Link untuk melihat lebih banyak
              GestureDetector(
                onTap: () {},
                child: Text(
                  "View More",
                  style: mediumText12.copyWith(color: Colors.blue),
                ),
              ),

              const SizedBox(height: 20),

              // Ingredients Section
              Text(
                "Ingredients",
                style: semiBoldText16,
              ),

              const SizedBox(height: 8),

              // Serving Size
              Row(
                children: [
                  const Icon(Icons.restaurant, size: 18, color: Colors.black54),
                  const SizedBox(width: 5),
                  Text(
                    "${_detailRecipe!.serveAmount} serve",
                    style: regularText14,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // List Ingredients
              ...List.generate(ingredientsList.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            ingredientsList[index],
                            style: regularText12.copyWith(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),

              // Steps Section
              Text(
                "Steps",
                style: semiBoldText16,
              ),

              const SizedBox(height: 8),

              // Steps List
              ...List.generate(stepsList.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "${index + 1}",
                                style: semiBoldText14,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              stepsList[index],
                              style:
                                  regularText12.copyWith(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (index < stepsImages.length &&
                          stepsImages[index].isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            stepsImages[index],
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image,
                                    size: 100, color: Colors.grey),
                          ),
                        ),
                      const SizedBox(height: 12),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
