import 'package:flutter/foundation.dart';
import 'package:recipe_explorer_pro/models/category_model.dart';

import '../services/recipe_service.dart';

class RecipeProvider with ChangeNotifier {
  final RecipeService _recipeService = RecipeService();
  // final Box _favoritesBox = Hive.box('favorites');

  // List<Recipe> _recipes = [];
  // List<Recipe> _filteredRecipes = [];
  List<CategoryModel> _categories = [];
  List<CategoryModel>? get categories => _categories;

  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isAscending = true;

  Future<void> loadCategories() async {
    try {
      var response = (await _recipeService.getCategories()).map((e) => CategoryModel.fromJson(e)).toList();
      setCategories(response);
    } catch (e) {
      rethrow;
    }
  }

  void setCategories(List<CategoryModel> query) {
    _categories = query;
    notifyListeners();
  }
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
