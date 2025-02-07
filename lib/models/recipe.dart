import 'package:hive/hive.dart';

part 'recipe.g.dart';

@HiveType(typeId: 0)
class Recipe {
  @HiveField(0)
  String? idMeal;

  @HiveField(1)
  String? strMeal;

  @HiveField(2)
  String? strCategory;

  @HiveField(3)
  String? strArea;

  @HiveField(4)
  String? strInstructions;

  @HiveField(5)
  String? strMealThumb;

  @HiveField(6)
  String? strYoutube;

  @HiveField(7)
  List<String?> ingredients;

  @HiveField(8)
  List<String?> measures;

  Recipe({
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

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        idMeal: json["idMeal"],
        strMeal: json["strMeal"],
        strCategory: json["strCategory"],
        strArea: json["strArea"],
        strInstructions: json["strInstructions"],
        strMealThumb: json["strMealThumb"],
        strYoutube: json["strYoutube"],
        ingredients: List.generate(20, (index) => json["strIngredient${index + 1}"] as String?),
        measures: List.generate(20, (index) => json["strMeasure${index + 1}"] as String?),
      );

  Map<String, dynamic> toJson() => {
        "idMeal": idMeal,
        "strMeal": strMeal,
        "strCategory": strCategory,
        "strArea": strArea,
        "strInstructions": strInstructions,
        "strMealThumb": strMealThumb,
        "strYoutube": strYoutube,
        for (int i = 0; i < ingredients.length; i++) "strIngredient${i + 1}": ingredients[i],
        for (int i = 0; i < measures.length; i++) "strMeasure${i + 1}": measures[i],
      };
}
