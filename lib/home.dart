import 'package:flutter/material.dart';
import 'getrecipes.dart';
import 'appdrawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _load = false;

  void update(bool success) {
    setState(() {
      _load = true;
      if (!success) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed to load data')));
      }
    });
  }

  @override
  void initState() {
    updateRecipes(update);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: !_load
                    ? null
                    : () {
                        setState(() {
                          _load = false;
                          updateRecipes(update);
                        });
                      },
                icon: const Icon(Icons.refresh)),
          ],
          title: const Text('Recipes'),
          centerTitle: true,
          backgroundColor: Colors.teal[300],
          foregroundColor: Colors.white,
        ),
        drawer: const AppDrawer(),
        backgroundColor: Colors.teal[400],
        body: _load
            ? const ShowRecipes()
            : const Center(
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ))));
  }
}
