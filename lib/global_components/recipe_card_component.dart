import 'package:flutter/material.dart';
import 'package:uas_flutter/themes.dart';

class RecipeCardComponent extends StatelessWidget {
  const RecipeCardComponent({super.key});
// Widget untuk Kartu Resep

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  child: Image.network(
                    'https://storyblok-cdn.ef.com/f/60990/1200x666/13ee7171e6/makanan-tradisional-indonesia.png', // Gambar online
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Telor dadar",
                  style: semiBoldText14,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: IconButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.white),
            ),
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // Tambahkan fungsi hapus resep
            },
          ),
        ),
      ],
    );
  }
}
