import 'package:cached_network_image/cached_network_image.dart';
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
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    // final recipe = ModalRoute.of(context)!.settings.arguments as MealModel;
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    if (widget.recipe?.strYoutube != null) {
      _controller = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.recipe?.strYoutube ?? "") ?? '',
        flags: const YoutubePlayerFlags(autoPlay: false),
      );
    }
    // });
  }

  @override
  Widget build(BuildContext context) {
    // final recipe = ModalRoute.of(context)!.settings.arguments as MealModel;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, title: Text(widget.recipe?.strMeal ?? "")),
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
