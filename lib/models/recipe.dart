import 'dart:convert';

List<MealModel> mealModelFromJson(String str) => List<MealModel>.from(json.decode(str).map((x) => MealModel.fromJson(x)));

String mealModelToJson(List<MealModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MealModel {
  String? idMeal;
  String? strMeal;
  String? strCategory;
  String? strArea;
  String? strInstructions;
  String? strMealThumb;
  String? strYoutube;
  List<String?> ingredients;
  List<String?> measures;

  MealModel({
    this.idMeal,
    this.strMeal,
    this.strCategory,
    this.strArea,
    this.strInstructions,
    this.strMealThumb,
    this.strYoutube,
    required this.ingredients,
    required this.measures,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) => MealModel(
        idMeal: json["idMeal"],
        strMeal: json["strMeal"],
        strCategory: json["strCategory"],
        strArea: json["strArea"],
        strInstructions: json["strInstructions"],
        strMealThumb: json["strMealThumb"],
        strYoutube: json["strYoutube"],
        ingredients: List.generate(20, (index) => json["strIngredient\${index + 1}"] as String?),
        measures: List.generate(20, (index) => json["strMeasure\${index + 1}"] as String?),
      );

  Map<String, dynamic> toJson() => {
        "idMeal": idMeal,
        "strMeal": strMeal,
        "strCategory": strCategory,
        "strArea": strArea,
        "strInstructions": strInstructions,
        "strMealThumb": strMealThumb,
        "strYoutube": strYoutube,
        for (int i = 0; i < ingredients.length; i++) "strIngredient\${i + 1}": ingredients[i],
        for (int i = 0; i < measures.length; i++) "strMeasure\${i + 1}": measures[i],
      };
}
