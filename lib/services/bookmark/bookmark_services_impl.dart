import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_flutter/models/recipe.model.dart';

class BookmarkServicesImpl {
  final supabase = Supabase.instance.client;
  final logger = Logger();

  Future<List<RecipeModel>> fetchBookmarkRecipes(String userId) async {
    try {
      final response = await supabase
          .from('tb_bookmark')
          .select('tb_recipes(*, tb_users(username))')
          .eq('user_id', userId);

      logger.i(response);

      logger.i("Successfully fetched bookmarked recipes for user $userId");

      return List<RecipeModel>.from(
          response.map((e) => RecipeModel.fromBookmarksJson(e)));
    } catch (error) {
      logger.e("Failed to fetch bookmarked recipes for user $userId");
      logger.e(error.toString());
      return [];
    }
  }

  void toggleBookmark(String userId, int recipeId) async {
    try {
      final isBookmarked = await checkIfBookmarked(userId, recipeId);

      if (isBookmarked) {
        await supabase
            .from('tb_bookmark')
            .delete()
            .match({'user_id': userId, 'recipe_id': recipeId});
      } else {
        await supabase.from('tb_bookmark').insert({
          'user_id': userId,
          'recipe_id': recipeId,
        });
      }

      logger.i("Successfully toggled bookmark for recipe $recipeId");
    } catch (error) {
      logger.e("Failed to toggle bookmark for recipe $recipeId");
      logger.e(error.toString());
    }
  }

  Future<bool> checkIfBookmarked(String userId, int recipeId) async {
    try {
      final response = await supabase
          .from('tb_bookmark')
          .select('id')
          .eq('recipe_id', recipeId)
          .eq('user_id', userId)
          .maybeSingle();

      logger.i(
          "Successfully checked if recipe $recipeId is bookmarked by user $userId");

      return response != null;
    } catch (error) {
      logger.e(
          "Failed to check if recipe $recipeId is bookmarked by user $userId");
      logger.e(error.toString());
      return false;
    }
  }

  void subscribeToBookmarkRecipeChanges(Function callback) {
    supabase
        .channel('public:tb_bookmark')
        .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'tb_bookmark',
            callback: (payload) {
              logger.i('Change received: ${payload.toString()}');
              callback();
            })
        .subscribe();
  }
}
