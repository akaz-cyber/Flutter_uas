import 'package:flutter/material.dart';
import 'package:uas_flutter/global_components/bookmark_card_recipe.dart';
import 'package:uas_flutter/global_components/header_button_component.dart';
import 'package:uas_flutter/global_components/search_text_field_component.dart';
import 'package:uas_flutter/themes.dart';

class SearchRecipeScreen extends StatefulWidget {
  const SearchRecipeScreen({super.key});

  @override
  State<SearchRecipeScreen> createState() => _SearchRecipeScreenState();
}

class _SearchRecipeScreenState extends State<SearchRecipeScreen> {
  final List<Map<String, String>> recipes = [
    {
      "title": "Traditional spare ribs baked",
      "author": "Chef John",
      "image":
          "https://rizvisual.com/wp-content/uploads/2023/02/shutterstock_797685025-1-1-scaled.jpg"
    },
    {
      "title": "Lamb chops with fruity couscous and mint...",
      "author": "Spicy Nelly",
      "image":
          "https://d1hjkbq40fs2x4.cloudfront.net/2024-04-19/files/travel-food-photography-tips_2412-01.jpg"
    },
    {
      "title": "Spice roasted chicken with flavored rice",
      "author": "Mark Kelvin",
      "image":
          "https://d1hjkbq40fs2x4.cloudfront.net/2024-04-19/files/travel-food-photography-tips_2412-01.jpg"
    },
    {
      "title": "Chinese style Egg fried rice with sliced pork...",
      "author": "Laura Wilson",
      "image":
          "https://d1hjkbq40fs2x4.cloudfront.net/2024-04-19/files/travel-food-photography-tips_2412-01.jpg"
    },
    {
      "title": "Chinese style Egg fried rice with sliced pork...",
      "author": "Laura Wilson",
      "image":
          "https://d1hjkbq40fs2x4.cloudfront.net/2024-04-19/files/travel-food-photography-tips_2412-01.jpg"
    },
    {
      "title": "Chinese style Egg fried rice with sliced pork...",
      "author": "Laura Wilson",
      "image":
          "https://d1hjkbq40fs2x4.cloudfront.net/2024-04-19/files/travel-food-photography-tips_2412-01.jpg"
    },
  ];

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
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return RecipeCard(
          title: recipe["title"]!,
          author: recipe["author"]!,
          imageUrl: recipe["image"]!,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: HeaderButtonComponent(
        title: 'Search Recipe',
        leadingIcon: const Icon(Icons.arrow_back),
        onLeadingIconPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const SearchTextFieldComponent(hintText: "Search recipe...."),
              const SizedBox(height: 20),
              Text("Result for 'keyword....'",
                  style: semiBoldText16.copyWith(color: grayColor)),
              const SizedBox(height: 20),
              listResultRecipe()
            ],
          ),
        ),
      ),
    );
  }
}
