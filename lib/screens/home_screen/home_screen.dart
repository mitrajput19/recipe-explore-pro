import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_explorer_pro/provider/theme_provider.dart';

import '../../provider/auth_provider.dart';
import '../../provider/recipe_provider.dart';

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
            onTap: _logout,
            child: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 20),
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
                      return Column(
                        children: [
                          CachedNetworkImage(
                            height: 40,
                            fit: BoxFit.fitHeight,
                            imageUrl: category?.strCategoryThumb ?? "",
                          ),
                          Text(category?.strCategory ?? "")
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            // const RecipeSearchBar(),
            Expanded(
              child: FutureBuilder(
                future: recipeProvider.loadMeals(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: (recipeProvider.meals ?? []).length,
                    itemBuilder: (ctx, i) {
                      final recipe = recipeProvider.meals?[i];
                      return GestureDetector(
                        onTap: () {},
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl: recipe?.strMealThumb ?? "",
                              fit: BoxFit.contain,
                            ),
                            Text(
                              recipe?.strMeal ?? "",
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 18, fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //   Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (_) => const AddRecipeScreen()),
          // );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
