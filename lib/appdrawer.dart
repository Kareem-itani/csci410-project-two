import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'home.dart';
import 'search.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Drawer(
          backgroundColor: Colors.teal[400],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal[500],
                ),
                child: SizedBox(
                  height: 50,
                  child: Center(
                    child: Image.asset('assets/images/logo.png')
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.restaurant_menu, color: Colors.white),
                title: const Text('Recipes', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Home()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.search, color: Colors.white),
                title: const Text('Search Recipes', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.white),
                title: const Text('Exit', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(milliseconds: 300), () {
                    SystemNavigator.pop();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
