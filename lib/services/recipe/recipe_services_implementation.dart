import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_flutter/models/recipe.model.dart';
import 'package:uas_flutter/services/recipe/recipe_services.dart';

class RecipeServicesImplementation implements RecipeServices {
  final supabase = Supabase.instance.client;
  final logger = Logger();

  @override
  Future<List<RecipeModel>> fetchNewRecipes() async {
    try {
      final response = await supabase
          .from('tb_recipes')
          .select('*')
          .order("created_at", ascending: false);

      logger.i("Successfully fetched new recipes");

      List<RecipeModel> result =
          List<RecipeModel>.from(response.map((e) => RecipeModel.fromJson(e)));

      return result;
    } catch (error) {
      logger.e("Failed to fetch new recipes");
      logger.e(error.toString());
      return [];
    }
  }

  @override
  Future<List<RecipeModel>> searchRecipesByKeyword(String keyword) async {
    try {
      final response = await supabase
          .from('tb_recipes')
          .select('*')
          .ilike('title', '%$keyword%')
          .order("created_at", ascending: false);

      logger.i("Successfully fetched new recipes");

      List<RecipeModel> result =
          List<RecipeModel>.from(response.map((e) => RecipeModel.fromJson(e)));

      return result;
    } catch (error) {
      logger.e("Failed to fetch new recipes");
      logger.e(error.toString());
      return [];
    }
  }

  Future<List<RecipeModel>> fetchRecipesByUserId(String userId) async {
    try {
      final response = await supabase
          .from('tb_recipes')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      logger.i("Successfully fetched recipes for user $userId");

      return List<RecipeModel>.from(response.map((e) => RecipeModel.fromJson(e)));
    } catch (error) {
      logger.e("Failed to fetch recipes for user $userId");
      logger.e(error.toString());
      return [];
    }
  }
  
  @override
Future<void> deleteRecipe(int recipeId) async {
  try {
    await supabase
        .from('tb_recipes')
        .delete()
        .eq('id', recipeId);

    logger.i("Successfully deleted recipe with ID: $recipeId");
  } catch (error) {
    logger.e("Failed to delete recipe with ID: $recipeId");
    logger.e(error.toString());
    throw error; // Anda bisa menangani error ini di UI jika diperlukan
  }
}
}
