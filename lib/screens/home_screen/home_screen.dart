import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_explorer_pro/provider/theme_provider.dart';
import 'package:recipe_explorer_pro/screens/favourite_screen.dart';

import '../../provider/auth_provider.dart';
import '../../provider/recipe_provider.dart';
import '../recipe_detail_screen/recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _logout() async {
    await context.read<AuthProvider>().signOut();
  }

  _toggleTheme() async {
    await context.read<ThemeProvider>().toggleTheme();
  }

  String? category;
  String? search;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: const Icon(
          Icons.person,
        ),
        title: Text(
          'Recipe Explorer Pro',
          style: Theme.of(context).textTheme.labelLarge!.copyWith(color: context.read<ThemeProvider>().isDarkMode ? Colors.white : Colors.black),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavouriteScreen(),
                ),
              );
            },
            child: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          GestureDetector(
            onTap: _logout,
            child: const Icon(Icons.logout),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hello ${authProvider.currentUser?.email ?? ""}",
                    textAlign: TextAlign.left,
                  ),
                  GestureDetector(
                    onTap: _toggleTheme,
                    child: const Text("Toggle Theme"),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(
                  text: "Make your own food,",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: context.read<ThemeProvider>().isDarkMode ? Colors.white : Colors.black),
                  children: [
                    TextSpan(
                      text: "\nStay at ",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: context.read<ThemeProvider>().isDarkMode ? Colors.white : Colors.black),
                    ),
                    const TextSpan(text: "home", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: Colors.orange))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        onChanged: (val) {
                          setState(() {
                            search = val;
                            if (val == "") {
                              search = null;
                            }
                          });
                        },
                        decoration: const InputDecoration(hintText: "Search..."),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        recipeProvider.toggleSortOrder();
                      },
                      icon: const Icon(Icons.sort_by_alpha),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 60,
                child: FutureBuilder(
                  future: recipeProvider.loadCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: (recipeProvider.categories ?? []).length,
                      itemBuilder: (context, index) {
                        final category = recipeProvider.categories?[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              this.category = category?.strCategory;
                            });
                          },
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                height: 40,
                                fit: BoxFit.fitHeight,
                                imageUrl: category?.strCategoryThumb ?? "",
                              ),
                              Text(category?.strCategory ?? "")
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              FutureBuilder(
                future: recipeProvider.loadMeals(category: category, search: search),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Consumer<RecipeProvider>(
                    builder: (context, recipeProvider, child) {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: (recipeProvider.meals ?? []).length,
                        itemBuilder: (ctx, i) {
                          final recipe = recipeProvider.meals?[i];
                          return GestureDetector(
                            onTap: () {
                              log(recipe!.toJson().toString());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecipeDetailScreen(recipe: recipe),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 4,
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Recipe Image
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                    child: CachedNetworkImage(
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      imageUrl: recipe?.strMealThumb ?? "",
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          recipe?.strMeal ?? "",
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          recipe?.strCategory ?? category ?? "",
                                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                                        ),
                                        const SizedBox(height: 10),
                                        const Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
