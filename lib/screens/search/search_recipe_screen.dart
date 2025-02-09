import 'package:flutter/material.dart';
import 'package:uas_flutter/global_components/bookmark_card_recipe.dart';
import 'package:uas_flutter/global_components/header_button_component.dart';
import 'package:uas_flutter/global_components/search_text_field_component.dart';
import 'package:uas_flutter/models/recipe.model.dart';
import 'package:uas_flutter/screens/recipe/detail_recipe_screen.dart';
import 'package:uas_flutter/services/recipe/recipe_services_implementation.dart';
import 'package:uas_flutter/themes.dart';

class SearchRecipeScreen extends StatefulWidget {
  final String? keyword;

  const SearchRecipeScreen({super.key, this.keyword});

  @override
  State<SearchRecipeScreen> createState() => _SearchRecipeScreenState();
}

class _SearchRecipeScreenState extends State<SearchRecipeScreen> {
  final recipeServices = RecipeServicesImplementation();
  final TextEditingController searchController = TextEditingController();

  List<RecipeModel> _filteredRecipes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.keyword != null && widget.keyword!.isNotEmpty) {
      searchController.text = widget.keyword!;
      _searchRecipeByKeyword(widget.keyword!);
    }
  }

  void _searchRecipeByKeyword(String keyword) async {
    setState(() {
      _isLoading = true;
    });

    final recipes = await recipeServices.searchRecipesByKeyword(keyword);

    setState(() {
      _filteredRecipes = recipes;
      _isLoading = false;
    });
  }

  Widget listResultRecipe() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: _filteredRecipes.length,
      itemBuilder: (context, index) {
        final recipe = _filteredRecipes[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Detailresep(recipeId: recipe.id),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: const HeaderButtonComponent(title: 'Search Recipe'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              SearchTextFieldComponent(
                hintText: "Search recipe....",
                controller: searchController,
                callback: () => _searchRecipeByKeyword(searchController.text),
                defaultValue: widget.keyword,
              ),
              const SizedBox(height: 20),
              Text("Result for '${searchController.text}'",
                  style: semiBoldText16.copyWith(color: grayColor)),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : listResultRecipe()
            ],
          ),
        ),
      ),
    );
  }
}
