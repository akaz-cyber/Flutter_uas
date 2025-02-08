import 'package:flutter/material.dart';
import 'package:uas_flutter/themes.dart';

class SearchTextFieldComponent extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final VoidCallback callback;
  final String? defaultValue;

  const SearchTextFieldComponent(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.callback,
      this.defaultValue});

  @override
  State<SearchTextFieldComponent> createState() =>
      _SearchTextFieldComponentState();
}

class _SearchTextFieldComponentState extends State<SearchTextFieldComponent> {
  @override
  void initState() {
    super.initState();
    widget.controller.value =
        widget.defaultValue != null && widget.defaultValue!.isNotEmpty
            ? TextEditingValue(text: widget.defaultValue!)
            : TextEditingValue.empty;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.text,
      controller: widget.controller,
      decoration: InputDecoration(
          hintText: widget.hintText,
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
            onTap: () {
              widget.callback();
            },
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
