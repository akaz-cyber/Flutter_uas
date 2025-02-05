import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_flutter/global_components/recipe_card_item_component.dart';
import 'package:uas_flutter/global_components/recipe_card_item_bg_component.dart';
import 'package:uas_flutter/global_components/search_text_field_component.dart';
import 'package:uas_flutter/themes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final List<NewRecipeCardItem> _trendingBooks = [
  const NewRecipeCardItem(
      imageUrl: "assets/images/default_food01.png",
      writter: "Brian Khrisna",
      title: "Sisi Tergelap Surga"),
  const NewRecipeCardItem(
      imageUrl: "assets/images/default_food02.png",
      writter: "James Clear",
      title: "Atomic Habits"),
  const NewRecipeCardItem(
      imageUrl: "assets/images/default_food03.png",
      writter: "Miura Kouji",
      title: "Blue Box 04"),
];

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  User? _user; 

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  void _getUserInfo() {
    setState(() {
      _user = supabase.auth.currentUser;
    });
  }

  Widget headerSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${_user?.userMetadata?['full_name'] ?? 'User'}', 
                style: semiBoldText20,
              ),
              Text(
                'What are you cooking today?',
                style: regularText14.copyWith(color: grayColor),
              ),
            ],
          ),
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: _user?.userMetadata?['avatar_url'] != null
                ? Image.network(
                    _user!.userMetadata!['avatar_url'],
                    width: 45,
                    height: 45,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/images/default_profile.jpg',
                    width: 45,
                    height: 45,
                    fit: BoxFit.cover,
                  ),
          ),
        ],
      ),
    );
  }

  Widget searchFieldSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: const SearchTextFieldComponent(
          hintText: 'Search your favorite recipe'),
    );
  }

  Widget listTrendingBookSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {},
            child: NewRecipeCardItem(
              imageUrl: _trendingBooks[index].imageUrl,
              title: _trendingBooks[index].title,
              writter: _trendingBooks[index].writter,
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 10);
        },
        itemCount: _trendingBooks.length,
      ),
    );
  }

  Widget listFeaturedBookSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return const NewRecipeCardItemBG(
            title: "Tahu Itil",
            author: 'Ambatukam',
            imageUrl: "assets/images/default_food01.png",
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 10);
        },
        itemCount: 3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: ListView(
        shrinkWrap: false,
        scrollDirection: Axis.vertical,
        children: [
          Container(
            decoration: BoxDecoration(
              color: whiteColor2,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerSection(),
                const SizedBox(height: 30),
                searchFieldSection(),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    'New Recipes',
                    style: semiBoldText16,
                  ),
                ),
                const SizedBox(height: 20),
                listTrendingBookSection(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 30),
            child: Text(
              'Featured recipes',
              style: semiBoldText16,
            ),
          ),
          const SizedBox(height: 20),
          listFeaturedBookSection(),
        ],
      ),
    );
  }
}
