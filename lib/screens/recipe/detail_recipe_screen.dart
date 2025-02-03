import 'package:flutter/material.dart';

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
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_outlined, size: 40, color: Colors.black54),
                        SizedBox(height: 8),
                        Text("Recipe’s photo", style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),

                  // Ikon panah ke kiri (posisi di dalam container)
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
                        onPressed: () {
                         
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Judul resep
              const Text(
                "Spicy chicken burger with French fries",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Waktu memasak dan ikon bookmark
              Row(
                children: [
                  const Icon(Icons.access_time, size: 18, color: Colors.black54),
                  const SizedBox(width: 5),
                  const Text(
                    "20 min",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const Spacer(),
                  IconButton(
                   icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border, 
                    color: Color(0xFFED6314),
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
              const Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey, // Jika tidak ada gambar profil
                    radius: 16,
                    child: Icon(Icons.person, color: Colors.white), // Placeholder
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Muhammad ibnu",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              const Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ornare velit sit amet ante bibendum, quis maximus sem vulputate.",
                style: TextStyle(color: Colors.black54),
              ),

              const SizedBox(height: 8),

              // Link untuk melihat lebih banyak
              GestureDetector(
                onTap: () {
                
                },
                child: const Text(
                  "View More",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Ingredients Section
              const Text(
                "Ingredients",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Serving Size
              const Row(
                children: [
                  Icon(Icons.restaurant, size: 18, color: Colors.black54),
                  SizedBox(width: 5),
                  Text(
                    "1 serve",
                    style: TextStyle(color: Colors.black54),
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
                          child: const Text("2 genggam bunga pepaya"),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 20),

              // Steps Section
              const Text(
                "Steps",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus ornare velit sit amet ante bibendum.",
                          style: TextStyle(color: Colors.black54),
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
