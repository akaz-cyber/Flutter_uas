import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_flutter/models/user.model.dart';
import 'package:uas_flutter/services/user/user_services_implementation.dart';
import 'package:uas_flutter/themes.dart';

class Detailresep extends StatefulWidget {
  final int recipeId;
  const Detailresep({super.key, required this.recipeId});
  @override
  State<Detailresep> createState() => _DetailresepState();
}

class _DetailresepState extends State<Detailresep> {
  final supabase = Supabase.instance.client;
  final UserService = UserServiceImplementation();
  UserModel? _user;
  Map<String, dynamic>? recipe;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRecipe();
    _fetchLoggedUser();
  }

//bookmark
  void _fetchLoggedUser() {
    UserService.getUserData().then((user) {
      setState(() {
        _user = user;
        isLoading = false;
      });

      if (_user != null) {
        checkIfBookmarked(); // Tambahkan ini
      }
    });
  }

//bookmark
  Future<void> toggleBookmark() async {
    final userId = _user?.id;
    if (userId == null) return;

    if (isBookmarked) {
      await supabase
          .from('tb_bookmark')
          .delete()
          .match({'recipe_id': widget.recipeId, 'user_id': userId});
    } else {
      await supabase.from('tb_bookmark').insert({
        'recipe_id': widget.recipeId,
        'user_id': userId,
      });
    }

    checkIfBookmarked();
  }

  Future<void> fetchRecipe() async {
    try {
      final response = await supabase
          .from('tb_recipes')
          .select('*, tb_users(username)')
          .eq('id', widget.recipeId)
          .single();

      debugPrint("Fetched Recipe: $response");

      if (mounted) {
        setState(() {
          recipe = response;
          isLoading = false;
        });

        if (recipe != null && recipe!['user_id'] != null) {
          fetchRecipeCreator(recipe!['user_id']);
        }
      }
    } catch (error, stacktrace) {
      debugPrint("Error fetching recipe: $error\n$stacktrace");
      if (mounted) {
        setState(() {
          recipe = null;
          isLoading = false;
        });
      }
    }
  }

  Future<void> fetchRecipeCreator(String userId) async {
    try {
      final response =
          await supabase.from('users').select().eq('id', userId).maybeSingle();

      if (mounted) {
        setState(() {
          _user = response != null ? UserModel.fromJson(response) : null;
        });
      }
    } catch (error, stacktrace) {
      debugPrint("Error fetching creator: $error\n$stacktrace");
    }
  }

//bookmark
  bool isBookmarked = false;
//book
  Future<void> checkIfBookmarked() async {
    final userId = _user?.id;
    if (userId == null) return;

    final response = await supabase
        .from('tb_bookmark')
        .select('id')
        .eq('recipe_id', widget.recipeId)
        .eq('user_id', userId)
        .maybeSingle();

    setState(() {
      isBookmarked = response != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (recipe == null) {
      return const Center(child: Text("Recipe not found"));
    }

    List<String> parseStringToList(String? data) {
      if (data == null || data.isEmpty) return [];
      return data.split(',').map((e) => e.trim()).toList();
    }

    List<String> ingredientsList = parseStringToList(recipe!['ingredients']);
    List<String> stepsList = parseStringToList(recipe!['steps']);
    List<String> stepsImages = parseStringToList(recipe!['steps_image']);

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
                        image: NetworkImage(recipe!['image']),
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
              Text(recipe!['title'], style: semiBoldText20),

              const SizedBox(height: 8),

              // Waktu memasak dan ikon bookmark
              Row(
                children: [
                  const Icon(Icons.access_time,
                      size: 18, color: Colors.black54),
                  const SizedBox(width: 5),
                  Text(
                    recipe!['time_consumed'],
                    style: regularText14,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: backgroundPrimary,
                    ),
                    onPressed: toggleBookmark,
                  ),
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
                    recipe!['tb_users']['username'],
                    style: mediumText14,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                recipe!['description'],
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
                    "${recipe!['serve_amount']} serve",
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
                            width: double
                                .infinity, 
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
