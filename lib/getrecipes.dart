import 'dart:convert' as convert;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'recipedetails.dart';

const String _baseURL =
    'karimproject.atwebpages.com';

class Recipe {
  final int id;
  final String title;
  final String imagePath;
  final int ingredientCount;
  final int recipeTime;
  final String description;
  final List<String> ingredients;
  final List<String> instructions;

  Recipe(this.id, this.title, this.imagePath, this.ingredientCount,
      this.recipeTime, this.description, this.ingredients, this.instructions);
}

List<Recipe> _recipes = [];

void updateRecipes(Function(bool success) update) async {
  try {
    final url = Uri.http(_baseURL, 'getRecipes.php');
    final response = await http
        .get(url)
        .timeout(const Duration(seconds: 10));
    _recipes.clear();
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      for (var row in jsonResponse) {
        Recipe recipe = Recipe(
            int.parse(row['recipe_id']),
            row['title'],
            row['image_path'],
            int.parse(row['ingredient_count']),
            int.parse(row['recipe_time']),
            '', [], []);
        _recipes.add(recipe);
      }
      update(true);
    }
  } catch (e) {
    update(false);
  }
}

class ShowRecipes extends StatelessWidget {
  const ShowRecipes({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemCount: _recipes.length,
      itemBuilder: (context, index) {
        final recipe = _recipes[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    RecipeDetailsPage(recipeId: recipe.id),
              ),
            );
          },
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.teal[300],
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(5),
                width: width * 0.9,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        recipe.imagePath,
                        width: width * 0.2,
                        height: width * 0.2,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.fastfood_outlined, size: width * 0.06),
                              const SizedBox(width: 5),
                              Text(
                                recipe.title,
                                style: TextStyle(fontSize: width * 0.045),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.numbers, size: width * 0.06),
                              const SizedBox(width: 5),
                              Text(
                                '${recipe.ingredientCount} Ingredients',
                                style: TextStyle(fontSize: width * 0.04),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.timer, size: width * 0.06),
                              const SizedBox(width: 5),
                              Text(
                                '${recipe.recipeTime} mins',
                                style: TextStyle(fontSize: width * 0.04),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

void fetchRecipeDetails(
    Function(bool success, Recipe? recipe) update, int recipeId) async {
  try {
    final url =
        Uri.http(_baseURL, 'getRecipeDetails.php', {'recipe_id': '$recipeId'});
    final response = await http.get(url).timeout(const Duration(seconds: 10));
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse.isNotEmpty) {
        var row = jsonResponse;
        List<String> ingredients = List<String>.from(row['ingredients']);
        List<String> instructions = List<String>.from(row['instructions']);
        Recipe recipe = Recipe(
          recipeId,
          row['title'],
          row['image_path'],
          row['ingredients'].length,
          int.parse(row['recipe_time']),
          row['description'],
          ingredients,
          instructions,
        );
        update(true, recipe);
      } else {
        update(false, null);
      }
    } else {
      print('Failed to fetch details. Status Code: ${response.statusCode}');
      update(false, null);
    }
  } catch (e) {
    print('Error fetching details: $e');
    update(false, null);
  }
}

void searchRecipeByName(
    Function(String text, List<Recipe> recipes) update, String name) async {
  try {
    final url = Uri.http(_baseURL, 'searchRecipe.php', {'name': name});
    final response = await http.get(url).timeout(const Duration(seconds: 10));
    List<Recipe> searchResults = [];
    if (response.statusCode == 200) {
      final jsonResponse = convert.jsonDecode(response.body);
      int recipeCount = jsonResponse['count'];
      if (jsonResponse['recipes'].isNotEmpty) {
        for (var row in jsonResponse['recipes']) {
          Recipe recipe = Recipe(
            int.parse(row['recipe_id']),
            row['title'],
            row['image_path'],
            int.parse(row['ingredient_count']),
            int.parse(row['recipe_time']),
            '',
            [],
            [],
          );
          searchResults.add(recipe);
        }
        if (recipeCount == 1) {
          update(
              "$recipeCount Recipe Found:", searchResults);
        } else if (recipeCount > 1){
        update(
            "$recipeCount Recipes Found:", searchResults);
        }
      } else {
        update("No recipes found for \"$name\"", []);
      }
    } else {
      update("Failed to fetch data. Status code: ${response.statusCode}", []);
    }
  } catch (e) {
    update("Error fetching data: $e", []);
  }
}
