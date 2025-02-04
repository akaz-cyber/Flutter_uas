import 'package:flutter/material.dart';
import 'package:uas_flutter/themes.dart';

class SearchTextFieldComponent extends StatelessWidget {
  final String hintText;

  const SearchTextFieldComponent({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          hintText: hintText,
          hintStyle: mediumText12.copyWith(color: grayColor),
          fillColor: grayColorSearchField,
          filled: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          isCollapsed: true,
          contentPadding: const EdgeInsets.all(18),
          suffixIcon: InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: backgroundPrimary,
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              child: Icon(
                Icons.search_rounded,
                color: whiteColor,
              ),
            ),
          )),
    );
  }
}
