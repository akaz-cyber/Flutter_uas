import 'package:flutter/material.dart';
import 'package:uas_flutter/global_components/recipe_card_item_component.dart';
import 'package:uas_flutter/global_components/recipe_card_item_bg_component.dart';
import 'package:uas_flutter/screens/recipe/add_new_recipe_screen.dart';
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
  @override
  Widget build(BuildContext context) {
    Widget headerSection() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello Asep,', style: semiBoldText20),
                Text('What are you cooking today?',
                    style: regularText14.copyWith(color: grayColor)),
              ],
            ),
            const SizedBox(width: 8),
            Container(
              width: 49,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  image: AssetImage('assets/images/default_profile.jpg'),
                ),
              ),
            )
          ],
        ),
      );
    }

    Widget searchFieldSection() {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 30),
        child: TextField(
          decoration: InputDecoration(
              hintText: 'Find Your Bookmarked Book',
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
        ),
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
                // listCategoriesSection(),
                // const SizedBox(height: 30),
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
       floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>Tambahresep()));
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
    