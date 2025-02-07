import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:recipe_explorer_pro/screens/recipe_detail_screen/recipe_detail_screen.dart';

import '../models/recipe.dart';

class FavouriteScreen extends StatefulWidget {
  FavouriteScreen({super.key});

  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  var favouriteBox = Hive.box<Recipe>('favorites');

  void _removeRecipe(int index) {
    setState(() {
      favouriteBox.deleteAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favourites",
          style: Theme.of(context).textTheme.labelLarge!.copyWith(),
        ),
      ),
      body: favouriteBox.isEmpty
          ? Center(
              child: Text(
                "No Data Found",
                style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.black),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12),
              shrinkWrap: true,
              itemCount: favouriteBox.length,
              itemBuilder: (ctx, i) {
                final recipe = favouriteBox.getAt(i);
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
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: CachedNetworkImage(
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                imageUrl: recipe?.strMealThumb ?? "",
                              ),
                            ),
                            Positioned(
                              right: 5,
                              top: 5,
                              child: GestureDetector(
                                onTap: () {
                                  _removeRecipe(i);
                                },
                                child: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
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
                                recipe?.strCategory ?? "",
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
            ),
    );
  }
}
