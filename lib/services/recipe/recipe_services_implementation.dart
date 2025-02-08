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
          .select('*, tb_users(username)')
          .limit(5)
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
  Future<List<RecipeModel>> fetchFeaturedRecipes() async {
    try {
      final response = await supabase
          .from('tb_recipes')
          .select('*, tb_users(username)')
          .limit(5)
          .order("view_count", ascending: false);

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
          .select('*, tb_users(username)')
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
}
