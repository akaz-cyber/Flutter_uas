import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_flutter/models/recipe.model.dart';
import 'package:uas_flutter/services/recipe/recipe_services.dart';

class RecipeServicesImpl {
  final supabase = Supabase.instance.client;
  final logger = Logger();

  Future<RecipeModel?> fetchRecipeById(int recipeId) async {
    try {
      // Fetch recipe data
      final response = await supabase
          .from('tb_recipes')
          .select('*, tb_users(*)')
          .eq('id', recipeId)
          .single();

      // Increment view count
      await supabase.from('tb_recipes').update({
        'view_count': (response['view_count'] as int) + 1,
      }).eq('id', recipeId);

      logger.i("Successfully fetched recipe with ID: $recipeId");
      return RecipeModel.fromJson(response);
    } catch (error) {
      logger.e("Failed to fetch recipe with ID: $recipeId");
      logger.e(error.toString());
      return null;
    }
  }

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

  Future<List<RecipeModel>> fetchRecipesByUserId(String userId) async {
    try {
      final response = await supabase
          .from('tb_recipes')
          .select('*, tb_users(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      logger.i("Successfully fetched recipes for user $userId");

      return List<RecipeModel>.from(
          response.map((e) => RecipeModel.fromJson(e)));
    } catch (error) {
      logger.e("Failed to fetch recipes for user $userId");
      logger.e(error.toString());
      return [];
    }
  }

  Future<void> deleteRecipe(int recipeId) async {
    try {
      await supabase.from('tb_recipes').delete().eq('id', recipeId);

      logger.i("Successfully deleted recipe with ID: $recipeId");
    } catch (error) {
      logger.e("Failed to delete recipe with ID: $recipeId");
      logger.e(error.toString());
    }
  }

  void subscribeToRecipeChanges(Function callback) {
    supabase
        .channel('public:tb_recipes')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'tb_recipes',
            callback: (payload) {
              logger.i('Change received: ${payload.toString()}');
              callback();
            })
        .subscribe();
  }
}
