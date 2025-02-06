import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../models/recipe.dart';

class RecipeDetailScreen extends StatefulWidget {
  final MealModel? recipe;
  const RecipeDetailScreen({super.key, this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final recipe = ModalRoute.of(context)!.settings.arguments as MealModel;
    if (recipe.strYoutube != null) {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(recipe.strYoutube!) ?? '',
        flags: const YoutubePlayerFlags(autoPlay: false),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipe = ModalRoute.of(context)!.settings.arguments as MealModel;

    return Scaffold(
      appBar: AppBar(title: Text(recipe.strMeal ?? "")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (recipe.strYoutube != null) YoutubePlayer(controller: _controller),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cooking Time: ${recipe.measures.toList()} mins'),
                  const SizedBox(height: 16),
                  const Text('Ingredients:', style: TextStyle(fontWeight: FontWeight.bold)),
                  ...recipe.ingredients.map((i) => Text('• $i')),
                  const SizedBox(height: 16),
                  const Text('Instructions:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(recipe.strInstructions ?? ""),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
