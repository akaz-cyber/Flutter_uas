import 'package:flutter/material.dart';
import 'package:uas_flutter/themes.dart';

class HeaderButtonComponent extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leadingIcon;
  final VoidCallback? onLeadingIconPressed;
  final List<Widget>? actions;

  const HeaderButtonComponent({
    super.key,
    required this.title,
    this.leadingIcon,
    this.onLeadingIconPressed,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: whiteColor,
      centerTitle: true,
      leading: leadingIcon != null
          ? IconButton(
              icon: leadingIcon!,
              onPressed: onLeadingIconPressed ?? () {
                Navigator.pop(context);
              },
            )
          : null,
      title: Text(title, style: semiBoldText20),
      actions: actions ?? [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
