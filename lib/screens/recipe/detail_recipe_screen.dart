import 'package:flutter/material.dart';
import 'package:uas_flutter/themes.dart';

class Detailresep extends StatefulWidget {
  const Detailresep({super.key});

  @override
  State<Detailresep> createState() => _DetailresepState();
}

class _DetailresepState extends State<Detailresep> {
  bool isBookmarked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Stack(
                children: [
                  // Container untuk gambar
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.image_outlined,
                            size: 40, color: Colors.black54),
                        const SizedBox(height: 8),
                        Text("Recipe’s photo", style: lightText14),
                      ],
                    ),
                  ),

                  // Ikon panah ke kiri (
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha((0.8 * 255).toInt()),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Judul resep
              Text(
                "Spicy chicken burger with French fries",
                style: semiBoldText20,
              ),

              const SizedBox(height: 8),

              // Waktu memasak dan ikon bookmark
              Row(
                children: [
                  const Icon(Icons.access_time,
                      size: 18, color: Colors.black54),
                  const SizedBox(width: 5),
                  Text(
                    "20 min",
                    style: regularText14,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                      color: backgroundPrimary,
                    ),
                    onPressed: () {
                      setState(() {
                        isBookmarked = !isBookmarked;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Nama pembuat resep
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 16,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Muhammad ibnu",
                    style: mediumText14,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ornare velit sit amet ante bibendum, quis maximus sem vulputate.",
                style: regularText12,
              ),

              const SizedBox(height: 8),

              // Link untuk melihat lebih banyak
              GestureDetector(
                onTap: () {},
                child: Text(
                  "View More",
                  style: mediumText12.copyWith(color: Colors.blue),
                ),
              ),

              const SizedBox(height: 20),

              // Ingredients Section
              Text(
                "Ingredients",
                style: semiBoldText16,
              ),

              const SizedBox(height: 8),

              // Serving Size
              Row(
                children: [
                  const Icon(Icons.restaurant, size: 18, color: Colors.black54),
                  const SizedBox(width: 5),
                  Text(
                    "1 serve",
                    style: regularText14,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // List Ingredients
              ...List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text("2 genggam bunga pepaya",
                              style:
                                  regularText12.copyWith(color: Colors.black)),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 20),

              // Steps Section
              Text(
                "Steps",
                style: semiBoldText16,
              ),

              const SizedBox(height: 8),

              // Steps List
              ...List.generate(4, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            "${index + 1}",
                            style: semiBoldText14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ornare velit sit amet ante bibendum.",
                          style: regularText12.copyWith(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
