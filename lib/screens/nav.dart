import 'package:flutter/material.dart';
import 'package:netflix_project/screens/home.dart';
import 'package:netflix_project/screens/search.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  List<Widget> screens = [
    HomeScreen(),
    Search(), // Placeholder for Search screen
    Scaffold(), // Placeholder for Coming Soon screen
    Scaffold(), // Placeholder for Downloads screen
    Scaffold(), // Placeholder for More screen
  ];

  int selectedItem = 0;

  Map<String, IconData> navitem = {
    'Home': Icons.home,
    'Search': Icons.search,
    'Coming Soon': Icons.queue_play_next,
    'Downloads': Icons.file_download,
    'More': Icons.menu,
  };

  void onItemTapped(int index) {
    setState(() {
      selectedItem = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedItem],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: navitem.entries.map((entry) {
          return BottomNavigationBarItem(
            icon: Icon(entry.value, size: 18),
            label: entry.key,
          );
        }).toList(),
        currentIndex: selectedItem,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: onItemTapped,
      ),
    );
  }
}
