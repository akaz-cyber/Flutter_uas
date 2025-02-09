import 'package:uas_flutter/models/recipe.model.dart';

abstract class BookmarkServices {
  Future<List<RecipeModel>> fetchBookmarkRecipes(String userId);

  // Changes handler
  void subscribeToBookmarkRecipeChanges(Function callback);
}
