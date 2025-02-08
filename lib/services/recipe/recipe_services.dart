import 'package:uas_flutter/models/recipe.model.dart';

abstract class RecipeServices {
  Future<List<RecipeModel>> fetchNewRecipes();
}
