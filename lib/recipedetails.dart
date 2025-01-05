import 'package:flutter/material.dart';
import 'getrecipes.dart';

class RecipeDetailsPage extends StatefulWidget {
  final int recipeId;

  const RecipeDetailsPage({super.key, required this.recipeId});

  @override
  _RecipeDetailsPageState createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  bool _loading = true;
  String _description = '';
  Recipe? _recipe;

  @override
  void initState() {
    super.initState();
    fetchRecipeDetails((success, recipe) {
      setState(() {
        _loading = false;
        if (success && recipe != null) {
          _recipe = recipe;
          _description = recipe.description;
        } else {
          _description = "No description available.";
        }
      });
    }, widget.recipeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_recipe?.title ?? 'Recipe Details'),
        centerTitle: true,
        backgroundColor: Colors.teal[300],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.teal[400],
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _recipe == null
              ? Center(
                  child: Text(
                    _description,
                    style: const TextStyle(fontSize: 18),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.teal[300],
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  _recipe!.imagePath,
                                  width: double.infinity,
                                  height: 300,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.teal[400],
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _recipe!.title,
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Description:',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _description,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'Recipe Time:',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '${_recipe!.recipeTime} minutes',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'Ingredients:',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    for (var ingredient in _recipe!.ingredients)
                                      Text('• $ingredient',
                                          style: const TextStyle(fontSize: 16)),
                                    const SizedBox(height: 20),

                                    Text(
                                      'Instructions:',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    for (var i = 0;
                                        i < _recipe!.instructions.length;
                                        i++)
                                      Text(
                                          '${i + 1}. ${_recipe!.instructions[i]}',
                                          style: const TextStyle(fontSize: 16)),
                                    const SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
