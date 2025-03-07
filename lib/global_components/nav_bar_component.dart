import 'package:flutter/material.dart';
import 'package:uas_flutter/screens/bookmark/bookmarked_recipe_screen.dart';
import 'package:uas_flutter/screens/home/home_screen.dart';
import 'package:uas_flutter/screens/profile/profile_screen.dart';
import 'package:uas_flutter/screens/recipe/add_new_recipe_screen.dart';
import 'package:uas_flutter/screens/search/search_recipe_screen.dart';
import 'package:uas_flutter/themes.dart';

class BottomNavbar extends StatefulWidget {
  final int? routerIndex;
  final String? keyword;
  const BottomNavbar({super.key, this.routerIndex, this.keyword});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  int _selectedIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.routerIndex ?? 0;
    _screens = [
      const HomeScreen(),
      SearchRecipeScreen(keyword: widget.keyword ?? ''),
      const BookmarkedRecipeScreen(),
      const ProfileScreen()
    ];
  }

  @override
  Widget build(BuildContext context) {
    Widget customBottomNav() {
      return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          onTap: (i) {
            setState(() {
              _selectedIndex = i;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(top: 15),
                child: Image.asset('assets/icons/home.png',
                    width: 24,
                    color: _selectedIndex == 0 ? backgroundPrimary : grayColor),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(top: 15),
                child: Image.asset('assets/icons/search.png',
                    width: 24,
                    color: _selectedIndex == 1 ? backgroundPrimary : grayColor),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(top: 15),
                child: Image.asset('assets/icons/bookmark.png',
                    width: 24,
                    color: _selectedIndex == 2 ? backgroundPrimary : grayColor),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(top: 15),
                child: Image.asset('assets/icons/profile.png',
                    width: 24,
                    color: _selectedIndex == 3 ? backgroundPrimary : grayColor),
              ),
              label: '',
            )
          ]);
    }

    return Scaffold(
      backgroundColor: whiteColor,
      bottomNavigationBar: customBottomNav(),
      body: Stack(
        children: _screens
            .asMap()
            .map((i, screen) => MapEntry(
                i,
                Offstage(
                  offstage: _selectedIndex != i,
                  child: screen,
                )))
            .values
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Tambahresep()));
        },
        backgroundColor: backgroundPrimary,
        child: Icon(Icons.add, color: whiteColor),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
