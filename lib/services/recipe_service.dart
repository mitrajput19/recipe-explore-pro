import 'dart:convert';

import 'package:http/http.dart' as http;

class RecipeService {

  Future<List<dynamic>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse("https://themealdb.com/api/json/v1/1/categories.php"),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return (data['categories'] as List<dynamic>);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<dynamic>> getMeals({String? category,String? search}) async {
    try {
      var response;
      if (category != null) {
        response = await http.get(
          Uri.parse("https://www.themealdb.com/api/json/v1/1/filter.php?c=$category"),
        );
      }else if(search!=null){
        response = await http.get(
          Uri.parse("https://www.themealdb.com/api/json/v1/1/search.php?s=$search"),
        );
      } else {
        response = await http.get(
          Uri.parse("https://www.themealdb.com/api/json/v1/1/search.php?s="),
        );
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return (data['meals'] as List<dynamic>);
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
