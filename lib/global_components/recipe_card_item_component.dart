import 'package:flutter/material.dart';
import 'package:uas_flutter/themes.dart';

class NewRecipeCardItem extends StatelessWidget {
  const NewRecipeCardItem(
      {super.key,
      required this.title,
      required this.writter,
      required this.imageUrl});

  /* 
    Default variable untuk component trending book
  */
  final String title;
  final String writter;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 200,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: semiBoldText16,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  writter,
                  style: lightText12,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
