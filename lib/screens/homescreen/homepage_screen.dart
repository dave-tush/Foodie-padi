import 'package:flutter/material.dart';
import 'package:foodie_padi_apps/screens/homescreen/cart_screen.dart';
import 'package:foodie_padi_apps/screens/homescreen/explore_screen.dart';
import 'package:foodie_padi_apps/screens/homescreen/favourite_screen.dart';
import 'package:foodie_padi_apps/screens/homescreen/first_screen.dart';
import 'package:foodie_padi_apps/screens/homescreen/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    FirstScreen(),
    ExploreScreen(),
    CartScreen(),
    FavouriteScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (value) => setState(() => _currentIndex = value),
        currentIndex: _currentIndex,
        items: [
          // buttomNavigationBar(icon: Icons.home_outlined, title: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }
}
