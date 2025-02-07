import 'package:flutter/foundation.dart';
import 'package:recipe_explorer_pro/models/category_model.dart';
import 'package:recipe_explorer_pro/models/recipe.dart';

import '../services/recipe_service.dart';

class RecipeProvider with ChangeNotifier {
  final RecipeService _recipeService = RecipeService();
  // final Box _favoritesBox = Hive.box('favorites');

  // List<Recipe> _recipes = [];
  // List<Recipe> _filteredRecipes = [];
  List<CategoryModel> _categories = [];
  List<MealModel> _meals = [];
  List<CategoryModel>? get categories => _categories;
  List<MealModel>? get meals => _meals;

  String _searchQuery = '';
  String _selectedCategory = 'All';
  bool _isAscending = true;
  bool? get isAscending => _isAscending;

  Future<void> loadCategories() async {
    try {
      var response = (await _recipeService.getCategories()).map((e) => CategoryModel.fromJson(e)).toList();
      setCategories(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> loadMeals({String? category, String? search}) async {
    try {
      var response = (await _recipeService.getMeals(category: category, search: search)).map((e) => MealModel.fromJson(e)).toList();
      setMeal(response);
      toggleSortOrder();
    } catch (e) {
      rethrow;
    }
  }

  void setCategories(List<CategoryModel> query) {
    _categories = query;
    notifyListeners();
  }

  void setMeal(List<MealModel> query) {
    _meals = query;
    notifyListeners();
  }

  void sortMeals() {
    _meals = List<MealModel>.from(_meals)..sort((a, b) => _isAscending ? (a.strMeal ?? "").compareTo(b.strMeal ?? "") : (b.strMeal ?? "").compareTo(a.strMeal ?? ""));
    notifyListeners();
  }

  void toggleSortOrder() {
    _isAscending = !_isAscending;
    sortMeals();
    notifyListeners();
  }
}
