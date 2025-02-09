import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_flutter/global_components/nav_bar_component.dart';
import 'package:uas_flutter/global_components/recipe_card_item_component.dart';
import 'package:uas_flutter/global_components/recipe_card_item_bg_component.dart';
import 'package:uas_flutter/global_components/search_text_field_component.dart';
import 'package:uas_flutter/models/recipe.model.dart';
import 'package:uas_flutter/services/recipe/recipe_services_impl.dart';
import 'package:uas_flutter/services/user/user_services_impl.dart';
import 'package:uas_flutter/screens/recipe/detail_recipe_screen.dart';
import 'package:uas_flutter/themes.dart';
import 'package:uas_flutter/models/user.model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final logger = Logger();
  final supabase = Supabase.instance.client;
  UserModel? _user;
  List<RecipeModel> _newRecipes = [];
  List<RecipeModel> _featuredRecipes = [];
  bool _isLoading = true;
  final userService = UserServicesImplmpl();
  final recipeService = RecipeServicesImpl();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch initial data
    _fetchLoggedUser();
    _fetchTrendingRecipes();
    _fetchFeaturedRecipes();

    // Subscribe to recipe changes
    recipeService.subscribeToRecipeChanges(() {
      _fetchTrendingRecipes();
      _fetchFeaturedRecipes();
    });

    // Subscribe to user changes
    userService.subscribeToUserChanges(() {
      _fetchLoggedUser();
    });
  }

  void _fetchLoggedUser() {
    userService.getUserData().then((user) => {
          setState(() {
            _user = user;
          })
        });
  }

  void _fetchTrendingRecipes() async {
    List<RecipeModel> recipes = await recipeService.fetchNewRecipes();
    setState(() {
      _newRecipes = recipes;
    });
  }

  void _fetchFeaturedRecipes() async {
    List<RecipeModel> recipes = await recipeService.fetchFeaturedRecipes();
    setState(() {
      _featuredRecipes = recipes;
      _isLoading = false;
    });
  }

  Widget headerSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, ${_isLoading ? '...' : _user?.username}',
                  style: semiBoldText20,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'What are you cooking today?',
                  style: regularText14.copyWith(color: grayColor),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _isLoading
              ? const CircularProgressIndicator()
              : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _user?.profileImage != null
                      ? Image.network(
                          _user!.profileImage!,
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
      child: SearchTextFieldComponent(
        hintText: 'Search your favorite recipe',
        controller: searchController,
        callback: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavbar(
                routerIndex: 1,
                keyword: searchController.text,
              ),
            ),
          );
        },
      ),
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
          final newRecipe = _newRecipes[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Detailresep(recipeId: newRecipe.id),
                ),
              );
            },
            child: NewRecipeCardItem(
              imageUrl: newRecipe.image!,
              title: newRecipe.title!,
              creator: newRecipe.user!.username!, // Add writer if available
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
    if (_isLoading) {
      return Container(
        height: 200,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      height: 180,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final featuredRecipe = _featuredRecipes[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Detailresep(recipeId: featuredRecipe.id),
                ),
              );
            },
            child: NewRecipeCardItemBG(
              title: featuredRecipe.title!,
              author: featuredRecipe.user!.username!.length > 15
                ? '${featuredRecipe.user!.username!.substring(0, 12)}...'
                : featuredRecipe.user!.username!,
              imageUrl: featuredRecipe.image!,
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(width: 10);
        },
         itemCount: _featuredRecipes.length.clamp(0, 3),
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
