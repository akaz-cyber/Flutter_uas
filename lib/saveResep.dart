import 'package:flutter/material.dart';

class Saveresep extends StatefulWidget {
  const Saveresep({super.key});

  @override
  State<Saveresep> createState() => _SaveresepState();
}

class _SaveresepState extends State<Saveresep> {
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved recipes"),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              GridView.builder(
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
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class RecipeCard extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;

  const RecipeCard({
    super.key,
    required this.title,
    required this.author,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(imageUrl,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: Text(
              title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Positioned(
            bottom: 5,
            left: 10,
            child: Text(
              "By $author",
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
