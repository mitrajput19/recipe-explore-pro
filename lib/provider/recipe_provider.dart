import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../services/recipe_service.dart';

class RecipeProvider with ChangeNotifier {
  final RecipeService _recipeService = RecipeService();
  final Box _favoritesBox = Hive.box('favorites');

  // List<Recipe> _recipes = [];
  // List<Recipe> _filteredRecipes = [];
  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isAscending = true;

  // List<Recipe> get recipes => _filteredRecipes;
  // List<Recipe> get favorites => _favoritesBox.values
  //     .map((e) => Recipe.fromJson(e))
  //     .toList();

  // Future<void> loadRecipes() async {
  //   try {
  //     _recipes = await _recipeService.fetchRecipes();
  //     _applyFilters();
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // void _applyFilters() {
  //   _filteredRecipes = _recipes.where((recipe) {
  //     final matchesSearch = recipe.name.toLowerCase()
  //         .contains(_searchQuery.toLowerCase());
  //     final matchesCategory = _selectedCategory == 'All'
  //         || recipe.category == _selectedCategory;
  //     return matchesSearch && matchesCategory;
  //   }).toList();
  //
  //   // _sortRecipes();
  //   notifyListeners();
  // }

  // void _sortRecipes() {
  //   _filteredRecipes.sort((a, b) => _isAscending
  //       ? a.cookingTime.compareTo(b.cookingTime)
  //       : b.cookingTime.compareTo(a.cookingTime));
  // }

  // void toggleFavorite(String recipeId) {
  //   final recipe = _recipes.firstWhere((r) => r.id == recipeId);
  //   if (_favoritesBox.containsKey(recipeId)) {
  //     _favoritesBox.delete(recipeId);
  //   } else {
  //     _favoritesBox.put(recipeId, recipe.toJson());
  //   }
  //   notifyListeners();
  // }

  // void setSearchQuery(String query) {
  //   _searchQuery = query;
  //   _applyFilters();
  // }
  //
  // void setCategory(String category) {
  //   _selectedCategory = category;
  //   _applyFilters();
  // }
  //
  // void toggleSortOrder() {
  //   _isAscending = !_isAscending;
  //   _sortRecipes();
  //   notifyListeners();
  // }
}