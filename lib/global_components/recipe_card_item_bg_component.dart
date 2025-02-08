import 'package:flutter/material.dart';
import 'package:uas_flutter/themes.dart';

class NewRecipeCardItemBG extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;

  const NewRecipeCardItemBG({
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
                height: double.infinity, width: 250, fit: BoxFit.cover),
          ),
          Container(
            width: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
              ),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 15,
            child: SizedBox(
              width: 220,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: semiBoldText16.copyWith(color: whiteColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "By $author",
                        style: lightText14.copyWith(color: whiteColor),
                      ),
                    ],
                  ),
                  Text("20 min",
                      style: lightText14.copyWith(color: whiteColor)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
