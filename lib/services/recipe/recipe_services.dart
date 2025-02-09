import 'package:uas_flutter/models/recipe.model.dart';

abstract class RecipeServices {
  Future<List<RecipeModel>> fetchNewRecipes();
  Future<List<RecipeModel>> fetchFeaturedRecipes();
  Future<List<RecipeModel>> searchRecipesByKeyword(String keyword);
  Future<void> deleteRecipe(int recipeId);

  // Changes handler
  void subscribeToRecipeChanges(Function callback);
}
