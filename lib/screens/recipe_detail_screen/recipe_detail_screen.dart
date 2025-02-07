import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/recipe.dart';

class RecipeDetailScreen extends StatefulWidget {
  final Recipe? recipe;
  const RecipeDetailScreen({super.key, this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  YoutubePlayerController? _controller;
  bool favourite = false;
  var favouriteBox = Hive.box<Recipe>('favorites');

  bool isRecipeInBox(Recipe recipe) {
    for (var i = 0; i < favouriteBox.length; i++) {
      Recipe? existingRecipe = favouriteBox.getAt(i);
      if (existingRecipe?.idMeal == recipe.idMeal) {
        return true;
      }
    }
    return false;
  }

  void deleteRecipe(Recipe recipe) {
    for (var i = 0; i < favouriteBox.length; i++) {
      Recipe? existingRecipe = favouriteBox.getAt(i);
      if (existingRecipe?.idMeal == recipe.idMeal) {
        favouriteBox.deleteAt(i);
        log("deleted successfully");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.recipe?.strYoutube != null) {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.recipe?.strYoutube ?? "") ?? '',
        flags: const YoutubePlayerFlags(autoPlay: false),
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      favourite = isRecipeInBox(widget.recipe!);
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          widget.recipe?.strMeal ?? "",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (favourite) {
                deleteRecipe(widget.recipe!);
                setState(() {
                  favourite = !favourite;
                });
              } else {
                await favouriteBox.add(widget.recipe!);
                setState(() {
                  favourite = !favourite;
                });
              }
            },
            icon: Icon(favourite ? Icons.favorite : Icons.favorite_border),
            color: Colors.red,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(imageUrl: widget.recipe?.strMealThumb ?? ""),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ' ${widget.recipe?.strMeal ?? ""} ',
                    style: Theme.of(context).textTheme.labelLarge!.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  const Text('Ingredients:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...(widget.recipe?.ingredients ?? []).map((i) {
                    if (i == null) {
                      return SizedBox.shrink();
                    }
                    return Text('• ${i ?? ""}');
                  }),
                  const SizedBox(height: 16),
                  const Text('Instructions:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.recipe?.strInstructions ?? ""),
                  SizedBox(
                    height: 20,
                  ),
                  if (_controller != null) ...[
                    Text(
                      "Youtube Video: ",
                      style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    YoutubePlayer(controller: _controller!)
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
