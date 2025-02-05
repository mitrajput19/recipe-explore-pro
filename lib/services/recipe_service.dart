// lib/services/recipe_service.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:recipe_explorer_pro/models/category_model.dart';


class RecipeService {
  static const String _baseUrl = 'www.themealdb.com';
  static const String _apiKey = '1';

  // Future<List<Recipe>> fetchRecipes({int page = 1, int limit = 20}) async {
  //   final connectivityResult = await Connectivity().checkConnectivity();
  //   final isOnline = connectivityResult != ConnectivityResult.none;
  //
  //   if (!isOnline) {
  //     return _getCachedRecipes();
  //   }
  //
  //   try {
  //     final response = await http.get(
  //       Uri.https(_baseUrl, '/api/json/v1/$_apiKey/search.php', {
  //         's': '', // Empty search to get all meals
  //       }),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       final List<Recipe> recipes = (data['meals'] as List)
  //           .map((meal) => Recipe.fromJson(meal))
  //           .toList();
  //
  //       // Cache recipes
  //       await _cacheRecipes(recipes);
  //
  //       return recipes;
  //     }
  //     throw Exception('Failed to load recipes');
  //   } catch (e) {
  //     if (_recipeBox.isNotEmpty) return _getCachedRecipes();
  //     rethrow;
  //   }
  // }
  //
  // Future<List<Recipe>> searchRecipes(String query) async {
  //   try {
  //     final response = await http.get(
  //       Uri.https(_baseUrl, '/api/json/v1/$_apiKey/search.php', {'s': query}),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       return (data['meals'] as List)
  //           .map((meal) => Recipe.fromJson(meal))
  //           .toList();
  //     }
  //     return [];
  //   } catch (e) {
  //     return [];
  //   }
  // }
  //
  // Future<Recipe> getRecipeDetails(String id) async {
  //   // Check cache first
  //   final cachedRecipe = _recipeBox.values.firstWhere(
  //         (recipe) => recipe.id == id,
  //     orElse: () => _customRecipeBox.values.firstWhere(
  //           (recipe) => recipe.id == id,
  //       orElse: () => throw Exception('Recipe not found'),
  //     ),
  //   );
  //
  //   try {
  //     final response = await http.get(
  //       Uri.https(_baseUrl, '/api/json/v1/$_apiKey/lookup.php', {'i': id}),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       final updatedRecipe = Recipe.fromJson(data['meals'][0]);
  //       await _recipeBox.put(id, updatedRecipe);
  //       return updatedRecipe;
  //     }
  //     return cachedRecipe;
  //   } catch (e) {
  //     return cachedRecipe;
  //   }
  // }
  //
  // Future<void> addCustomRecipe(Recipe recipe) async {
  //   try {
  //     // If using Firestore (uncomment and implement)
  //     // await FirebaseFirestore.instance.collection('recipes').add(recipe.toJson());
  //     await _customRecipeBox.add(recipe);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  //
  // Future<void> _cacheRecipes(List<Recipe> recipes) async {
  //   await _recipeBox.clear();
  //   final Map<String, Recipe> recipeMap = {
  //     for (var recipe in recipes) recipe.id: recipe
  //   };
  //   await _recipeBox.putAll(recipeMap);
  // }
  //
  // List<Recipe> _getCachedRecipes() {
  //   return [
  //     ..._recipeBox.values.toList(),
  //     ..._customRecipeBox.values.toList(),
  //   ];
  // }


  Future<List<dynamic>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse("www.themealdb.com/api/json/v1/1/categories.php"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return  (data['categories'] as List<dynamic>).map((e) => CategoryModel.fromJson(e)).toList();


      }
      return [];
    } catch (e) {
      return [];
    }
  }
}