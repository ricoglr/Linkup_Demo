import 'package:flutter/material.dart';

import '../screens/add_event_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = isDarkTheme ? Colors.red[900] : Colors.red[700];

    return Scaffold(
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEventScreen()),
          );
        },
        backgroundColor: selectedColor,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              color: _selectedIndex == 0 ? selectedColor : Colors.grey,
              onPressed: () => _onItemTapped(0),
              iconSize: 30,
              padding: const EdgeInsets.only(left: 50, right: 50),
            ),
            IconButton(
              icon: const Icon(Icons.person),
              color: _selectedIndex == 1 ? selectedColor : Colors.grey,
              onPressed: () => _onItemTapped(1),
              iconSize: 30,
              padding: const EdgeInsets.only(left: 50, right: 50),
            ),
          ],
        ),
      ),
    );
  }
}
