import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_flutter/global_components/recipe_card_item_component.dart';
import 'package:uas_flutter/global_components/recipe_card_item_bg_component.dart';
import 'package:uas_flutter/global_components/search_text_field_component.dart';
import 'package:uas_flutter/screens/recipe/detail_recipe_screen.dart';
import 'package:uas_flutter/themes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final logger = Logger();
  final supabase = Supabase.instance.client;
  User? _user;
  List<Map<String, dynamic>> _newRecipes = [];
  bool _isLoading = true;

  Future<void> _fetchTrendingRecipes() async {
    try {
      final response = await supabase
          .from('tb_recipes')
          .select('id, image, title')
          .order("created_at", ascending: false)
          .limit(5);
      setState(() {
        _newRecipes = List<Map<String, dynamic>>.from(response);
        _isLoading = false;
        logger.i("Successfully fetched new recipes");
        logger.i(_newRecipes);
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      logger.e("Failed to fetch new recipes");
      logger.e(error.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _fetchTrendingRecipes();
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
    if (_isLoading) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      height: 200,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final recipe = _newRecipes[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Detailresep(recipeId: _newRecipes[index]['id']),
                ),
              );
            },
            child: NewRecipeCardItem(
              imageUrl: recipe['image'],
              title: recipe['title'],
              writter: '',
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 10);
        },
        itemCount: _newRecipes.length,
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
