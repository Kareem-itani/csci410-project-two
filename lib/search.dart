import 'package:flutter/material.dart';
import 'getrecipes.dart';
import 'recipedetails.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controllerName = TextEditingController();
  String _message = '';
  List<Recipe> _searchResults = [];

  @override
  void dispose() {
    _controllerName.dispose();
    super.dispose();
  }

  void updateSearchResults(String message, List<Recipe> recipes) {
    setState(() {
      _message = message;
      _searchResults = recipes;
    });
  }

  void performSearch() {
    String name = _controllerName.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a recipe name')),
      );
    } else {
      searchRecipeByName(updateSearchResults, name);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Recipes'),
        centerTitle: true,
        backgroundColor: Colors.teal[300],
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.teal[400],
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: _controllerName,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Enter Recipe Name',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 15,
                      ),
                    ),
                    onPressed: performSearch,
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _message,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final recipe = _searchResults[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailsPage(recipeId: recipe.id),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
