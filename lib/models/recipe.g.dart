// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeAdapter extends TypeAdapter<Recipe> {
  @override
  final int typeId = 0;

  @override
  Recipe read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Recipe(
      idMeal: fields[0] as String?,
      strMeal: fields[1] as String?,
      strCategory: fields[2] as String?,
      strArea: fields[3] as String?,
      strInstructions: fields[4] as String?,
      strMealThumb: fields[5] as String?,
      strYoutube: fields[6] as String?,
      ingredients: (fields[7] as List).cast<String?>(),
      measures: (fields[8] as List).cast<String?>(),
    );
  }

  @override
  void write(BinaryWriter writer, Recipe obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.idMeal)
      ..writeByte(1)
      ..write(obj.strMeal)
      ..writeByte(2)
      ..write(obj.strCategory)
      ..writeByte(3)
      ..write(obj.strArea)
      ..writeByte(4)
      ..write(obj.strInstructions)
      ..writeByte(5)
      ..write(obj.strMealThumb)
      ..writeByte(6)
      ..write(obj.strYoutube)
      ..writeByte(7)
      ..write(obj.ingredients)
      ..writeByte(8)
      ..write(obj.measures);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
